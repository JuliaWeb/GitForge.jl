module GitHub

using ..GitForge
using ..GitForge: @json, Forge, JSON
using Dates
using JSON2

export GitHubAPI

const DEFAULT_URL = "https://api.github.com"

"""
    GitHubAPI(; token::AbstractString, url::AbstractString="$DEFAULT_URL") -> GitHubAPI

Create a GitHub API client.

## Keywords
- `token::AbstractString`: Authorization token.
- `url::AbstractString="$DEFAULT_URL"`: Base URL of the target GitHub instance.
"""
struct GitHubAPI <: Forge
    token::String
    base_url::String

    GitHubAPI(; token::AbstractString, url::AbstractString=DEFAULT_URL) = new(token, url)
end

GitForge.base_url(g::GitHubAPI) = g.base_url

function GitForge.request_headers(g::GitHubAPI)
    return [
        "Authorization" => "token $(g.token)",
        "User-Agent" => "Julia (GitForge.jl)",
    ]
end

GitForge.postprocessor(::GitHubAPI, ::Function) = JSON

include("users.jl")

end
