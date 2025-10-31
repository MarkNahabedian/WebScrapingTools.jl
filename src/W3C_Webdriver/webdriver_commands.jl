# Webdriver commands
# See https://www.w3.org/TR/webdriver2

export WebdriverStatus, NewSession, WebdriverStatus, NewSession,
    GetCurrentURL, NavigateTo, GetPageSource, FindElement,
    FindElements, ElementClick


"""
    WebdriverCommand

Abstract superclass for qll supported Webdriver commands.
"""
abstract type WebdriverCommand end

http_method(cmd::WebdriverCommand) = cmd.method


"""
    uri_path(cmd::WebdriverCommand, ::WebdriverSession)

Returns the URI path for the request represented by `cmd`.
"""
function uri_path end

uri_path(cmd::WebdriverCommand, ::WebdriverSession) =
    URI(GECKO_BASE_URI,
        path = join([ GECKO_BASE_URI.path,
                      cmd.pathbase
                      ], "/"))


"""
    json_payload(cmd::WebdriverCommand)

    Returns the payload for the HTTP request that will be sent for `cmd`.
"""
json_payload(cmd::WebdriverCommand) = Dict(
    "capabilities" => Dict()
)


"""
    WebdriverStatus()

Webdriver status command.
[https://www.w3.org/TR/webdriver2/#dfn-status](https://www.w3.org/TR/webdriver2/#dfn-status).
"""
struct WebdriverStatus <: WebdriverCommand
    method::String
    pathbase::String

    WebdriverStatus() = new("GET", "status")
end


"""
    NewSession()

Webdriver command for creating a new session.
[https://www.w3.org/TR/webdriver2/#dfn-new-sessions](https://www.w3.org/TR/webdriver2/#dfn-new-sessions).
"""
struct NewSession <: WebdriverCommand
    method::String
    pathbase::String

    NewSession() = new("POST", "session")
end


abstract type WebdriverCurrentURL <: WebdriverCommand end

uri_path(cmd::WebdriverCurrentURL, session::WebdriverSession) =
    URI(GECKO_BASE_URI,
        path = join([ GECKO_BASE_URI.path,
                      "session",
                      get_gecko_session(session),
                      "url" ],
                    "/"))


"""
    GetCurrentURL()

Webdriver command to get the current URL.
[https://www.w3.org/TR/webdriver2/#dfn-get-current-url](https://www.w3.org/TR/webdriver2/#dfn-get-current-url).
"""
struct GetCurrentURL <: WebdriverCurrentURL
    method::String

    GetCurrentURL() = new("GET")
end


"""
    NavigateTo(url)

Webdriver command to navidate to the specified `uri`.
[https://www.w3.org/TR/webdriver2/#dfn-navigate-to](https://www.w3.org/TR/webdriver2/#dfn-navigate-to}.
"""
struct NavigateTo <: WebdriverCurrentURL
    method::String
    uri::URI

    NavigateTo(uri::URI) = new("POST", uri)
    NavigateTo(uri::String) = NavigateTo(URI(uri))
end

json_payload(cmd::NavigateTo) = Dict(
    "capabilities" => Dict(),
    "url" => string(cmd.uri)
)


"""
    GetPageSource()

Webdriver command to get the content of the current web page.
[https://www.w3.org/TR/webdriver2/#dfn-get-page-source](https://www.w3.org/TR/webdriver2/#dfn-get-page-source).
"""
struct GetPageSource <: WebdriverCommand
    method::String

    GetPageSource() = new("GET")
end

uri_path(cmd::GetPageSource, session::WebdriverSession) =
    URI(GECKO_BASE_URI,
        path = join([ GECKO_BASE_URI.path,
                      "session",
                      get_gecko_session(session),
                      "source" ],
                    "/"))




"""
    FindElement(locator)

Webdriver command to find the first element that matches `locator`.
[https://www.w3.org/TR/webdriver2/#find-element](https://www.w3.org/TR/webdriver2/#find-element)
"""
struct FindElement <: WebdriverCommand
    method::String
    locator::Locator

    FindElement(locator) = new("POST", locator)
end

uri_path(cmd::FindElement, session::WebdriverSession) =
    URI(GECKO_BASE_URI,
        path = join([ GECKO_BASE_URI.path,
                      "session",
                      get_gecko_session(session),
                      "element" ],
                    "/"))

json_payload(cmd::FindElement) = Dict(
    "capabilities" => Dict(),
    "using" => locator_strategy(cmd.locator),
    "value" => cmd.locator.css_selector
)


"""
    FindElements(locator)

Webdriver command to find multiple elements.
[https://www.w3.org/TR/webdriver2/#find-elements](https://www.w3.org/TR/webdriver2/#find-elements)
"""
struct FindElements <: WebdriverCommand
    method::String
    locator::Locator

    FindElements(locator) = new("POST", locator)
end

uri_path(cmd::FindElements, session::WebdriverSession) =
    URI(GECKO_BASE_URI,
        path = join([ GECKO_BASE_URI.path,
                      "session",
                      get_gecko_session(session),
                      "elements" ],
                    "/"))

json_payload(cmd::FindElements) = Dict(
    "capabilities" => Dict(),
    "using" => locator_strategy(cmd.locator),
    "value" => cmd.locator.css_selector
)


"""
    ElementClick(element_id::WebdriverElement)

Clicks on the specified element.
"""
struct ElementClick <: WebdriverCommand
    method::String
    element_id::WebdriverElement

    ElementClick(element_id::WebdriverElement) = new("POST", element_id)
end

uri_path(cmd::ElementClick, session::WebdriverSession) =
    URI(GECKO_BASE_URI,
        path = join([ GECKO_BASE_URI.path,
                      "session",
                      get_gecko_session(session),
                      "element",
                      cmd.element_id.element_id,
                      "click" ],
                    "/"))

