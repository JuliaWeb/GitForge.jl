using Documenter
using GitForge

makedocs(;
    modules=[GitForge],
    authors="Chris de Graaf <me@cdg.dev>",
    repo="https://github.com/JuliaWeb/GitForge.jl/blob/{commit}{path}#{line}",
    sitename="GitForge.jl",
    format=Documenter.HTML(;
        canonical="https://juliaweb.github.io/GitForge.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(; repo="github.com/JuliaWeb/GitForge.jl")
