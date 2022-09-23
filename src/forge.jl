struct ForgeAPIError <: GitForge.ForgeError
    message::String
end

struct ForgeAPINotImplemented <: GitForge.ForgeError
    func::Function
    args::Tuple
    noted::Bool
    api
end

Base.showerror(io::IO, e::ForgeAPINotImplemented) =
    print(io, typeof(e.api), " has not implemented the function $(e.func) for arguments $(typeof.((e.api, e.func, e.args...)))\n  use: @not_implemented(::$(typeof(e.api)), ::typeof($(e.func)), $(join(map(a-> "::$(typeof(a))", e.args), ", ")))")

not_implemented(api, func, args...; noted = true) = throw(ForgeAPINotImplemented(func, args, noted, api))

"""
A forge is an online platform for Git repositories.
The most common example is [GitHub](https://github.com).

`Forge` subtypes can access their respective web APIs.
"""
abstract type Forge end

abstract type ForgeType end

forgeof(::Type) = Nothing

struct FieldContext{Forge, Type, Field}
    FieldContext{Forge}() where {Forge} = new{Forge, nothing, nothing}()
    FieldContext{Forge, Type}() where {Forge, Type} = new{Forge, Type, nothing}()
    FieldContext{Forge, Type, Field}() where {Forge, Type, Field} = new{Forge, Type, Field}()
end

StructTypes.StructType(::Type{<:ForgeType}) = DictType()

construct(::Type{T}, dict::Dict; kw...) where {T <: ForgeType} =
    construct(T, Dict(Symbol(k) => v for (k, v) in dict); kw...)

function construct(::Type{T}, dict::Dict{Symbol}; kw...) where {T <: ForgeType}
    forge = forgeof(T)
    T(;
      (k=> try
           GitForge.constructfield(FieldContext{forge, T, k}(), fieldtype(T, k), get(dict, k, nothing))
       catch
           throw(ForgeAPIError("Error constructing field $T.$k from $(repr(get(dict, k, nothing)))\nAll data: $dict"))
       end
       for k in fieldnames(T))...,
      _extras = (; kw..., (k => v for (k, v) in dict if !hasfield(T, k))...),
      )
end

showfield(type, name) = "$(parentmodule(type)).$(nameof(type)).$name"

"""
    constructfield(::::FieldContext{FORGE, OWNER, FIELD}, FT::Type, val)

Override this with your own FORGE, FORGE and OWNER, or FORGE, OWNER,
and FIELD to handle converting fields and types for your forge.

This allows forges to handle their own date and UUID formats, etc.

Note that untyped JSON objects will convert to named tuples.
"""
constructfield(::FieldContext{FORGE, OWNER, FIELD}, FT::Type, val) where {FORGE, OWNER, FIELD} = try
    constructfrom(FT, val)
catch err
    @error "Could not construct $(showfield(OWNER, FIELD))::$FT from value $(repr(val))" exception=(err,catch_backtrace())
    rethrow(err)
end
    
# all fields should be assingable to nothing because of the @json macro
constructfield(::FieldContext, ::Type, ::Nothing) = nothing

# convert Vectors recursively
constructfield(ctx::FieldContext, ::Type{Union{Vector{FT}, Nothing}}, vec::Vector) where FT =
    [constructfield(ctx, FT, v) for v in vec]

# convert Vectors recursively
constructfield(ctx::FieldContext, ::Type, vec::Vector) where FT =
    [constructfield(ctx, Union{Any, Nothing}, v) for v in vec]

# convert dicts recursively
function constructfield(ctx::FieldContext, ::Type{Union{Dict{K, V}, Nothing}}, dict::Dict) where
    {K, V}
    Dict(construct(K, k) => constructfield(ctx, Union{V, Nothing}, v) for (k,v) in dict)
end

function constructfield(ctx::FieldContext, ::Type{Union{Dict{K, V}, Nothing}}, dict::Dict{K2,V2}) where {K, V, K2 <: Union{AbstractString, Symbol}, V2}
    Dict(construct(K, k) => constructfield(ctx, Union{V, Nothing}, v) for (k,v) in dict)
end

# convert symbol/string dicts with unassociated types into named tuples
function constructfield(ctx::FieldContext, FT::Type{Union{NamedTuple, Nothing}}, dict::Dict{K, V}) where {K <: Union{AbstractString, Symbol}, V}
    constructfrom(FT, (; (Symbol(k) => constructfield(ctx, Union{Any, Nothing}, v)
                                         for (k, v) in dict)...))
end

StructTypes.keyvaluepairs(obj::T) where {T <: ForgeType} = [
    [k=>getfield(obj, k) for k in fieldnames(T) if k != :_extras]...,
    pairs(obj._extras)...,
]

function StructTypes.keywordargs(::Type{T}) where T <: ForgeType
    M = parentmodule(T)
    return if isdefined(M, :DEFAULT_DATEFORMAT)
        (; dateformat=M.DEFAULT_DATEFORMAT)
    else
        NamedTuple()
    end
end

JSON3.write(::StructTypes.DictType, buf, pos, len, v::T; kw...) where {T <: ForgeType} =
    JSON3.write(FieldContext{forgeof(T), T}(), buf, pos, len, v; kw...)

"""
    write(::FieldContext{FORGE, TYPE, FIELD}, buf, pos, len, x; kw...)

Override this for custom JSON3 encodings for a particular forge, forge
and type, or forge, type, and field.

This allows forges to encode their own dates and UUIDs properly.

Returns the new buf, pos, len
"""
write(::FieldContext, buf, pos, len, x; kw...) =
     JSON3.write(StructType(x), buf, pos, len, x; kw...)

