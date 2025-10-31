export check_response, webdriver_do, fetch_page,
    WebdriverElement, find_element, find_elements

function check_response(cmd::WebdriverCommand, response::HTTP.Response)
    if response.status != 200
        if 400 <= request.status <= 599
            # eventually decode JSON error message
            error(join([ "$req:",
                         String(response.budy)
                         ], "\n"))
        else
            error(join([ "HTTP status $(request.status) for $req:",
                         String(response.budy)
                         ], "\n"))
        end
    end
end

function check_response(cmd, response)
    error("Unsupported parameters to check_response:\n$cmd\n$response")
end


function webdriver_do(cmd::WebdriverCommand, session::WebdriverSession)
    data = JSON.json(json_payload(cmd))
    headers = [
        "content-type" => "application/json; charset=utf-8"
    ]
    @info("webdriver_do", cmd,
          path = uri_path(cmd, session),
          headers, data)
    response = HTTP.request(http_method(cmd),
                            uri_path(cmd, session),
                            headers, data)
    check_response(cmd, response)
    JSON.parse(String(response.body))
end

function webdriver_check_ready(session::WebdriverSession)
    webdriver_do(WebdriverStatus(), session)["value"]["ready"] == true
end


"""
    fetch_page(uri)

Fetch the dynamic content of the specified web page.
"""
fetch_page(session::WebdriverSession, uri::String) = fetch_page(session, URI(uri))

function fetch_page(session::WebdriverSession, uri::URI)
    webdriver_do(NavigateTo(uri), session)
    result = webdriver_do(GetPageSource(), session)
    Gumbo.parsehtml(result["value"])
end


"""
    find_element(session::WebdriverSession, locator::Locator)

Returns a reference (as a [`WebdriverElement`](@ref)) to a single element.
an error is thrown if no element matches `locator`.

Uses the [`FindElement`](@ref) command.
"""
function find_element(session::WebdriverSession, locator::Locator)
    value = webdriver_do(FindElement(locator), session)["value"]
    return WebdriverElement(value[only(keys(value))])
end


"""
    find_elements(session::WebdriverSession, locator::Locator)

Returns a list of element references (as [`WebdriverElement`](@ref)s) to
alll of the elements that match `locator`.

Uses the [`FindElements`](@ref) command.
"""
function find_elements(session::WebdriverSession, locator::Locator)
    value = webdriver_do(FindElements(locator), session)["value"]
    map(value) do v
        WebdriverElement(v[only(keys(v))])
    end
end

