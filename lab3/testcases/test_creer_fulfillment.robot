*** Settings ***
Documentation    Tests pour CRÉER un fulfillment
Resource         ../resources/keywords.robot
Suite Setup      Connecter API
Suite Teardown   Fermer API

*** Test Cases ***
Créer Un Fulfillment - Succès
    [Documentation]    Test simple pour créer un fulfillment

    # 1. Préparer l'URL
    ${url}=    Set Variable    /order/${ORDER_ID}/shipping_fulfillment

   # 2. Préparer les données à envoyer
    ${line_item}=    Create Dictionary    lineItemId=${LINE_ITEM_ID}    quantity=${1}
    ${line_items}=    Create List    ${line_item}
    ${data}=    Create Dictionary
    ...    lineItems=${line_items}
    ...    trackingNumber=${TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS
    ...    shippedDate=2025-07-29T14:30:00.000Z


    # 3. Préparer les headers
    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_HEADER}
    ...    Content-Type=application/json

    # 4. Envoyer la requête POST
    ${response}=    POST On Session    ebay    ${url}    json=${data}    headers=${headers}    expected_status=any

    # 5. Vérifier que ça a marché
    Should Be Equal As Integers    ${response.status_code}    201

    # 6. Vérifier l'URL du fulfillment créé
    Should Contain    ${response.headers}    Location

    Log     Fulfillment créé avec succès !

Créer Un Fulfillment - Erreur
    [Documentation]    Test avec des données invalides

    # 1. Préparer l'URL
    ${url}=    Set Variable    /order/${ORDER_ID}/shipping_fulfillment

    # 2. Données INVALIDES
    ${line_item}=    Create Dictionary    lineItemId=${EMPTY}    quantity=${1}
    ${line_items}=    Create List    ${line_item}
    ${data}=    Create Dictionary
    ...    lineItems=${line_items}
    ...    trackingNumber=${TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS

    # 3. Headers
    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_HEADER}
    ...    Content-Type=application/json

    # 4. Envoyer la requête
    ${response}=    POST On Session    ebay    ${url}    json=${data}    headers=${headers}    expected_status=any

    # 5. Vérifier qu'on a bien une erreur
    Should Be Equal As Integers    ${response.status_code}    400

    Log     Erreur bien détectée !