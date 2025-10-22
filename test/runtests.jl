using WebScrapingTools
using Gumbo
using Test

@testset "test startup, fetch, teardown, and session id" begin
    ffsession = FirefoxGeckodriverSession()
    with_webdriver_session(ffsession) do session
        page1 = fetch_page(session, "https://w3.org")
        @test page1 isa Gumbo.HTMLDocument
        page2 = fetch_page(session, "https://iana.org")
        @test page2 isa Gumbo.HTMLDocument
    end
    @test ismissing(ffsession.firefox_process)
    @test ismissing(ffsession.geckodriver_process)
    @test ismissing(ffsession.browser_session_id)
end

