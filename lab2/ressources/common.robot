*** Settings ***
Documentation     Fichier commun des mots-clés de test (login + homepage + clients)
Library           SeleniumLibrary
Variables         ../pageobject/locator.py
Variables         ../pageobject/variable.py

*** Keywords ***

# -----------------------
# 🔧 Configuration générale
# -----------------------

Préparer environnement test
    [Documentation]    Prépare le navigateur et configure les délais.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed       0.5s
    Set Selenium Timeout     10s
    ${language}=    Execute Javascript    return navigator.language || navigator.userLanguage;
    ${lang_code}=   Evaluate    '${language.split("-")[0]}'.lower()
    Set Suite Variable    ${LANG}    ${lang_code}

Fermer le navigateur proprement
    [Documentation]    Ferme proprement le navigateur.
    Close Browser

Capture Screenshot If Test Failed
    [Documentation]    Capture une capture d’écran si le test échoue.
    Run Keyword If Test Failed    Capture Page Screenshot
    Run Keyword If Test Failed    Log Source

Afficher informations testeur
    [Documentation]    Affiche les infos du testeur en console.
    Log     Testeur: ${VALID_USERNAME_AUTOMATION}    console=True

# -----------------------
# 🏠 Home Page
# -----------------------

Exécuter scénario
    [Arguments]    ${expected_msg}
    Afficher informations testeur
    Vérifier message de réussite    ${expected_msg}

Vérifier message de réussite
    [Arguments]    ${expected_msg}
    [Documentation]    Vérifie la présence du message attendu sur la homepage.
    ${page_text}=    Get Text    ${HOME_PAGE_TEXT}
    Run Keyword If    '${expected_msg}' in '${page_text}'    Log    Message attendu trouvé : ${expected_msg}    console=True
    ...    ELSE IF    '${VALID_MSG_HOME_en}' in '${page_text}'    Log    Message trouvé en anglais : ${VALID_MSG_HOME_en}    console=True
    ...    ELSE IF    '${VALID_MSG_HOME_fr}' in '${page_text}'    Log    Message trouvé en français : ${VALID_MSG_HOME_fr}    console=True
    ...    ELSE    Fail    Aucun message attendu trouvé dans la page.

# -----------------------
# 🔐 Login Page
# -----------------------

Navigate To Login Page
    [Documentation]    Clique sur le lien "Login" depuis la page d’accueil.
    Go To    ${URL}
    Click Element    ${LOGIN_LINK}
    Wait Until Page Contains Element    ${LOGIN_FORM}    10s

Enter Valid Credentials
    [Documentation]    Saisie des identifiants valides.
    Input Text    ${LOGIN_EMAIL}    ${VALID_USERNAME_AUTOMATION}
    Input Password    ${LOGIN_PASSWORD}    ${VALID_PASSWORD_AUTOMATION}

Submit Login Form
    [Documentation]    Soumet le formulaire de connexion.
    Click Element    ${LOGIN_SUBMIT_BUTTON}
    Wait Until Page Contains Element    ${CONTACTS_TABLE}    5s

Enable Remember Me
    [Documentation]    Coche la case "Remember me".
    Select Checkbox    ${REMEMBER_ME}

Logout User
    [Documentation]    Effectue la déconnexion.
    Click Element    ${LOGOUT_LINK}

Verify Email Persistence
    [Documentation]    Vérifie que l'email est bien pré-rempli.
    ${stored_email}=    Get Value    ${PERSISTED_EMAIL}
    Should Be Equal    ${stored_email}    ${VALID_USERNAME_AUTOMATION}

Verify Required Fields Enforcement
    [Documentation]    Vérifie que les champs requis empêchent la soumission.
    Element Attribute Value Should Be    ${LOGIN_EMAIL}    required    true
    Element Attribute Value Should Be    ${LOGIN_PASSWORD}    required    true
    Wait Until Element Is Visible    ${LOGIN_FORM}    5s

