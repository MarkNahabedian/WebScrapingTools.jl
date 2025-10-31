
using URIs
using HTTP
using JSON
using Logging
using Logging2
using Gumbo
using Cascadia

export startup, teardown, isactive, with_webdriver_session,
        WebdriverElement, WindowHandle

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


"""
    with_webdriver_session(::Function, ::WebdriverSession)

Ensure that the `WebdriverSession` has running processes, then call
the function.

The sessions processes are terminated once function returns.

The return value of the function is returned.
"""
function with_webdriver_session(body::Function, session::WebdriverSession)
    try
        if !isactive(session)
            startup(session)
        end
        @assert isactive(session)
        return body(session)
    finally
        teardown(session)
    end
end


"""
WebdriverElement encapsulates an element id.  These are used to
identify an element to Webdriver.
"""
struct WebdriverElement
    element_id::String
end


"""
WindowHandle encapsulates the handle of a browser window."
"""
struct WindowHandle
    handle
end


include("locators.jl")
include("webdriver_commands.jl")
include("webdriver_interface.jl")
include("webdriver_session.jl")
include("firefox.jl")

