"""
A forge is an online platform for Git repositories.
The most common example is [GitHub](https://github.com).

`Forge` subtypes can access their respective web APIs.
"""
abstract type Forge end

"""
    base_url(::Forge) -> String

Returns the base URL of all API endpoints.
"""
base_url(::Forge) = ""

"""
    request_headers(::Forge, ::Function) -> Vector{Pair}

Returns the headers that should be added to each request.
"""
request_headers(::Forge, ::Function) = []

"""
    request_query(::Forge, ::Function) -> Dict

Returns the query string parameters that should be added to each request.
"""
request_query(::Forge, ::Function) = Dict()

"""
    request_kwargs(::Forge, ::Function) -> Dict

Returns the extra keyword arguments that should be passed to `HTTP.request`.
"""
request_kwargs(::Forge, ::Function) = Dict()

"""
    postprocessor(::Forge, ::Function) -> ::Type{<:PostProcessor}

Returns the response postprocessor to be used.
"""
postprocessor(::Forge, ::Function) = DoNothing

"""
    endpoint(::Forge, ::Function, args...) -> String

Returns the endpoint for a given function.
"""
endpoint(f::T, ::Function, args...) where T <: Forge =
    error("$T has not implimented this function")

"""
    into(::Forge, ::Function) -> Type

Returns the type that the postprocessor should create from the response.
"""
into(::Forge, ::Function) = Nothing
