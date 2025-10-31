export Locator, CSSSelector

"""
L`Locator`s are used by various Webdriver commands that search a
document for specific elements.
"""
abstract type Locator end

"""
    CSSSelector(css_selector_string)

[https://www.w3.org/TR/webdriver2/#dfn-css-selector](https://www.w3.org/TR/webdriver2/#dfn-css-selector)
"""
struct CSSSelector <: Locator
    css_selector::String
end

locator_strategy(::CSSSelector) = "css selector"

