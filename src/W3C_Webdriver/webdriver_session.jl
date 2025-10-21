# Webdriver session management:

export get_gecko_session

function get_gecko_session(session::WebdriverSession)
    # Apparently Geckodriver only supports one session:
    if !ismissing(session.browser_session_id)
        return session.browser_session_id
    end
    # @assert webdriver_check_ready(session)
    result = webdriver_do(NewSession(), session)
    println(result)
    session.browser_session_id = result["value"]["sessionId"]
    return session.browser_session_id
end
