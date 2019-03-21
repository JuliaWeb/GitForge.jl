module GitForge

using HTTP
using JSON2

include("forge.jl")
include("types.jl")
include("request.jl")
include("api.jl")
include(joinpath("GitHub", "GitHub.jl"))
include(joinpath("GitLab", "GitLab.jl"))

end
