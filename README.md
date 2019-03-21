# GitForge

[![Build Status](https://travis-ci.com/christopher-dG/GitForge.jl.svg?branch=master)](https://travis-ci.com/christopher-dG/GitForge.jl)

GitForge.jl is a unified interface for interacting with Git ["forges"](https://en.wikipedia.org/wiki/Forge_(software)).

```julia
julia> using GitForge, GitForge.GitHub

julia> gh = GitHubAPI(; token="<my token>");

julia> result = get_user(gh);

julia> isnothing(GitForge.exception(result))
true

julia> GitForge.response(result).status
200

julia> GitForge.value(result).login
"christopher-dG"
```
