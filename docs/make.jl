using Documenter
using GitForge

makedocs(;
    modules=[GitForge],
    authors="Chris de Graaf <chrisadegraaf@gmail.com>",
    repo="https://github.com/christopher-dG/GitForge.jl/blob/{commit}{path}#L{line}",
    sitename="GitForge.jl",
    format=Documenter.HTML(;
        canonical="https://christopher-dg.github.io/GitForge.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(; repo="github.com/christopher-dG/GitForge.jl")
