module GitHub

using ..GitForge
using ..GitForge: @json, Forge, JSON
using Dates
using JSON2

export GitHubAPI

const DEFAULT_URL = "https://api.github.com"

"""
    GitHubAPI(;
        token::Union{AbstractString, Nothing}=nothing,
        url::AbstractString="$DEFAULT_URL",
    ) -> GitHubAPI

Create a GitHub API client.

## Keywords
- `token::Union{AbstractString, Nothing}=nothing`: Authorization token (or lack thereof).
- `url::AbstractString="$DEFAULT_URL"`: Base URL of the target GitHub instance.
"""
struct GitHubAPI <: Forge
    token::Union{String, Nothing}
    base_url::String

    function GitHubAPI(;
        token::Union{AbstractString, Nothing}=nothing,
        url::AbstractString=DEFAULT_URL,
    )
        return new(token, url)
    end
end

auth_headers(g::GitHubAPI) =
    g.token === nothing ? [] : ["Authorization" => "token $(g.token)"]

GitForge.base_url(g::GitHubAPI) = g.base_url

GitForge.request_headers(g::GitHubAPI, ::Function) =
    ["User-Agent" => "Julia (GitForge.jl)"; auth_headers(g)]

GitForge.postprocessor(::GitHubAPI, ::Function) = JSON

include("users.jl")

end
