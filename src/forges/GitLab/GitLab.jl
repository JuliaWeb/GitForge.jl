module GitLab

using ..GitForge
using ..GitForge: @json, Forge, JSON, USER_AGENT
using Dates
using JSON2

export GitLabAPI, OAuth2Token, PersonalAccessToken

const DEFAULT_URL = "https://gitlab.com/api/v4"

abstract type Token end

"""
    NoToken() -> NoToken

Represents no authentication.
Only public data will be available.
"""
struct NoToken <: Token end

"""
    OAuth2Token(token::AbstractString) -> OAuth2Token

An [OAuth2 bearer token](https://docs.gitlab.com/ce/api/#oauth2-tokens).
"""
struct OAuth2Token <: Token
    token::String
end

"""
    PersonalAccessToken(token::AbstractString) -> PersonalAccessToken

A [private access token](https://docs.gitlab.com/ce/api/#personal-access-tokens).
"""
struct PersonalAccessToken <: Token
    token::String
end

auth_headers(::NoToken) = []
auth_headers(t::OAuth2Token) = ["Authorization" => "Bearer $(t.token)"]
auth_headers(t::PersonalAccessToken) = ["Private-Token" => t.token]

"""
    GitLabAPI(; token::Token=NoToken(), url::AbstractString="$DEFAULT_URL") -> GitLabAPI

Create a GitLab API client.

## Keywords
- `token::Token=NoToken()`: Authorization token (or lack thereof).
- `url::AbstractString="$DEFAULT_URL"`: Base URL of the target GitLab instance.
"""
struct GitLabAPI <: Forge
    token::Token
    base_url::String

    GitLabAPI(; token::Token=NoToken(), url::AbstractString=DEFAULT_URL) = new(token, url)
end

GitForge.base_url(g::GitLabAPI) = g.base_url

GitForge.request_headers(g::GitLabAPI, ::Function) =
    ["User-Agent" => USER_AGENT[]; auth_headers(g.token)]

GitForge.postprocessor(::GitLabAPI, ::Function) = JSON

include("users.jl")

end
