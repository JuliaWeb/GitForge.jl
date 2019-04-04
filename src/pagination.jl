# TODO: GitHub's list users only uses `since`.

export @paginate

"""
    @paginate fun(args...; kwargss...) page=1 per_page=100 -> Paginator

Create an iterator that paginates the results of repeatedly calling `fun(args...; kwargs...)`.
`fun` must take a [`Forge`](@ref) as its first argument and return a `Result{Vector{T}}`.

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

mutable struct Paginator{T}
    f::Function
    page::Int
    next::Dict
    last::Int
    r::Result{Vector{T}}

    function Paginator{T}(
        f::Function, args::Tuple, kwargs::Iterators.Pairs,
        page::Int, per_page::Int,
    ) where T
        pager = Dict("page" => page, "per_page" => per_page)
        query = merge(get(kwargs, :query, Dict()), pager)
        return new{T}(
            q::Dict -> f(args...; kwargs..., query=merge(query, q)),
            page, Dict(), typemax(Int),
        )
    end
end

function paginate(
    fun::Function, f::Forge, args...;
    page::Int=1, per_page::Int=100, kwargs...,
)
    V = into(f, fun)
    V <: Vector || throw(ArgumentError("Function must return Result{Vector{T}}"))
    return Paginator{eltype(V)}(fun, (f, args...), kwargs, page, per_page)
end

function Base.iterate(p::Paginator, state=nothing)
    # If we have no results yet, fetch one.
    isdefined(p, :r) || (p.r = p.f(p.next))
    exception(p.r) === nothing || return nothing

    # The state is nothing when we are starting a new page.
    it = state === nothing ? iterate(value(p.r)) : iterate(value(p.r), state)
    if it === nothing
        # This page is finished, so either fetch a new page or quit.
        p.page > p.last && return nothing
        nextpage!(p) || return nothing
        return iterate(p)
    else
        # More results in the page.
        return it
    end
end

function nextpage!(p::Paginator)
    p.r = p.f(p.next)
    exception(p.r) === nothing || return false
    p.page += 1
    next, last = parserels(HTTP.header(response(p.r), "Link"))
    next === nothing || (p.next = next)
    last === nothing || (p.last = last)
    return true
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