# modified from JSON3.write(::DictType, buf, pos, len, x::T; kw...)
function JSON3.write(ctx::FieldContext{FORGE, T}, buf, pos, len, x::T; kw...) where {FORGE, T}
    @writechar '{'

    first = true
    for (k, v) in StructTypes.keyvaluepairs(x)
        if first
            first = false
        else
            @writechar ','
        end
        k == :_extras && continue
        buf, pos, len = JSON3.write(StringType(), buf, pos, len, Base.string(k))
        @writechar ':'
        buf, pos, len = write(FieldContext{FORGE, T, k}(), buf, pos, len, v; kw...)
    end

    for (ek, ev) in pairs(x._extras)
        @writechar ','
        buf, pos, len = JSON3.write(StringType(), buf, pos, len, Base.string(ek))
        @writechar ':'
        buf, pos, len = write(FieldContext{FORGE, T, :_extras}(), buf, pos, len, ev; kw...)
    end

    @writechar '}'
    return buf, pos, len
end

"""
    Endpoint(
        method::Symbol,
        url::$AStr;
        headers::Vector{<:Pair}=HTTP.Header[],
        query::Dict=Dict(),
        allow_404::Bool=false,
    ) -> Endpoint

Contains information on how to call an endpoint.

## Arguments
- `method::Symbol`: HTTP request method to use.
- `url::$AStr`: Endpoint URL, relative to the base URL.

## Keywords
- `headers::Vector{<:Pair}=HTTP.Header[]`: Request headers to add.
- `query::Dict=Dict()`: Query string parameters to add.
- `allow_404::Bool=false`: Sends responses  with 404 statuses to the postprocessor.
"""
struct Endpoint
    method::Symbol
    url::String
    headers::Vector{<:Pair}
    query::Dict
    allow_404::Bool

    function Endpoint(
        method::Symbol, url::AStr;
        headers::Vector{<:Pair}=HTTP.Header[],
        query::Dict=Dict(),
        allow_404::Bool=false,
    )
        return new(method, url, headers, query, allow_404)
    end
end

"""
    base_url(::Forge) -> String

Returns the base URL of all API endpoints.
"""
base_url(::Forge) = ""

"""
    request_headers(::Forge, ::Function) -> Vector{Pair}

Returns the headers that should be added to each request.
"""
request_headers(::Forge, ::Function) = HEADERS

"""
    request_query(::Forge, ::Function) -> Dict

Returns the query string parameters that should be added to each request.
"""
request_query(::Forge, ::Function) = Dict()

"""
    request_kwargs(::Forge, ::Function) -> Dict{Symbol}

Returns the extra keyword arguments that should be passed to `HTTP.request`.
"""
request_kwargs(::Forge, ::Function) = Dict()

"""
    postprocessor(::Forge, ::Function) -> PostProcessor

Returns the [`PostProcessor`](@ref) to be used.
"""
postprocessor(::Forge, ::Function) = DoNothing()

"""
    into(::Forge, ::Function) -> Type

Returns the type that the [`PostProcessor`](@ref) should create from the response.

"""
into(::Forge, ::Function) = Any

"""
    endpoint(::Forge, ::Function, args...) -> Endpoint

Returns an [`Endpoint`](@ref) for a given function.
Trailing arguments are usually important for routing.
For example, [`get_user`](@ref) can take some ID parameter which becomes part of the URL.
"""
endpoint(forge::T, func::Function, args...) where T <: Forge =
    throw(ForgeAPINotImplemented(func, args, false, forge))

macro not_implemented(api::Expr, func::Expr, rest...)
    api_name = length(api.args) == 2 ? api.args[1] : :api
    func_name = func.args[1].args[end]
    rest = [rest[n].head !== :(::) ? rest[n] : :($(Symbol("a$n"))::$(rest[n].args[end])) for n in 1:length(rest)]
    rest_names = map(a-> a.head !== :(::) ? a : a.args[1], rest)
    :(endpoint(api::$(esc((api.args[end]))), $(esc(func)), $(rest...)) = throw(ForgeAPINotImplemented($func_name, ($(rest_names...),), true, $api_name)))
end

"""
    has_rate_limits(::Forge, ::Function) -> Bool

Returns whether or not the forge server uses rate limiting.
"""
has_rate_limits(::Forge, ::Function) = false

"""
    rate_limit_check(::Forge, ::Function) -> Bool

Returns whether or not there is an active rate limit.
If one is found, [`on_rate_limit`](@ref) is called to determine how to react.
"""
rate_limit_check(::Forge, ::Function) = false

"""
    on_rate_limit(::Forge, ::Function) -> OnRateLimit

Returns an [`OnRateLimit`](@ref) that determines how to react to an exceeded rate limit.
"""
on_rate_limit(::Forge, ::Function) = ORL_THROW

"""
    rate_limit_wait(::Forge, ::Function)

Wait for a rate limit to expire.
"""
rate_limit_wait(::Forge, ::Function) = nothing

"""
    rate_limit_period(::Forge, ::Function) -> Period

Compute the amount of time until a rate limit expires.
"""
rate_limit_period(::Forge, ::Function) = nothing

"""
    rate_limit_update!(::Forge, ::Function, ::HTTP.Response)

Update the rate limiter with a new response.
"""
rate_limit_update!(::Forge, ::Function, ::HTTP.Response) = nothing
