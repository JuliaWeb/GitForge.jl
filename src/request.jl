# Result type.

"""
A `Result{T, E<:Exception}` is returned from every API function.
It encapsulates the value, HTTP response, and thrown exception of the call.
"""
struct Result{T, E<:Exception}
    val::Union{T, Nothing}
    resp::Union{HTTP.Response, Nothing}
    ex::Union{E, Nothing}
end

Result(val::T, resp::HTTP.Response) where T = Result{T, ErrorException}(val, resp, nothing)
Result{T}(e::E) where {T, E <: Exception} = Result{T, E}(nothing, nothing, e)
Result{T}(e::E, resp::HTTP.Response) where {T, E <: Exception} =
    Result{T, E}(nothing, resp, e)

"""
    value(::Result{T}) -> Union{T, Nothing}

Returns the result's value, if any exists.
"""
value(r::Result) = r.val

"""
    response(::Result) -> Union{HTTP.Response, Nothing}

Returns the result's HTTP response, if any exists.
"""
response(r::Result) = r.resp

"""
    exception(::Result{T, E<:Exception}) -> Union{E, Nothing}

Returns the result's thrown exception, if any exists.
"""
exception(r::Result) = r.ex

# Response postprocessing.

"""
Determines the behaviour of [`postprocess`](@ref).
Subtypes must have one type parameter, which is determined by [`into`](@ref).
"""
abstract type PostProcessor end

"""
Does nothing and always returns `nothing`.
"""
struct DoNothing{T} <: PostProcessor end

"""
Parses a JSON response into a given type and returns that object.
"""
struct JSON{T} <: PostProcessor end

"""
    postprocess(::Type{<:PostProcessor}, ::HTTP.Response)

Computes a value from an HTTP response.
This is what is returned by [`value`](@ref).
"""
postprocess(::Type{<:DoNothing}, ::HTTP.Response) = nothing
postprocess(::Type{JSON{T}}, r::HTTP.Response) where T = JSON2.read(IOBuffer(r.body), T)

# Requests.

"""
    request(
        f::Forge, fun::Function, ep::Endpoint;
        headers::Vector{<:Pair}=HTTP.Header[],
        query::AbstractDict=Dict(),
        body=HTTP.nobody,
        kwargs...,
    ) -> Result{T, E<:Exception}

Make an HTTP request and return a [`Result`](@ref).
`T` is determined by [`into`](@ref).

## Arguments
- `f::Forge` A [`Forge`](@ref) subtype.
- `fun::Function`: The API function being called.
- `ep::Endpoint`: The endpoint information.

## Keywords
- `query::AbstractDict=Dict()`: Query string parameters to add to the request.
- `headers::Vector{<:Pair}=HTTP.Header[]`: Headers to add to the request.
- `body=HTTP.nobody`: Request body.`
Trailing keywords are passed into `HTTP.request`.

!!! note
    Every API function passes its keyword arguments into this function.
    Therefore, to customize behaviour for a single request, pass the above keywords to the API function.
"""
function request(
    f::Forge, fun::Function, ep::Endpoint;
    headers::Vector{<:Pair}=HTTP.Header[],
    query::AbstractDict=Dict(),
    body=HTTP.nobody,
    kwargs...,
)
    T = into(f, fun)

    if rate_limit_check(f, fun)
        orl = on_rate_limit(f, fun)
        if orl === ORL_RETURN
            return Result{T}(RateLimited(rate_limit_period(f, fun)))
        elseif orl === ORL_WAIT
            rate_limit_wait(f, fun)
        else
            @warn "Ignoring unknown rate limit behaviour $orl"
        end
    end

    url = base_url(f) * ep.url
    headers = vcat(request_headers(f, fun), ep.headers, headers)
    query = merge(request_query(f, fun), ep.query, query)
    kwargs = merge(request_kwargs(f, fun), Dict(pairs(kwargs)))

    resp = try
        HTTP.request(
            ep.method, url, headers, body;
            # Never throw status exceptions, we'll handle the status ourselves.
            query=query, kwargs..., status_exception=false,
        )
    catch e
        return Result{T}(e)
    end

    rate_limit_update!(f, fun, resp)

    resp.status >= 300 && return Result{T}(HTTP.StatusError(resp.status, resp), resp)

    val = try
        postprocess(postprocessor(f, fun){T}, resp)
    catch e
        return Result{T}(e, resp)
    end

    return Result(val, resp)
end
