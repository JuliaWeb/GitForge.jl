module GitLab

using ..GitForge
using ..GitForge: @json, Forge, JSON
using Dates
using JSON2

export GitLabAPI, OAuth2, PersonalAccess

const DEFAULT_URL = "https://gitlab.com/api/v4"

@enum TokenType OAuth2 PersonalAccess

"""
    GitLabAPI(; token::AbstractString, url::AbstractString="$DEFAULT_URL") -> GitLabAPI

Create a GitLab API client.

## Keywords
- `token::AbstractString`: Authorization token.
- `token_type::TokenType`: The token type.
  Options are either `OAuth2` or `PersonalAccess`.
- `url::AbstractString="$DEFAULT_URL"`: Base URL of the target GitLab instance.
"""
struct GitLabAPI <: Forge
    token::String
    token_type::TokenType
    base_url::String

    function GitLabAPI(;
        token::AbstractString,
        token_type::TokenType,
        url::AbstractString=DEFAULT_URL,
    )
        return new(token, token_type, url)
    end
end

function auth_header(g::GitLabAPI)
    return if g.token_type === OAuth2
        "Authorization" => "Bearer $(g.token)"
    elseif g.token_type === PersonalAccess
        "Private-Token" => g.token
    else
        throw(ArgumentError("Unknown token type $(g.token_type)"))
    end
end

GitForge.base_url(g::GitLabAPI) = g.base_url

GitForge.request_headers(g::GitLabAPI) = [auth_header(g)]

GitForge.postprocessor(::GitLabAPI) = JSON

include("users.jl")

end
