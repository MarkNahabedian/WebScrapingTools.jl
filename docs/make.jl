using WebScrapingTools
using Documenter

DocMeta.setdocmeta!(WebScrapingTools, :DocTestSetup, :(using WebScrapingTools); recursive=true)

makedocs(;
    modules=[WebScrapingTools],
    authors="MarkNahabedian <naha@mit.edu> and contributors",
    sitename="WebScrapingTools.jl",
    format=Documenter.HTML(;
        canonical="https://MarkNahabedian.github.io/WebScrapingTools.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/MarkNahabedian/WebScrapingTools.jl",
    devbranch="main",
)
