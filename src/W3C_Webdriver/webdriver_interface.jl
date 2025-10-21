export check_response, webdriver_do, fetch_page

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
    println(cmd, "\n",
            uri_path(cmd, session), "\n",
            headers, "\n",
            data)
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

