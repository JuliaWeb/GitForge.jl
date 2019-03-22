module GitForge

using HTTP
using JSON2

include("forge.jl")
include("types.jl")
include("request.jl")
include("api.jl")
include(joinpath("forges", "GitHub", "GitHub.jl"))
include(joinpath("forges", "GitLab", "GitLab.jl"))

end
