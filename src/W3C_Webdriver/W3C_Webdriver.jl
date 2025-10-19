
using URIs
using HTTP
using JSON

const DEFAULT_GECKODRIVER_PORT = 4444
const GECKO_BASE_URI = URI("http://localhost:$DEFAULT_GECKODRIVER_PORT")

include("webdriver_commands.jl")
include("webdriver_interface.jl")
include("webdriver_session.jl")

