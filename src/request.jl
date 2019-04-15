# Result type.

"""
A `Result{T}` is returned from every API function.
It encapsulates the value, HTTP response, and thrown exception of the call.
"""
struct Result{T}
    val::Union{T, Nothing}
    resp::Union{HTTP.Response, Nothing}
    ex::Union{Exception, Nothing}
    st::StackTraces.StackTrace
end

Result(val::T, resp::HTTP.Response) where T = Result{T}(val, resp, nothing, [])
Result{T}(
    e::Exception,
    bt::Vector{Union{Ptr{Nothing}, Base.InterpreterIP}},
    resp::Union{HTTP.Response, Nothing}=nothing,
) where T = Result{T}(nothing, resp, e, stacktrace(bt))

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
    exception(::Result{T}) -> Union{Tuple{Exception, Vector{StackFrame}}, Nothing}

Returns the result's thrown exception and stack trace, if any exists.
"""
exception(r::Result) = r.ex === nothing ? nothing : (r.ex, r.st)

# Response postprocessing.

"""
Determines the behaviour of [`postprocess`](@ref).
"""
abstract type PostProcessor end

"""
Does nothing and always returns `nothing`.
"""
struct DoNothing <: PostProcessor end

"""
    JSON(f::Function=identity) -> JSON

Parses a JSON response into a given type and runs `f` on that object.
"""
struct JSON <: PostProcessor
    f::Function
end
JSON() = JSON(identity)

"""
    DoSomething(::Function) -> DoSomething

Runs a user-defined postprocessor.
"""
struct DoSomething <: PostProcessor
    f::Function
end

"""
    postprocess(::PostProcessor, ::HTTP.Response, ::Type{T})

Computes a value from an HTTP response.
This is what is returned by [`value`](@ref).
"""
postprocess(::DoNothing, ::HTTP.Response, ::Type) = nothing
postprocess(p::JSON, r::HTTP.Response, ::Type{T}) where T =
    p.f(JSON2.read(IOBuffer(r.body), T))
postprocess(p::DoSomething, r::HTTP.Response, ::Type) = p.f(r)

# Requests.

"""
    request(
        f::Forge, fun::Function, ep::Endpoint;
        headers::Vector{<:Pair}=HTTP.Header[],
        query::AbstractDict=Dict(),
        request_opts=Dict(),
        kwargs...,
    ) -> Result{T}

Make an HTTP request and return a [`Result`](@ref).
`T` is determined by [`into`](@ref).

## Arguments
- `f::Forge` A [`Forge`](@ref) subtype.
- `fun::Function`: The API function being called.
- `ep::Endpoint`: The endpoint information.

## Keywords
- `query::AbstractDict=Dict()`: Query string parameters to add to the request.
- `headers::Vector{<:Pair}=HTTP.Header[]`: Headers to add to the request.
- `request_opts=Dict()`: Keywords passed into `HTTP.request`.

Trailing keywords are sent as a JSON body for `PATCH`, `POST`, and `PUT` requests.
For other request types, the keywords are sent as query string parameters.

!!! note
    Every API function passes its keyword arguments into this function.
    Therefore, to customize behaviour for a single request, pass the above keywords to the API function.
"""
function request(
    f::Forge, fun::Function, ep::Endpoint;
    headers::Vector{<:Pair}=HTTP.Header[],
    query::AbstractDict=Dict(),
    request_opts=Dict(),
    kwargs...,
)
    T = into(f, fun)

    if has_rate_limits(f, fun) && rate_limit_check(f, fun)
        orl = on_rate_limit(f, fun)
        if orl === ORL_RETURN
            return Result{T}(RateLimited(rate_limit_period(f, fun)), backtrace())
        elseif orl === ORL_WAIT
            rate_limit_wait(f, fun)
        else
            @warn "Ignoring unknown rate limit behaviour $orl"
        end
    end

    url = base_url(f) * ep.url
    headers = vcat(request_headers(f, fun), ep.headers, headers)
    query = merge(request_query(f, fun), ep.query, query)
    opts = merge(request_kwargs(f, fun), Dict(pairs(request_opts)))
    body = if ep.method in (:PATCH, :POST, :PUT)
        JSON2.write(Dict(kwargs))
    else
        merge!(query, Dict(kwargs))
        HTTP.nobody
    end

    resp = try
        HTTP.request(
            ep.method, url, headers, body;
            # Never throw status exceptions, we'll handle the status ourselves.
            query=query, opts..., status_exception=false,
        )
    catch e
        return Result{T}(e, catch_backtrace())
    end

    has_rate_limits(f, fun) && rate_limit_update!(f, fun, resp)

    resp.status >= 300 && !(resp.status == 404 && ep.allow_404) &&
        return Result{T}(HTTP.StatusError(resp.status, resp), backtrace(), resp)

    val = try
        postprocess(postprocessor(f, fun), resp, T)
    catch e
        return Result{T}(e, catch_backtrace(), resp)
    end

    return Result(val, resp)
end
