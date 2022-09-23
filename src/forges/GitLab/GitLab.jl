module GitLab

import ..GitForge: endpoint, into, postprocessor, @forge, FieldContext, constructfield

using ..GitForge
using ..GitForge:
    @json,
    AStr,
    DoNothing,
    DoSomething,
    Endpoint,
    Forge,
    JSON,
    OnRateLimit,
    RateLimiter,
    HEADERS,
    ORL_THROW,
    @not_implemented,
    write,
    mungetime

using Dates
using HTTP
using JSON3: JSON3
using StructTypes: StructTypes, StringType
using TimeZones: ZonedDateTime

export GitLabAPI, NoToken, OAuth2Token, PersonalAccessToken

const DEFAULT_URL = "https://gitlab.com/api/v4"
const DEFAULT_TIME_OUT_MILLIS = dateformat"yyyy-mm-ddTHH:MM:SS.sss+00:00"
const REGEX_SIMPLE_DATE = r"^[0-9]{2,4}-[0-9][0-9]?-[0-9][0-9]?$"
const SIMPLE_DATE = dateformat"y-m-d"

abstract type AbstractToken end

"""
    NoToken()

Represents no authentication.
Only public data will be available.
"""
struct NoToken <: AbstractToken end

"""
    OAuth2Token(token::$AStr)

An [OAuth2 bearer token](https://docs.gitlab.com/ce/api/#oauth2-tokens).
"""
struct OAuth2Token <: AbstractToken
    token::String
end

"""
    PersonalAccessToken(token::$AStr)

A [private access token](https://docs.gitlab.com/ce/api/#personal-access-tokens).
"""
struct PersonalAccessToken <: AbstractToken
    token::String
end

auth_headers(::NoToken) = []
auth_headers(t::OAuth2Token) = ["Authorization" => "Bearer $(t.token)"]
auth_headers(t::PersonalAccessToken) = ["Private-Token" => t.token]

"""
    GitLabAPI(;
        token::AbstractToken=NoToken(),
        url::$AStr="$DEFAULT_URL",
        has_rate_limits::Bool=true,
        on_rate_limit::OnRateLimit=ORL_THROW,
    )

Create a GitLab API client.

## Keywords
- `token::AbstractToken=NoToken()`: Authorization token (or lack thereof).
- `url::$AStr"$DEFAULT_URL"`: Base URL of the target GitLab instance.
- `has_rate_limits::Bool=true`: Whether or not the GitLab server has rate limits.
- `on_rate_limit::OnRateLimit=ORL_THROW`: Behaviour on exceeded rate limits.
"""
struct GitLabAPI <: Forge
    token::AbstractToken
    url::String
    hasrl::Bool
    orl::OnRateLimit
    rl::RateLimiter

    function GitLabAPI(;
        token::AbstractToken=NoToken(),
        url::AStr=DEFAULT_URL,
        has_rate_limits::Bool=true,
        on_rate_limit::OnRateLimit=ORL_THROW,
    )
        return new(token, url, has_rate_limits, on_rate_limit, RateLimiter())
    end
end
@forge GitLabAPI

constructfield(::FieldContext{GitLabAPI}, ::Type{Union{Date, Nothing}}, v::AbstractString) =
    match(REGEX_SIMPLE_DATE, v) !== nothing ?
        Date(v, SIMPLE_DATE) :
        Date(ZonedDateTime(mungetime(v)), UTC)

constructfield(::FieldContext{GitLabAPI}, ::Type{Union{DateTime, Nothing}}, v::AbstractString) =
    DateTime(ZonedDateTime(mungetime(v)), UTC)

GitForge.write(::FieldContext{GitLabAPI}, buf, pos, len, time::DateTime; kw...) =
    JSON3.write(StringType(), buf, pos, len, Dates.format(time, DEFAULT_TIME_OUT_MILLIS))

GitForge.base_url(g::GitLabAPI) = g.url
GitForge.request_headers(g::GitLabAPI, ::Function) = [HEADERS; auth_headers(g.token)]
GitForge.postprocessor(::GitLabAPI, ::Function) = JSON()
GitForge.has_rate_limits(g::GitLabAPI, ::Function) = g.hasrl
GitForge.rate_limit_check(g::GitLabAPI, ::Function) = GitForge.rate_limit_check(g.rl)
GitForge.on_rate_limit(g::GitLabAPI, ::Function) = g.orl
GitForge.rate_limit_wait(g::GitLabAPI, ::Function) = GitForge.rate_limit_wait(g.rl)
GitForge.rate_limit_period(g::GitLabAPI, ::Function) = GitForge.rate_limit_period(g.rl)
GitForge.rate_limit_update!(g::GitLabAPI, ::Function, r::HTTP.Response) =
    GitForge.rate_limit_update!(g.rl, r)

include("users.jl")
include("projects.jl")
include("merge_requests.jl")
include("groups.jl")
include("commits.jl")
include("branches.jl")
include("tags.jl")
include("notes.jl")
include("pipeline_schedules.jl")

encode(owner::AStr, repo::AStr) = HTTP.escapeuri("$owner/$repo")
encode(org::AStr) = HTTP.escapeuri(org)
encode(owner::AStr, subgroup::AStr, repo::AStr) = HTTP.escapeuri("$owner/$subgroup/$repo")

function ismember(r::HTTP.Response)
    r.status == 404 && return false
    m = JSON3.read(IOBuffer(r.body), Member)
    return m.access_level !== nothing && m.access_level >= 30
end

end
