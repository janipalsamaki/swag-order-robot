*** Settings ***
Library         SeleniumLibrary
Library         lib/Orders.py
Variables       variables.py

*** Keywords ***
Process orders
    Open Swag Labs
    Variable Should Exist   ${SWAG_LABS_USER_NAME}
    Variable Should Exist   ${SWAG_LABS_PASSWORD}
    Login                   ${SWAG_LABS_USER_NAME}  ${SWAG_LABS_PASSWORD}
    @{orders}=              Collect orders

    FOR     ${order}    IN  @{orders}
        Run Keyword And Continue On Failure     Process order   ${order}
    END

    [Teardown]      Close Browser

Open Swag Labs
    Open Browser    ${SWAG_LABS_URL}    Chrome

Login
    [Arguments]     ${user_name}    ${password}
    Input Text      user-name       ${user_name}
    Input Password  password        ${password}
    Submit Form

Collect orders
    @{orders}=  Get orders  ./data/Data.xlsx
    [Return]    @{orders}

Process order
    [Arguments]             ${order}
    Add product to cart     ${order}
    Open cart
    Checkout                ${order}
    Open products page

Add product to cart
    [Arguments]             ${order}
    ${product_name}=        Set Variable    ${order["item"]}
    ${locator}=             Set Variable    xpath://div[@class="inventory_item" and descendant::div[contains(text(), "${product_name}")]]
    ${product}=             Get WebElement  ${locator}
    ${add_to_cart_button}=  Set Variable    ${product.find_element_by_class_name("btn_primary")}
    Click Button            ${add_to_cart_button}

Open cart
    Click Link  css:.shopping_cart_link

Checkout
    [Arguments]     ${order}
    Click Link      css:.checkout_button
    Input Text      first-name      ${order["first_name"]}
    Input Text      last-name       ${order["last_name"]}
    Input Text      postal-code     ${order["zip"]}
    Submit Form
    Click Link      css:.btn_action

Open products page
    Go To   ${SWAG_LABS_URL}inventory.html