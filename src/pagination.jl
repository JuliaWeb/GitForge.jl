# TODO: GitHub's list users only uses `since`.

export @paginate

"""
    @paginate fun(args...; kwargs...) page=1 per_page=100 -> Paginator

Create an iterator that paginates the results of repeatedly calling `fun(args...; kwargs...)`.
The first argument of `fun` must be a [`Forge`](@ref) and it must return a `Tuple{Vector{T}, HTTP.Response}`.

## Keywords
- `page::Int=1`: Starting page.
- `per_page::Int=100`: Number of entries per page.
"""
macro paginate(ex::Expr, kws::Expr...)
    (ex.args[2] isa Expr && ex.args[2].head === :parameters) ||
        insert!(ex.args, 2, Expr(:parameters))
    append!(ex.args[2].args, map(kw -> Expr(:kw, kw.args...), kws))
    insert!(ex.args, 3, ex.args[1])
    isempty(ex.args[2].args) && deleteat!(ex.args, 2)
    ex.args[1] = :(GitForge.paginate)
    esc(ex)
end

mutable struct Paginator{T, F<:Function}
    f::F
    xs::Vector{T}
    page::Int
    next::Dict{String, String}
    last::Int
    resp::HTTP.Response

    Paginator{T}(f::F) where {T, F <: Function} = new{T, F}(f, T[], 1, Dict(), typemax(Int))
end

function Paginator{T}(
    f::Function, args::Tuple, kwargs::Pairs, page::Int, per_page::Int,
) where T
    pages = Dict("page" => page, "per_page" => per_page)
    query = merge(get(kwargs, :query, Dict()), pages)
    return Paginator{T}(q -> f(args...; kwargs..., query=merge(query, q)))
end

Base.IteratorSize(::GitForge.Paginator) = Base.SizeUnknown()
Base.IteratorEltype(::GitForge.Paginator) = Base.HasEltype()
Base.eltype(::GitForge.Paginator{T}) where T = T

function paginate(
    fun::Function, f::Forge, args...;
    page::Int=1, per_page::Int=100, kwargs...,
)
    V = into(f, fun)
    V <: Vector || throw(ArgumentError("Function must return Vector{T}"))
    return Paginator{eltype(V)}(fun, (f, args...), kwargs, page, per_page)
end

function Base.iterate(p::Paginator, state=nothing)
    # The state is nothing when we are starting a new page.
    it = state === nothing ? iterate(p.xs) : iterate(p.xs, state)
    if it === nothing
        # This page is finished, so either fetch a new page or quit.
        p.page > p.last && return nothing
        nextpage!(p)
        return iterate(p)
    else
        # More results in the page.
        x, state = it
        return (x, p.resp), state
    end
end

Base.collect(p::Paginator{T}) where T = foldl((acc, (x, _)) -> push!(acc, x), p; init=T[])

function nextpage!(p::Paginator)
    xs, p.resp = p.f(p.next)
    empty!(p.xs)
    append!(p.xs, xs)
    p.page += 1
    next, last = parserels(HTTP.header(p.resp, "Link"))
    next === nothing || (p.next = next)
    # If we didn't get any result for the next page, assume this is the last one.
    p.last = last === nothing ? p.page - 1 : last
    return p
end

function unescape(url::AStr)
    ms = eachmatch(r"[\?&](.*?)=(.*?)(?:&|$)", url; overlap=true)
    return Dict(m[1] => m[2] for m in ms)
end

function parserels(link::AStr)
    nextm = match(r"(<.*?)>; rel=\"next\"", link)
    lastm = match(r"(<.*?)>; rel=\"last\"", link)
    nextd = nextm === nothing ? nothing : unescape(nextm[1])
    lastd = lastm === nothing ? nothing : unescape(lastm[1])
    last = if lastd == nothing
        nothing
    else
        l = get(lastd, "page", nothing)
        l === nothing ? nothing : parse(Int, l)
    end
    return nextd, last
end
