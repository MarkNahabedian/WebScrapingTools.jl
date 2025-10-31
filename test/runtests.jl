using WebScrapingTools
using Gumbo
using Test

@testset "test WebScrapingTools" begin
    ffsession = FirefoxGeckodriverSession()
    with_webdriver_session(ffsession) do session
        page1 = fetch_page(session, "https://w3.org")
        @test page1 isa Gumbo.HTMLDocument
        windows = get_window_handles(session)
        @test length(windows) == 1
        @test windows[1] isa WindowHandle
        page2 = fetch_page(session, "https://iana.org")
        @test page2 isa Gumbo.HTMLDocument
        # Find the timezone database:
        element_id = find_element(session, CSSSelector("#home-panel-protocols ul"))
        @test element_id isa WebdriverElement
        li_elements = find_elements(session, CSSSelector("#home-panel-protocols ul li"))
        @test length(li_elements) == 3
        @test all(li_elements) do e
            e isa WebdriverElement
        end
        @test element_text(session, li_elements[3]) == "Time Zone Database"
        # Click on it
        webdriver_do(ElementClick(li_elements[3]), session)
        @test get_title(session) == "Time Zone Database"

        webdriver_do(CloseWindow(), session)
    end
    @test ismissing(ffsession.firefox_process)
    @test ismissing(ffsession.geckodriver_process)
    @test ismissing(ffsession.browser_session_id)
end

