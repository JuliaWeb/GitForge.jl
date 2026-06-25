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

# Detect the HTTP 2.x line by package version (robust). HTTP.jl 2.x removed
# `HTTP.Header`, but keying off a removed binding's absence is fragile — 2.x has
# re-added other removed bindings as deprecating shims (e.g. `HTTP.Exceptions`,
# JuliaWeb/HTTP.jl#1315), so use the version, falling back to a genuine 2.x-only
# type (`HTTP.EmptyBody`) when `pkgversion` is unavailable (Julia < 1.9).
@static if VERSION >= v"1.9"
    const _HTTP_V2 = let v = pkgversion(HTTP)
        v === nothing ? isdefined(HTTP, :EmptyBody) : v >= v"2"
    end
else
    const _HTTP_V2 = isdefined(HTTP, :EmptyBody)
end

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

end
