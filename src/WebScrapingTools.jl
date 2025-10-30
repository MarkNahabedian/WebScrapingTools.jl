module WebScrapingTools

using URIs
using HTTP
using Gumbo
using Cascadia

include("W3C_Webdriver/W3C_Webdriver.jl")

# See https://github.com/JuliaLogging/Logging2.jl/issues/10
Base.isless(a::Int32, b::Logging.LogLevel) = isless(a, convert(Int32, b))

end
