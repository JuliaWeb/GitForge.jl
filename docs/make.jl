using Documenter
using GitForge

makedocs(;
    modules=[GitForge],
    format=Documenter.HTML(),
    pages=["Home" => "index.md"],
    repo="https://github.com/christopher-dG/GitForge.jl/blob/{commit}{path}#L{line}",
    sitename="GitForge.jl",
    authors="Chris de Graaf",
)

deploydocs(; repo="github.com/christopher-dG/GitForge.jl")
