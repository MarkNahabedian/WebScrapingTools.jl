# Webdriver commands
# See https://www.w3.org/TR/webdriver2

export WebdriverStatus, NewSession, WebdriverStatus, NewSession,
    GetCurrentURL, NavigateTo, GetPageSource


abstract type WebdriverCommand end

http_method(cmd::WebdriverCommand) = cmd.method

uri_path(cmd::WebdriverCommand) = URI(GECKO_BASE_URI,
                                      path = join([ GECKO_BASE_URI.path,
                                                    cmd.pathbase
                                                    ], "/"))

json_payload(cmd::WebdriverCommand) = Dict(
    "capabilities" => Dict()
)


struct WebdriverStatus <: WebdriverCommand
    method::String
    pathbase::String

    WebdriverStatus() = new("GET", "status")
end


struct NewSession <: WebdriverCommand
    method::String
    pathbase::String

    NewSession() = new("POST", "session")
end


abstract type WebdriverCurrentURL <: WebdriverCommand end

uri_path(cmd::WebdriverCurrentURL) = URI(GECKO_BASE_URI,
                                         path = join([ GECKO_BASE_URI.path,
                                                       "session",
                                                       cmd.session_id,
                                                       "url" ],
                                                     "/"))


struct GetCurrentURL <: WebdriverCurrentURL
    method::String
    session_id::String

    GetCurrentURL(session_id::String) = new("GET", session_id)
end


struct NavigateTo <: WebdriverCurrentURL
    method::String
    session_id::String
    uri::URI

    NavigateTo(session_id::String, uri::URI) = new("POST", session_id, uri)
    NavigateTo(session_id::String, uri::String) = NavigateTo(session_id, URI(uri))
end

json_payload(cmd::NavigateTo) = Dict(
    "capabilities" => Dict(),
    "url" => string(cmd.uri)
)


struct GetPageSource <: WebdriverCommand
    method::String
    session_id::String

    GetPageSource(session_id::String) = new("GET", session_id)
end

uri_path(cmd::GetPageSource) = URI(GECKO_BASE_URI,
                               path = join([ GECKO_BASE_URI.path,
                                             "session",
                                             cmd.session_id,
                                             "source" ],
                                           "/"))



