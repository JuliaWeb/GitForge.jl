# TODO: When search is implemented, they'll need their own rate limits.

module GitHub

import ..GitForge: endpoint, into, postprocessor, @forge

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
    ORL_THROW,
    @not_implemented

using Dates
using HTTP
using JSON3: JSON3

export GitHubAPI, NoToken, Token, JWT

const DEFAULT_URL = "https://api.github.com"
const DEFAULT_DATEFORMAT = dateformat"yyyy-mm-ddTHH:MM:SS\Z"

abstract type AbstractToken end

"""
    NoToken()

Represents no authentication.
Only public data will be available.
"""
struct NoToken <: AbstractToken end

"""
    Token(token::$AStr)

An [OAuth2 token](https://developer.github.com/v3/#authentication),
or a [personal access token](https://developer.github.com/v3/#authentication).
"""
struct Token <: AbstractToken
    token::String
end

"""
    JWT(token::$AStr)

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
        on_rate_limit::OnRateLimit=ORL_THROW,
    )

Create a GitHub API client.

## Keywords
- `token::AbstractToken=NoToken()`: Authorization token (or lack thereof).
- `url::$AStr="$DEFAULT_URL"`: Base URL of the target GitHub instance.
- `has_rate_limits::Bool=true`: Whether or not the GitHub server has rate limits.
- `on_rate_limit::OnRateLimit=ORL_THROW`: Behaviour on exceeded rate limits.
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
        on_rate_limit::OnRateLimit=ORL_THROW,
    )
        return new(token, url, has_rate_limits, on_rate_limit, RateLimiter(), RateLimiter())
    end
end
@forge GitHubAPI

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
include("comments.jl")

ismemberorcollaborator(r::HTTP.Response) = !(r.status in [403, 404])

end
