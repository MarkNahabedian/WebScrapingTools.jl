# Starting up and shutting down Firefox and Geckodriver.

export FirefoxGeckodriverSession

const FIREFOX_CMD = `firefox --headless --disable-gpu --safe-mode`

const GECKODRIVER_CMD = `geckodriver`


"""
    FirefoxGeckodriverSession

FirefoxGeckodriverSession encapsulates the external processes that are
necessary to scrape web pages using Firefox.
"""
mutable struct FirefoxGeckodriverSession <: WebdriverSession
    browser_session_id::Union{Missing, String}
    firefox_process::Union{Missing, Base.Process}
    geckodriver_process::Union{Missing, Base.Process}

    FirefoxGeckodriverSession() = new(missing, missing, missing)
end

browser_session_id(session::FirefoxGeckodriverSession) =
    session.browser_session_id

function startup(session::FirefoxGeckodriverSession)
    io = Logging2.LineBufferedIO(Logging2.LoggingStream(current_logger();
                                                        id="W3C_Webdriver",
                                                        level=Logging.Info))
    session.firefox_process = run(FIREFOX_CMD, devnull, io, io;
                                  wait=false)
    session.geckodriver_process = run(GECKODRIVER_CMD, devnull, io, io; wait=false)
    session
end

function teardown(session::FirefoxGeckodriverSession)
    session.browser_session_id = missing
    if session.geckodriver_process isa Base.Process
        kill(session.geckodriver_process)
        session.geckodriver_process = missing
    end
    if session.firefox_process isa Base.Process
        kill(session.firefox_process)
        session.firefox_process = missing
    end
    session
end

function isactive(session::FirefoxGeckodriverSession)
    ok(p) = (!isa(p, Missing)) && process_running(p)
    ok(session.firefox_process) && ok(session.geckodriver_process)
end

