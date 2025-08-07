*** Settings ***
Documentation     Suite de test d'authentification CRM
Resource          ../ressources/common.robot

Suite Setup       Préparer environnement test
Suite Teardown    Fermer le navigateur proprement
Test Teardown     Run Keywords    Capture Screenshot If Test Failed    AND    Logout User

*** Test Cases ***

TC-1001 Home Page Should Load Correctly
    [Documentation]    Vérifie que la page d'accueil est bien chargée.
    ${expected_msg}=    Set Variable    ${VALID_MSG_HOME_${LANG}}
    Exécuter scénario    ${expected_msg}

TC-1002 Valid Login Should Redirect To Contacts Page
    [Documentation]    Vérifie que le login fonctionne avec des identifiants valides.
    Navigate To Login Page
    Enter Valid Credentials
    Submit Login Form
    ${expected_msg}=    Set Variable    ${VALID_MSG_POST_LOGIN_${LANG}}
    Vérifier message de réussite login    ${expected_msg}

TC-1003-1 Empty Credentials Should Prevent Submission
    [Documentation]    Vérifie que les champs obligatoires empêchent la soumission.
    Navigate To Login Page
    Click Element    ${LOGIN_SUBMIT_BUTTON}
    Verify Required Fields Enforcement
    ${expected_msg}=    Set Variable    ${INVALID_MSG_LOGIN_${LANG}}
    Vérifier message d'échec login    ${expected_msg}
    Page Should Not Contain Element    ${CUSTOMERS_TABLE}

TC-1003-2 Remember Me Should Persist Email
    [Documentation]    Vérifie que la case Remember Me fonctionne bien.
    Navigate To Login Page
    Enter Valid Credentials
    Enable Remember Me
    Submit Login Form
    Logout User
    ${expected_msg}=    Set Variable    ${VALID_MSG_POST_LOGOUT_${LANG}}
    Vérifier message de réussite logout    ${expected_msg}
    Navigate To Login Page
    Enter Valid Credentials
    Verify Email Persistence

TC-1004 Should Be Able To Logout
    [Documentation]    Vérifie que la déconnexion est effective.
    Navigate To Login Page
    Enter Valid Credentials
    Submit Login Form
    Logout User
    ${expected_msg}=    Set Variable    ${VALID_MSG_POST_LOGOUT_${LANG}}
    Vérifier message de réussite logout    ${expected_msg}

TC-1005 Customers Page Should Display Multiple Customers
    [Documentation]    Vérifie que la page Clients affiche plusieurs clients.
    Navigate To Login Page
    Enter Valid Credentials
    Submit Login Form
    ${expected_msg}=    Set Variable    ${VALID_MSG_POST_LOGIN_${LANG}}
    Vérifier message de réussite login    ${expected_msg}
    Go To Customers Page
    Verify Multiple Customers Displayed

TC-1006 Should Be Able To Add New Customer
    [Documentation]    Vérifie qu’on peut ajouter un nouveau client avec succès.
    Navigate To Login Page
    Enter Valid Credentials
    Submit Login Form
    ${expected_msg}=    Set Variable    ${VALID_MSG_POST_LOGIN_${LANG}}
    Vérifier message de réussite login    ${expected_msg}
    Go To Customers Page
    Click New Customer Button
    Fill New Customer Form
    Submit Customer Form
    Verify Customer Added Successfully

TC-1007 Should Be Able To Cancel Adding New Customer
    [Documentation]    Vérifie que l’utilisateur peut annuler l’ajout d’un client et revenir à la liste.
    Navigate To Login Page
    Enter Valid Credentials
    Submit Login Form
    Go To Customers Page
    Click New Customer Button
    Click Cancel Customer Button
    Verify Multiple Customers Displayed
