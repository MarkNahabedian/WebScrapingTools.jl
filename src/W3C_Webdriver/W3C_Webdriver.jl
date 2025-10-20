
using URIs
using HTTP
using JSON

export startup, teardown, isactive

const DEFAULT_GECKODRIVER_PORT = 4444
const GECKO_BASE_URI = URI("http://localhost:$DEFAULT_GECKODRIVER_PORT")


"""
    WebdriverSession

WebdriverSession is the abstract supertype for the types used to
manage the external programs that are needed for Webdriver scraping.
There would be one subtype per browser.
"""
abstract type WebdriverSession end


"""
    startup(::WebdriverSession)

starts the processes that are required for this type of browser.
"""
function startup end


"""
    teardown(::WebdriverSession)

terminates the processes that are required for this type of browser.
"""
function teardown end


"""
    isactive(::WebdriverSession)

Returns true if the session is ready to serve Webdriver commands.
"""
function isactive end


include("webdriver_commands.jl")
include("webdriver_interface.jl")
include("webdriver_session.jl")
include("firefox.jl")

