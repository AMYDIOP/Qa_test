*** Settings ***
Documentation    Tests pour LISTER tous les fulfillments
Resource         ../resources/keywords.robot
Suite Setup      Connecter API
Suite Teardown   Fermer API

*** Test Cases ***
Lister Les Fulfillments - Succès
    [Documentation]    Test pour récupérer la liste de tous les fulfillments


    # Création d'un fulfillment
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
    Log    Fulfillment créé


    # Récupération de la liste
    ${list_url}=    Set Variable    /order/${ORDER_ID}/shipping_fulfillment

    ${list_response}=    GET On Session    ebay    ${list_url}    headers=${headers}    expected_status=any

    # Vérifier que ça a marché
    Should Be Equal As Integers    ${list_response.status_code}    200

    # Vérifier qu'on a bien une liste
    ${json_data}=    Set Variable    ${list_response.json()}
    Should Contain    ${json_data}    fulfillments
    Should Contain    ${json_data}    total

    # Vérifier qu'il y a au moins 1 fulfillment
    Should Be True    ${json_data['total']} >= 1

    Log     Liste récupérée avec succès !
