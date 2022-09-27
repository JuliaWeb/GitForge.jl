@kwdef struct Page{OP, T} <: GitForge.ForgeType
    size::Int
    page::Int
    pagelen::Int
    next::Union{Nothing, String}
    values::Vector{T}
    _extras::NamedTuple
end

struct BBPaginator{FRG, P}
    api::FRG
    page::P
    BBPaginator(api::FRG, page::Page) where {FRG <: Forge} = new{FRG, P}(api, page)
end

paginate(api::BitbucketAPI, f::Function, args...) = paginate(api, f(api, args...))

paginate(api::BitbucketAPI, (page, _resp)::Tuple{Page, HTTP.Response}) = BBPaginator(api, page)

Base.iterate(p::BBPaginator{BitbucketAPI}) =
    isempty(p.page.values) ? nothing : (p.page.values[1], (p.page, 2))

function Base.iterate(pgn::BBPaginator{BitbucketAPI, P}, (p, offset)::Tuple{P, Integer}) where {OP, P <: Page{OP}}
    api = pgn.api
    offset <= length(p.values) && return p.page.values[offset], (p, offset + 1)
    p.next === nothing && return nothing
    rate_limit(api, OP)
    resp = try
        HTTP.request(
            :GET, p.next, request_headers(api, OP);
            status_exception=false,
        )
    catch e
        rethrow(HTTPError(e, stacktrace(catch_backtrace())))
    end
    has_rate_limits(api, OP) && rate_limit_update!(api, OP, resp)
    resp.status != 200 && throw(HTTPError(resp, HTTP.StatusError(resp.status, resp), stacktrace()))
    try
        p2 = postprocess(postprocessor(api, OP), resp, into(api, OP))
        p2.values[1], (p2, 2)
    catch e
        rethrow(PostProcessorError(paginate, resp, e, stacktrace(catch_backtrace())))
    end
end
