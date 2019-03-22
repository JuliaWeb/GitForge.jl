# TODO: GitHub's list users only uses `since`.
# TODO: The 'last' rel is not always present: https://docs.gitlab.com/ce/api/#other-pagination-headers.
#       I think GitHub does something similar.

export paginate

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

"""
    paginate(fun::Function, f::Forge, args...; kwargs...) -> Paginator

Create an iterator that paginates the results of repeatedly calling `fun(f, args...; kwargs...)`.
`fun` must return `Result{Vector{T}}`.
"""
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
        p.page == p.last && return nothing
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

function unescape(url::AbstractString)
    ms = eachmatch(r"[\?&](.*?)=(.*?)(?:&|$)", url; overlap=true)
    return Dict(m[1] => m[2] for m in ms)
end

function parserels(link::AbstractString)
    nextm = match(r"(<.*?)>; rel=\"next\"", link)
    lastm = match(r"(<.*?)>; rel=\"last\"", link)
    nextd = nextm === nothing ? nothing : unescape(nextm[1])
    lastd = lastm === nothing ? nothing : unescape(lastm[1])
    return nextd, lastd === nothing ? nothing : get(lastd, "page", nothing)
end
