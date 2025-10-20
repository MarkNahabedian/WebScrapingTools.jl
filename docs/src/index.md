```@meta
CurrentModule = WebScrapingTools
```

# WebScrapingTools

Documentation for [WebScrapingTools](https://github.com/MarkNahabedian/WebScrapingTools.jl).

This package provides utilities for scraping dynamic web pages.  I
tried using [Webdriver.jl](https://juliapackages.com/p/webdriver) but
couldn't figure out how to configure it and get started.

Currently only `Firefox` with `geckodriver` is supported.


## External Program Management

Dynamic web page scrapeing depends on having a live web browser perform
any `JavaScript` or whatever to interpret the web page to produce the
page's DOM tree.

We currently use the combination of `firefox` and `geckodriver` to
process the web page.  [`FirefoxGeckodriverSession`](@ref) is used to
encapsulate the processes for the external `firefox` and `geckodriver`
commands.  The functions [`startup`](@ref), [`isactive`](@ref), and
[`teardown`](@ref) can be used to managhe these processes.


## Fetching a Web Page

The function [`fetch_page`](#ref) is used to fetch a web page.  It
returns a parsed HTML DOM tree if successful.  Otherwise an error is
thrown.


## Index

```@index
```

## Definitions

```@autodocs
Modules = [WebScrapingTools]
```
