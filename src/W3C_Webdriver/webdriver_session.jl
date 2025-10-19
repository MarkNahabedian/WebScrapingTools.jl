# Webdriver session management:

export get_gecko_session

if !isdefined(@__MODULE__, :GeckoDriverSessionId)
    GeckoDriverSessionId = missing
end

function get_gecko_session()
    # Apparently Geckodriver only supports one session:
    if !ismissing(GeckoDriverSessionId)
        return GeckoDriverSessionId
    end
    # @assert webdriver_check_ready()
    cmd = NewSession()
    result = webdriver_do(cmd)
    global GeckoDriverSessionId = result["value"]["sessionId"]
end
