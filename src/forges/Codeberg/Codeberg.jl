module Codeberg

import ..GitForge: endpoint, into, postprocessor, @forge

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
    @not_implemented

using Dates
using HTTP
using JSON3: JSON3

export CodebergAPI, NoToken, Token

const DEFAULT_URL = "https://codeberg.org/api/v1"
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

A personal access token for Codeberg/Forgejo/Gitea.
"""
struct Token <: AbstractToken
    token::String
end

auth_headers(::NoToken) = []
auth_headers(t::Token) = ["Authorization" => "token $(t.token)"]

"""
    CodebergAPI(;
        token::AbstractToken=NoToken(),
        url::$AStr="$DEFAULT_URL",
        has_rate_limits::Bool=false,
        on_rate_limit::OnRateLimit=ORL_THROW,
    )

Create a Codeberg/Forgejo/Gitea API client.

## Keywords
- `token::AbstractToken=NoToken()`: Authorization token (or lack thereof).
- `url::$AStr="$DEFAULT_URL"`: Base URL of the target instance.
- `has_rate_limits::Bool=false`: Whether or not the server has rate limits.
- `on_rate_limit::OnRateLimit=ORL_THROW`: Behaviour on exceeded rate limits.
"""
struct CodebergAPI <: Forge
    token::AbstractToken
    url::String
    hasrl::Bool
    orl::OnRateLimit
    rl::RateLimiter

    function CodebergAPI(;
        token::AbstractToken=NoToken(),
        url::AStr=DEFAULT_URL,
        has_rate_limits::Bool=false,
        on_rate_limit::OnRateLimit=ORL_THROW,
    )
        return new(token, url, has_rate_limits, on_rate_limit, RateLimiter())
    end
end
@forge CodebergAPI

GitForge.base_url(c::CodebergAPI) = c.url
GitForge.request_headers(c::CodebergAPI, ::Function) = [HEADERS; auth_headers(c.token)]
GitForge.postprocessor(::CodebergAPI, ::Function) = JSON()
GitForge.has_rate_limits(c::CodebergAPI, ::Function) = c.hasrl
GitForge.rate_limit_check(c::CodebergAPI, ::Function) = GitForge.rate_limit_check(c.rl)
GitForge.on_rate_limit(c::CodebergAPI, ::Function) = c.orl
GitForge.rate_limit_wait(c::CodebergAPI, ::Function) = GitForge.rate_limit_wait(c.rl)
GitForge.rate_limit_period(c::CodebergAPI, ::Function) = GitForge.rate_limit_period(c.rl)
GitForge.rate_limit_update!(c::CodebergAPI, ::Function, r::HTTP.Response) =
    GitForge.rate_limit_update!(c.rl, r)

include("users.jl")
include("repositories.jl")
include("pull_requests.jl")
include("commits.jl")
include("branches.jl")
include("tags.jl")
include("organizations.jl")

ismemberorcollaborator(r::HTTP.Response) = r.status == 204

end
