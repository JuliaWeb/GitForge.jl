# Response postprocessing.

abstract type PostProcessor end

struct DoNothing{T} <: PostProcessor end
postprocess(::Type{<:DoNothing}, ::HTTP.Response) = nothing

struct JSON{T} <: PostProcessor end
postprocess(::Type{JSON{T}}, r::HTTP.Response) where T = JSON2.read(IOBuffer(r.body), T)

# Response type.

struct Response{T, E<:Exception}
    val::Union{T, Nothing}
    resp::Union{HTTP.Response, Nothing}
    ex::Union{E, Nothing}
end

Response(val::T, resp::HTTP.Response) where T =
    Response{T, ErrorException}(val, resp, nothing)
Response{T}(e::E, resp::HTTP.Response) where {T, E <: Exception} =
    Response{T, E}(nothing, resp, e)
Response{T}(e::E) where {T, E <: Exception} = Response{T, E}(nothing, nothing, e)

value(r::Response) = r.val
response(r::Response) = r.resp
exception(r::Response) = r.ex

# Requests.

function request(
    f::Forge, fun::Function, url::AbstractString, method::Symbol, ::Type{T};
    headers::Vector{<:Pair}=HTTP.Header[],
    query::AbstractDict=Dict(),
    body=HTTP.nobody,
    kwargs...,
) where T
    url = base_url(f) * url
    headers = vcat(request_headers(f), request_headers(f, fun), headers)
    query = merge(request_query(f), request_query(f, fun), query)
    kwargs = merge(request_kwargs(f), request_kwargs(f, fun), Dict(pairs(kwargs)))

    resp = try
        HTTP.request(
            method, url, headers, body;
            # Don't allow overriding the query, we already have a method for that.
            # Never throw status exceptions, we'll handle the status ourselves.
            kwargs..., query=query, status_exception=false,
        )
    catch e
        return Response{T}(e)
    end

    resp.status >= 300 && return Response{T}(HTTP.StatusError(resp.status, resp), resp)

    val = try
        postprocess(postprocessor(f){T}, resp)
    catch e
        return Response{T}(e, resp)
    end

    return Response(val, resp)
end
