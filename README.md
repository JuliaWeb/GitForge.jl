# GitForge

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaweb.github.io/GitForge.jl/dev)
[![CI](https://github.com/JuliaWeb/GitForge.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaWeb/GitForge.jl/actions/workflows/CI.yml)

**GitForge.jl is a unified interface for interacting with Git ["forges"](https://en.wikipedia.org/wiki/Forge_(software)).**

```julia
julia> using GitForge, GitForge.GitHub

julia> gh = GitHubAPI();

julia> user, resp = get_user(gh, "christopher-dG");

julia> @assert resp.status == 200

julia> @assert user.login == "christopher-dG"
```

### API Coverage

Eventually, the goal is to cover all the "basic" parts of services like GitHub, such as repositories, issues, pull requests, etc.
However, this library was mostly motivated by development on [Registrator](https://github.com/JuliaRegistries/Registrator.jl), so at the moment most of the wrapped endpoints are just the ones needed for that specific task.
More recently, it's being used for efforts on [CompatHelper](https://github.com/JuliaRegistries/CompatHelper.jl) and [TagBot](https://github.com/JuliaRegistries/TagBot).

Forges will cover different methods of the API and they use @not_implemented to note unimplemented methods.
