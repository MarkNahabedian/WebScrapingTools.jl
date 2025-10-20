# Starting up and shutting down Firefox and Geckodriver.

export FirefoxGeckodriverSession

const FIREFOX_CMD = `/Applications/Firefox.app/Contents/MacOS/firefox --headless --disable-gpu`

const GECKODRIVER_CMD = `geckodriver`


"""
    FirefoxGeckodriverSession

FirefoxGeckodriverSession encapsulates the external processes that are
necessary to scrape web pages using Firefox.
"""
mutable struct FirefoxGeckodriverSession <: WebdriverSession
    firefox_process::Union{Missing, Base.Process}
    geckodriver_process::Union{Missing, Base.Process}

    FirefoxGeckodriverSession() = new(missing, missing)
end

function startup(session::FirefoxGeckodriverSession)
    session.firefox_process = run(FIREFOX_CMD, devnull, stdout, stderr; wait=false)
    session.geckodriver_process = run(GECKODRIVER_CMD, devnull, stdout, stderr; wait=false)
    session
end

function teardown(session::FirefoxGeckodriverSession)
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

