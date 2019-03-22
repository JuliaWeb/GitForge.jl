# GitForge

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://cdg.dev/GitForge.jl/dev)
[![Build Status](https://travis-ci.com/christopher-dG/GitForge.jl.svg?branch=master)](https://travis-ci.com/christopher-dG/GitForge.jl)

**GitForge.jl is a unified interface for interacting with Git ["forges"](https://en.wikipedia.org/wiki/Forge_(software)).**

```julia
julia> using GitForge, GitForge.GitHub

julia> gh = GitHubAPI()

julia> result = get_user(gh, "christopher-dG");

julia> isnothing(GitForge.exception(result))
true

julia> GitForge.response(result).status
200

julia> GitForge.value(result).login
"christopher-dG"
```
