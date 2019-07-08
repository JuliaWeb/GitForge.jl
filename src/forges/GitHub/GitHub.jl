# TODO: When search is implemented, they'll need their own rate limits.

module GitHub

import ..GitForge: endpoint, into, postprocessor

using ..GitForge
using ..GitForge:
    @json,
    AStr,
    DoSomething,
    Endpoint,
    Forge,
    JSON,
    OnRateLimit,
    RateLimiter,
    HEADERS,
    ORL_RETURN

using Dates
using HTTP
using JSON2

export GitHubAPI, NoToken, Token, JWT

const DEFAULT_URL = "https://api.github.com"
const JSON_OPTS = (
    dateformat=dateformat"y-m-d",
    datetimeformat=dateformat"y-m-dTH:M:SZ",
)

abstract type AbstractToken end

"""
    NoToken() -> NoToken

Represents no authentication.
Only public data will be available.
"""
struct NoToken <: AbstractToken end

"""
    Token(token::$AStr) -> Token

An [OAuth2 token](https://developer.github.com/v3/#authentication),
or a [personal access token](https://developer.github.com/v3/#authentication).
"""
struct Token <: AbstractToken
    token::String
end

"""
A JWT signed by a [private key](https://developer.github.com/apps/building-github-apps/authenticating-with-github-apps/#authenticating-as-a-github-app) for GitHub Apps.
"""
struct JWT <: AbstractToken
    token::String
end

auth_headers(::NoToken) = []
auth_headers(t::Token) = ["Authorization" => "token $(t.token)"]
auth_headers(t::JWT) = ["Authorization" => "Bearer $(t.token)"]

"""
    GitHubAPI(;
        token::AbstractToken=NoToken(),
        url::$AStr="$DEFAULT_URL",
        has_rate_limits::Bool=true,
        on_rate_limit::OnRateLimit=ORL_RETURN,
    ) -> GitHubAPI

Create a GitHub API client.

## Keywords
- `token::AbstractToken=NoToken()`: Authorization token (or lack thereof).
- `url::$AStr="$DEFAULT_URL"`: Base URL of the target GitHub instance.
- `has_rate_limits::Bool=true`: Whether or not the GitHub server has rate limits.
- `on_rate_limit::OnRateLimit=ORL_RETURN`: Behaviour on exceeded rate limits.
"""
struct GitHubAPI <: Forge
    token::AbstractToken
    url::String
    hasrl::Bool
    orl::OnRateLimit
    rl_general::RateLimiter
    rl_search::RateLimiter

    function GitHubAPI(;
        token::AbstractToken=NoToken(),
        url::AStr=DEFAULT_URL,
        has_rate_limits::Bool=true,
        on_rate_limit::OnRateLimit=ORL_RETURN,
    )
        return new(token, url, has_rate_limits, on_rate_limit, RateLimiter(), RateLimiter())
    end
end

GitForge.base_url(g::GitHubAPI) = g.url
GitForge.request_headers(g::GitHubAPI, ::Function) = [HEADERS; auth_headers(g.token)]
GitForge.postprocessor(::GitHubAPI, ::Function) = JSON()
GitForge.has_rate_limits(g::GitHubAPI, ::Function) = g.hasrl
GitForge.rate_limit_check(g::GitHubAPI, ::Function) =
    GitForge.rate_limit_check(g.rl_general)
GitForge.on_rate_limit(g::GitHubAPI, ::Function) = g.orl
GitForge.rate_limit_wait(g::GitHubAPI, ::Function) = GitForge.rate_limit_wait(g.rl_general)
GitForge.rate_limit_period(g::GitHubAPI, ::Function) =
    GitForge.rate_limit_period(g.rl_general)
GitForge.rate_limit_update!(g::GitHubAPI, ::Function, r::HTTP.Response) =
    GitForge.rate_limit_update!(g.rl_general, r)

include("users.jl")
include("repositories.jl")
include("pull_requests.jl")
include("organizations.jl")
include("commits.jl")
include("branches.jl")
include("tags.jl")

ismemberorcollaborator(r::HTTP.Response) = r.status != 404

end
