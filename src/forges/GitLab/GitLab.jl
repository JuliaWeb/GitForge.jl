module GitLab

using ..GitForge
using ..GitForge: @json, Forge, JSON, USER_AGENT
using Dates
using JSON2

export GitLabAPI, OAuth2Token, PersonalAccessToken

const DEFAULT_URL = "https://gitlab.com/api/v4"

abstract type AbstractToken end

"""
    NoToken() -> NoToken

Represents no authentication.
Only public data will be available.
"""
struct NoToken <: AbstractToken end

"""
    OAuth2Token(token::AbstractString) -> OAuth2Token

An [OAuth2 bearer token](https://docs.gitlab.com/ce/api/#oauth2-tokens).
"""
struct OAuth2Token <: AbstractToken
    token::String
end

"""
    PersonalAccessToken(token::AbstractString) -> PersonalAccessToken

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
        url::AbstractString="$DEFAULT_URL",
    ) -> GitLabAPI

Create a GitLab API client.

## Keywords
- `token::AbstractToken=NoToken()`: Authorization token (or lack thereof).
- `url::AbstractString="$DEFAULT_URL"`: Base URL of the target GitLab instance.
"""
struct GitLabAPI <: Forge
    token::AbstractToken
    url::String

    function GitLabAPI(;
        token::AbstractToken=NoToken(),
        url::AbstractString=DEFAULT_URL,
    )
        return new(token, url)
    end
end

GitForge.base_url(g::GitLabAPI) = g.url

GitForge.request_headers(g::GitLabAPI, ::Function) =
    ["User-Agent" => USER_AGENT[]; auth_headers(g.token)]

GitForge.postprocessor(::GitLabAPI, ::Function) = JSON

include("users.jl")

end
