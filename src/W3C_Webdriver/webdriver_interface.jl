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


function webdriver_do(cmd::WebdriverCommand)
    data = JSON.json(json_payload(cmd))
    headers = [
        "content-type" => "application/json; charset=utf-8"
    ]
    println(cmd, "\n",
            uri_path(cmd), "\n",
            headers, "\n",
            data)
    response = HTTP.request(http_method(cmd),
                            uri_path(cmd),
                            headers, data)
    check_response(cmd, response)
    JSON.parse(String(response.body))
end

function webdriver_check_ready()
    webdriver_do(WebdriverStatus())["value"]["ready"] == true
end


"""
    fetch_page(uri)

Fetch the dynamic content of the specified web page.
"""
fetch_page(uri::String) = fetch_page(URI(uri))

function fetch_page(uri::URI)
    session = get_gecko_session()
    webdriver_do(NavigateTo(session, uri))
    result = webdriver_do(GetPageSource(session))
    Gumbo.parsehtml(result["value"))
end

