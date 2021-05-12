module GitForge

using Base.Iterators: Pairs
using Base.StackTraces: StackTrace

using Dates: Period, UTC, now
using HTTP: HTTP
using JSON3: JSON3
using StructTypes: StructTypes, UnorderedStruct

const AStr = AbstractString
const HEADERS = ["Content-Type" => "application/json"]

function __init__()
    proj = read(joinpath(dirname(@__DIR__), "Project.toml"), String)
    pkgver = match(r"version = \"(.+)\"", proj)[1]
    push!(HEADERS, "User-Agent" => "Julia v$VERSION (GitForge v$pkgver)")
end

include("forge.jl")
include("ratelimits.jl")
include("request.jl")
include("pagination.jl")
include("helpers.jl")
include("api.jl")
include(joinpath("forges", "GitHub", "GitHub.jl"))
include(joinpath("forges", "GitLab", "GitLab.jl"))

end
