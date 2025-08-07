*** Settings ***
Documentation    Tests pour LIRE un fulfillment
Resource         ../resources/keywords.robot
Suite Setup      Connecter API
Suite Teardown   Fermer API

*** Test Cases ***
Lire Un Fulfillment - Succès
    [Documentation]    Test pour récupérer un fulfillment existant

    # créer un fulfillment
    Log    Étape 1: Création d'un fulfillment
    ${create_url}=    Set Variable    /order/${ORDER_ID}/shipping_fulfillment
    ${line_item}=    Create Dictionary    lineItemId=${LINE_ITEM_ID}    quantity=${1}
    ${line_items}=    Create List    ${line_item}
    ${create_data}=    Create Dictionary
    ...    lineItems=${line_items}
    ...    trackingNumber=${TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS
    ...    shippedDate=2025-07-29T14:30:00.000Z

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_HEADER}
    ...    Content-Type=application/json

    ${create_response}=    POST On Session    ebay    ${create_url}    json=${create_data}    headers=${headers}    expected_status=201

    # Récupérer l'ID du fulfillment créé
    ${location}=    Get From Dictionary    ${create_response.headers}    Location
    ${fulfillment_id}=    Fetch From Right    ${location}    /
    Log    Fulfillment créé avec ID: ${fulfillment_id}


    Log    Lecture du fulfillment
    ${read_url}=    Set Variable    /order/${ORDER_ID}/shipping_fulfillment/${fulfillment_id}

    ${read_response}=    GET On Session    ebay    ${read_url}    headers=${headers}    expected_status=any

    Should Be Equal As Integers    ${read_response.status_code}    200


    ${json_data}=    Set Variable    ${read_response.json()}
    Should Contain    ${json_data}    fulfillmentId
    Should Contain    ${json_data}    trackingNumber

    Log     Fulfillment lu avec succès !

Lire Un Fulfillment - Pas Trouvé
    [Documentation]    Test avec un ID qui n'existe pas

    # Essayer de lire un fulfillment qui n'existe pas
    ${read_url}=    Set Variable    /order/${ORDER_ID}/shipping_fulfillment/ID_QUI_EXISTE_PAS

    ${headers}=    Create Dictionary
    ...    Authorization=${AUTH_HEADER}
    ...    Content-Type=application/json

    ${response}=    GET On Session    ebay    ${read_url}    headers=${headers}    expected_status=any


    Should Be Equal As Integers    ${response.status_code}    404

    Log     Erreur 404 bien détectée !
