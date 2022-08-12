# Exceptions.

"""
The supertype of all other exceptions raised by API functions.
"""
abstract type ForgeError <: Exception end

"""
An error encountered during the HTTP request.

## Fields
- `response::Union{HTTP.Response, Nothing}`: Set for status exceptions.
- `exception::Exception`
- `stacktrace::StackTrace`
"""
struct HTTPError{E<:Exception} <: ForgeError
    response::Union{HTTP.Response, Nothing}
    exception::E
    stacktrace::StackTrace
end

HTTPError(ex::Exception, st::StackTrace) = HTTPError(nothing, ex, st)

"""
An error encountered during response postprocessing.

## Fields
- `response::HTTP.Response`
- `exception::Exception`
- `stacktrace::StackTrace`
"""
struct PostProcessorError{E<:Exception} <: ForgeError
    response::HTTP.Response
    exception::E
    stacktrace::StackTrace
end

"""
A signal that a rate limit has been exceeded.

## Fields
- `period::Union{Period, Nothing}` Amount of time until rate limit expiry, if known.
"""
struct RateLimitedError <: ForgeError
    period::Union{Period, Nothing}
end

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

Computes a value to be returned from an HTTP response.
"""
postprocess(::DoNothing, ::HTTP.Response, ::Type) = nothing
postprocess(p::JSON, r::HTTP.Response, ::Type{T}) where T =
    p.f(JSON3.read(IOBuffer(r.body), T))
postprocess(p::DoSomething, r::HTTP.Response, ::Type) = p.f(r)

# Requests.

"""
    request(
        f::Forge, fun::Function, ep::Endpoint;
        headers::Vector{<:Pair}=HTTP.Header[],
        query::AbstractDict=Dict(),
        request_opts=Dict(),
        kwargs...,
    ) -> T, HTTP.Response

Make an HTTP request and return `T` and the response, where `T` is determined by [`into`](@ref).

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
    if has_rate_limits(f, fun) && rate_limit_check(f, fun)
        orl = on_rate_limit(f, fun)
        if orl === ORL_THROW
            throw(RateLimitedError(rate_limit_period(f, fun)))
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
        JSON3.write(kwargs)
    else
        merge!(query, kwargs)
        HTTP.nobody
    end

    resp = try
        HTTP.request(
            ep.method, url, headers, body;
            query=query, opts...,
            status_exception=false, # We handle status exceptions ourselvse.
        )
    catch e
        throw(HTTPError(e, stacktrace(catch_backtrace())))
    end

    has_rate_limits(f, fun) && rate_limit_update!(f, fun, resp)

    resp.status >= 300 && !(resp.status == 404 && ep.allow_404) &&
        throw(HTTPError(resp, HTTP.StatusError(resp.status, resp), stacktrace()))

    return try
        postprocess(postprocessor(f, fun), resp, into(f, fun)), resp
    catch e
        throw(PostProcessorError(resp, e, stacktrace(catch_backtrace())))
    end
end
