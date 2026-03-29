module Forgejo

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
    mungetime

using Dates
using HTTP
using JSON3: JSON3
using StructTypes: StringType
using TimeZones: ZonedDateTime

export ForgejoAPI, NoToken, Token

const DEFAULT_URL = "https://codeberg.org/api/v1"
const DEFAULT_TIME_OUT_MILLIS = dateformat"yyyy-mm-ddTHH:MM:SS.sss+00:00"

abstract type AbstractToken end

"""
    NoToken()

Represents no authentication.
Only public data will be available.
"""
struct NoToken <: AbstractToken end

"""
    Token(token::$AStr)

An OAuth2 token or personal access token.
"""
struct Token <: AbstractToken
    token::String
end

auth_headers(::NoToken) = []
auth_headers(t::Token) = ["Authorization" => "token $(t.token)"]

"""
    ForgejoAPI(;
        token::AbstractToken=NoToken(),
        url::$AStr="$DEFAULT_URL",
        has_rate_limits::Bool=true,
        on_rate_limit::OnRateLimit=ORL_THROW,
    )

Create a Forgejo API client.

## Keywords
- `token::AbstractToken=NoToken()`: Authorization token (or lack thereof).
- `url::$AStr="$DEFAULT_URL"`: Base URL of the target Forgejo instance.
- `has_rate_limits::Bool=true`: Whether or not the Forgejo server has rate limits.
- `on_rate_limit::OnRateLimit=ORL_THROW`: Behaviour on exceeded rate limits.
"""
struct ForgejoAPI <: Forge
    token::AbstractToken
    url::String
    hasrl::Bool
    orl::OnRateLimit
    rl::RateLimiter

    function ForgejoAPI(;
        token::AbstractToken=NoToken(),
        url::AStr=DEFAULT_URL,
        has_rate_limits::Bool=true,
        on_rate_limit::OnRateLimit=ORL_THROW,
    )
        return new(token, url, has_rate_limits, on_rate_limit, RateLimiter())
    end
end
@forge ForgejoAPI

constructfield(::FieldContext{ForgejoAPI}, ::Type{Union{Date, Nothing}}, v::AbstractString) =
    Date(ZonedDateTime(mungetime(v)), UTC)

constructfield(::FieldContext{ForgejoAPI}, ::Type{Union{DateTime, Nothing}}, v::AbstractString) =
    DateTime(ZonedDateTime(mungetime(v)), UTC)

GitForge.write(::FieldContext{ForgejoAPI}, buf, pos, len, time::Date; kw...) =
    JSON3.write(StringType(), buf, pos, len, Dates.format(time, DEFAULT_TIME_OUT_MILLIS))

GitForge.write(::FieldContext{ForgejoAPI}, buf, pos, len, time::DateTime; kw...) =
    JSON3.write(StringType(), buf, pos, len, Dates.format(time, DEFAULT_TIME_OUT_MILLIS))

GitForge.base_url(g::ForgejoAPI) = g.url
GitForge.request_headers(g::ForgejoAPI, ::Function) = [HEADERS; auth_headers(g.token)]
GitForge.postprocessor(::ForgejoAPI, ::Function) = JSON()
GitForge.has_rate_limits(g::ForgejoAPI, ::Function) = g.hasrl
GitForge.rate_limit_check(g::ForgejoAPI, ::Function) = GitForge.rate_limit_check(g.rl)
GitForge.on_rate_limit(g::ForgejoAPI, ::Function) = g.orl
GitForge.rate_limit_wait(g::ForgejoAPI, ::Function) = GitForge.rate_limit_wait(g.rl)
GitForge.rate_limit_period(g::ForgejoAPI, ::Function) = GitForge.rate_limit_period(g.rl)
GitForge.rate_limit_update!(g::ForgejoAPI, ::Function, r::HTTP.Response) =
    GitForge.rate_limit_update!(g.rl, r)

include("users.jl")
include("repositories.jl")
include("pull_requests.jl")
include("commits.jl")
include("branches.jl")
include("tags.jl")
include("organizations.jl")

ismemberorcollaborator(r::HTTP.Response) = r.status in [200, 204]

end
