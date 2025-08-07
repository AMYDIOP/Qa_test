*** Settings ***
Library    AppiumLibrary
Variables  ../pageobject/locator.py
Variables  ../pageobject/variables.py

*** Keywords ***
Ouvrir l'app Looma
    Open Application    ${REMOTE_URL}
    ...    platformName=${PLATFORM_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    automationName=${AUTOMATION_NAME}
    ...    app=${APP}
    ...    noReset=true
    Capture Page Screenshot

Se connecter à Looma
    Wait Until Element Is Visible    ${USERNAME}    5
    Click Element                    ${USERNAME}
    Input Text                       ${USERNAME}    donero
    Capture Page Screenshot

    Wait Until Element Is Visible    ${PASSWORD}    5
    Click Element                    ${PASSWORD}
    Input Text                       ${PASSWORD}    ewedon
    Capture Page Screenshot

    Wait Until Element Is Visible    ${LOGIN}    5
    Click Element                    ${LOGIN}
    Wait Until Page Contains Element    ${PAGE_FORM}    10
    Capture Page Screenshot

Ajouter un produit
    Wait Until Element Is Visible    ${BTN_AJOUT_PRODUIT}    5
    Click Element                    ${BTN_AJOUT_PRODUIT}

    Wait Until Element Is Visible    ${PRODUIT_TITLE}    5
    Input Text    ${PRODUIT_TITLE}     Fjallraven
    Input Text    ${PRODUIT_PRICE}     15.99
    Input Text    ${PRODUIT_DESC}      The color could be slightly different between on the screen and in practice.
    Input Text    ${PRODUIT_CATEGORY}  men's clothing
    Input Text    ${PRODUIT_IMAGE}     https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg

    Click Element    ${BTN_AJOUT_PRODUIT}
    Capture Page Screenshot

Afficher un produit
    Wait Until Page Contains Element    ${PRODUIT_ITEM}    10
    Click Element                       ${PRODUIT_ITEM}
    Capture Page Screenshot
