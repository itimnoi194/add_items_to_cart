*** Settings ***
Library           Selenium2Library
Library           uuid
Test Teardown      Close All Browsers

*** Variables ***
${url}                          https://www.powerbuy.co.th/th/
${browser}                      chrome
${item1}                        //*[@id='txt-productName-263085']
${item2}                        //*[@id='lnk-viewProduct-260292-name']
${filter44-55inches}            //*[@title='ช่วงขนาดหน้าจอ (นิ้ว)']/div[2]/div/div/div[1]/div[1]/div
${filter32-43inches}            //*[@title='ช่วงขนาดหน้าจอ (นิ้ว)']/div[2]/div/div/div[2]/div[1]/div
${success_add_item1}            //*[contains(text(),'คุณเพิ่ม ทีวี TU8300 UHD LED (55", 4K, Smart, Curved) รุ่น UA55TU8300KXXT ลงในตะกร้าสินค้าของคุณแล้ว')]
${success_add_item2}            //*[contains(text(),'คุณเพิ่ม ทีวี THE SERIF UHD QLED (43", 4K, Smart) รุ่น QA43LS01TAKXXT ลงในตะกร้าสินค้าของคุณแล้ว')]
${add_item1_to_cart_btn}        //*[@id='btn-addCart-263085']
${add_item2_to_cart_btn}        //*[@id='btn-addCart-260292']
${total_amount}                 ฿39,648

*** Test Cases ***
Test Case 001_Add TV items to cart and verify cart result
    Open web browser power buy
    When User search item and add items to cart     ${item1}        ${filter44-55inches}        ${add_item1_to_cart_btn}         ${success_add_item1}
    And User search item and add more items to cart     ${item2}        ${filter32-43inches}       ${add_item2_to_cart_btn}      ${success_add_item2}
    Then Validate seleted items in the cart         ${total_amount}

*** Keywords ***
Open web browser power buy
    ${message} =    Catenate    BROWSER=${browser}     URL=${url}
    Log to console    INFO    ${message}
    Open Browser   ${url}           ${browser}
    Capture Page Screenshot With Unique Name
    Set Window Size    1920    1080
    ${width}	${height}=	Get Window Size
    ${size} =    Catenate   Window Size=${width}	${height}
    Capture Page Screenshot With Unique Name

User search item and add items to cart
   [Arguments]        ${select_item}     ${filter}     ${add_item_to_cart_btn}          ${success_add_item}
    Search item and add items to cart      ${select_item}     ${filter}     ${add_item_to_cart_btn}          ${success_add_item}

User search item and add more items to cart
   [Arguments]        ${select_item}     ${filter}     ${add_item_to_cart_btn}          ${success_add_item}
    Search item and add items to cart       ${select_item}     ${filter}     ${add_item_to_cart_btn}          ${success_add_item}

Search item and add items to cart
    [Arguments]        ${select_item}     ${filter}     ${add_item_to_cart_btn}          ${success_add_item}
    Input Text                              //input[@id='txt-searchBox-input']        TV
    Press Keys                              //input[@id='txt-searchBox-input']          ENTER
    Capture Page Screenshot With Unique Name
    Wait Until Element Is Visible           //*[@class='Col__Column-sc-1619uro-0 ikKYdS']       40s
    Wait Until Element Is Visible           //*[@title='ช่วงขนาดหน้าจอ (นิ้ว)']       40s
    Sleep   5s
    Click element                           ${filter}
    Sleep   5s
    Capture Page Screenshot With Unique Name
    Wait Until Element Is Visible           ${select_item}             40s
    Click element                           ${select_item}
    Wait Until Element Is Visible           ${add_item_to_cart_btn}    20s
    Capture Page Screenshot With Unique Name
    Click element                           ${add_item_to_cart_btn}
    Wait Until Element Is Visible           ${success_add_item}        20s
    Capture Page Screenshot With Unique Name

Validate seleted items in the cart
    [Arguments]        ${total_amount}
    Click element                           //*[@id='btn-openMiniCart']
    Wait Until Page Contains Element        //*[@data-productid='260292']
    Wait Until Page Contains Element        //*[@data-productid='263085']
    Wait Until Element Contains             //*[@id='txt-productGrandTotalCartSummary']         ${total_amount}
    Capture Page Screenshot With Unique Name

Capture Page Screenshot With Unique Name
    ${uuid} =  uuid4
    Capture Page Screenshot  selenium-${uuid}.png