Vérifier message de réussite login
    [Arguments]    ${expected_msg}
    Wait Until Element Is Visible    ${DASHBOARD_TEXT}    10s
    ${page_text}=    Get Text    ${DASHBOARD_TEXT}
    Run Keyword If    '${expected_msg}' in '${page_text}'    Log    Message attendu trouvé : ${expected_msg}    console=True
    ...    ELSE IF    '${VALID_MSG_POST_LOGIN_en}' in '${page_text}'    Log    Message trouvé en anglais : ${VALID_MSG_POST_LOGIN_en}    console=True
    ...    ELSE IF    '${VALID_MSG_POST_LOGIN_fr}' in '${page_text}'    Log    Message trouvé en français : ${VALID_MSG_POST_LOGIN_fr}    console=True
    ...    ELSE    Fail    Aucun message de succès trouvé.

Vérifier message d'échec login
    [Arguments]    ${expected_msg}
    ${page_text}=    Get Text    ${LOGIN_PAGE_TEXT}
    Run Keyword If    '${expected_msg}' in '${page_text}'    Log    Message attendu trouvé : ${expected_msg}    console=True
    ...    ELSE IF    '${INVALID_MSG_LOGIN_en}' in '${page_text}'    Log    Message trouvé en anglais : ${INVALID_MSG_LOGIN_en}    console=True
    ...    ELSE IF    '${INVALID_MSG_LOGIN_fr}' in '${page_text}'    Log    Message trouvé en français : ${INVALID_MSG_LOGIN_fr}    console=True
    ...    ELSE    Fail    Aucun message d’échec trouvé.

Vérifier message de réussite logout
    [Arguments]    ${expected_msg}
    ${page_text}=    Get Text    ${LOGOUT_SUCCESS_TEXT}
    Run Keyword If    '${expected_msg}' in '${page_text}'    Log    Message attendu trouvé : ${expected_msg}    console=True
    ...    ELSE IF    '${VALID_MSG_POST_LOGOUT_en}' in '${page_text}'    Log    Message trouvé en anglais : ${VALID_MSG_POST_LOGOUT_en}    console=True
    ...    ELSE IF    '${VALID_MSG_POST_LOGOUT_fr}' in '${page_text}'    Log    Message trouvé en français : ${VALID_MSG_POST_LOGOUT_fr}    console=True
    ...    ELSE    Fail    Aucun message de logout trouvé.

# -----------------------
# 📇 Customers Page
# -----------------------

Go To Customers Page
    [Documentation]    Navigue vers la page Clients.
    Wait Until Page Contains Element    xpath=//table[@id='customers']    10s

Verify Multiple Customers Displayed
    [Documentation]    Vérifie que plusieurs clients sont affichés dans la liste.
    ${rows}=    Get Element Count    xpath=//table[@id='customers']//tbody/tr
    Should Be True    ${rows} > 1

Click New Customer Button
    [Documentation]    Clique sur le bouton pour ajouter un nouveau client.
    Click Element    id=new-customer
    Wait Until Page Contains Element    xpath=//form[@action='customer-success.html']    10s

Fill New Customer Form
    [Documentation]    Remplit le formulaire d’ajout d’un client.
    Input Text    id=EmailAddress           test@example.com
    Input Text    id=FirstName              John
    Input Text    id=LastName               Doe
    Input Text    id=City                   Dakar
    Wait Until Element Is Visible    id=StateOrRegion    5s
    Select From List By Index        id=StateOrRegion    3
    Click Element    xpath=//input[@type='radio' and @value='male']
    Click Element    xpath=//input[@type='checkbox' and @name='promos-name']

Submit Customer Form
    [Documentation]    Soumet le formulaire d’ajout d’un client.
    Click Element    ${CUSTOMER_SUBMIT_BUTTON}

Verify Customer Added Successfully
    [Documentation]    Vérifie que le message de succès s’affiche après l’ajout.
    Wait Until Page Contains    Success! New customer added.    10s


Click Cancel Customer Button
    [Documentation]    Clique sur le bouton "Cancel" sur le formulaire d’ajout de client.
    Click Link    xpath=//a[contains(text(),'Cancel')]
    Wait Until Page Contains    Our Happy Customers    10s
