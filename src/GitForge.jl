module GitForge

using Base.Iterators: Pairs
using Base.StackTraces: StackTrace

using Dates
using Dates: Period, UTC, now
using HTTP: HTTP
using UUIDs: UUID
using JSON3: JSON3, @writechar, @check, realloc!
using StructTypes: StructTypes, UnorderedStruct, StructType, DictType, StringType
import StructTypes: construct, constructfrom

const AStr = AbstractString
const HEADERS = ["Content-Type" => "application/json"]

# Select the API era by HTTP's major version. HTTP.jl only defines its own
# `VERSION` constant in 2.x; in 1.x `HTTP.VERSION` is the binding re-exported from
# `Base` (Julia's version), so check that `VERSION` is actually owned by the `HTTP`
# module before trusting it — if it is not, we are on 1.x. (Don't key off a removed
# binding like `HTTP.Header` either: 2.x re-adds removed bindings as deprecating
# shims, JuliaWeb/HTTP.jl#1315, so their presence no longer distinguishes versions.)
const _HTTP_V2 = Base.binding_module(HTTP, :VERSION) === HTTP && v"2" <= HTTP.VERSION < v"3"

let
    proj = read(joinpath(dirname(@__DIR__), "Project.toml"), String)
    pkgver = match(r"version = \"(.+)\"", proj)[1]
    push!(HEADERS, "User-Agent" => "Julia v$VERSION (GitForge v$pkgver)")
end

"""
The supertype of all other exceptions raised by API functions.
"""
abstract type ForgeError <: Exception end

Base.include_dependency("../Project.toml")
include("forge.jl")
include("ratelimits.jl")
include("request.jl")
include("pagination.jl")
include("helpers.jl")
include("api.jl")
include(joinpath("forges", "GitHub", "GitHub.jl"))
include(joinpath("forges", "GitLab", "GitLab.jl"))
include(joinpath("forges", "Bitbucket", "Bitbucket.jl"))
include(joinpath("forges", "Codeberg", "Codeberg.jl"))

end
