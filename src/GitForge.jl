module GitForge

using Base.Iterators: Pairs
using Base.StackTraces: StackTrace

using Dates: Period, UTC, now
using HTTP: HTTP
using JSON2: JSON2

const AStr = AbstractString
const HEADERS = ["Content-Type" => "application/json"]

const proj = read(joinpath(dirname(@__DIR__), "Project.toml"), String)
const pkgver = match(r"version = \"(.+)\"", proj)[1]

function __init__()
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
