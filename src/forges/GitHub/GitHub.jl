module GitHub

using ..GitForge
using ..GitForge: @json, Forge, JSON, USER_AGENT
using Dates
using JSON2

export GitHubAPI, NoToken, Token, JWT

const DEFAULT_URL = "https://api.github.com"

abstract type AbstractToken end

"""
    NoToken() -> NoToken

Represents no authentication.
Only public data will be available.
"""
struct NoToken <: AbstractToken end

"""
    Token(token::AbstractString) -> Token

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
        url::AbstractString="$DEFAULT_URL",
    ) -> GitHubAPI

Create a GitHub API client.

## Keywords
- `token::AbstractToken=NoToken()`: Authorization token (or lack thereof).
- `url::AbstractString="$DEFAULT_URL"`: Base URL of the target GitHub instance.
"""
struct GitHubAPI <: Forge
    token::AbstractToken
    url::String

    function GitHubAPI(;
        token::AbstractToken=NoToken(),
        url::AbstractString=DEFAULT_URL,
    )
        return new(token, url)
    end
end

GitForge.base_url(g::GitHubAPI) = g.url

GitForge.request_headers(g::GitHubAPI, ::Function) =
    ["User-Agent" => USER_AGENT[]; auth_headers(g.token)]

GitForge.postprocessor(::GitHubAPI, ::Function) = JSON

include("users.jl")

end
