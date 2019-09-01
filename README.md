# GitForge

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://christopher-dg.github.io/GitForge.jl/dev)
[![Build Status](https://travis-ci.com/christopher-dG/GitForge.jl.svg?branch=master)](https://travis-ci.com/christopher-dG/GitForge.jl)

**GitForge.jl is a unified interface for interacting with Git ["forges"](https://en.wikipedia.org/wiki/Forge_(software)).**

```julia
julia> using GitForge, GitForge.GitHub

julia> gh = GitHubAPI();

julia> result = get_user(gh, "christopher-dG");

julia> isnothing(GitForge.exception(result))
true

julia> GitForge.response(result).status
200

julia> GitForge.value(result).login
"christopher-dG"
```

### API Coverage

Eventually, the goal is to cover all the "basic" parts of services like GitHub, such as repositories, issues, pull requests, etc.
However, this library was mostly motivated by development on [Registrator](https://github.com/JuliaRegistries/Registrator.jl), so at the moment most of the wrapped endpoints are just the ones needed for that specific task.
