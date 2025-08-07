*** Settings ***
Documentation    Configuration de base très simple
Library          RequestsLibrary
Variables        ../pageobject/variable.py

*** Keywords ***
Connecter API
    [Documentation]    Se connecter à l'API eBay
    Create Session    ebay    ${API_URL}
    Set Suite Variable    ${AUTH_HEADER}    Bearer ${TOKEN}

Fermer API
    [Documentation]    Fermer la connexion
    Delete All Sessions