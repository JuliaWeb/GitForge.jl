module GitForge

using HTTP
using JSON2

const USER_AGENT = Ref{String}()

function __init__()
    proj = read(joinpath(dirname(@__DIR__), "Project.toml"), String)
    pkgver = match(r"version = \"(.+)\"", proj)[1]
    USER_AGENT[] = "Julia v$VERSION (GitForge v$pkgver)"
end

include("forge.jl")
include("types.jl")
include("request.jl")
include("api.jl")
include(joinpath("forges", "GitHub", "GitHub.jl"))
include(joinpath("forges", "GitLab", "GitLab.jl"))

end
