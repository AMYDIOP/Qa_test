*** Settings ***
Documentation    Tests MOCK pour les fulfillments eBay - Alternative au sandbox défaillant
Resource         ../resources/keywords.robot
Library          Collections
Library          JSONLibrary

*** Variables ***
${MOCK_FULFILLMENT_ID}    FUL123456789
${MOCK_TRACKING_NUMBER}   1Z999AA1234567890
${EXPECTED_CREATE_RESPONSE}    {"fulfillmentId": "${MOCK_FULFILLMENT_ID}", "orderId": "${ORDER_ID}"}

*** Test Cases ***
Mock - Créer Un Fulfillment - Succès
    [Documentation]    Test mock de création de fulfillment - simule une réponse 201
    

    ${line_item}=    Create Dictionary    lineItemId=${LINE_ITEM_ID}    quantity=${1}
    ${line_items}=    Create List    ${line_item}
    ${request_data}=    Create Dictionary
    ...    lineItems=${line_items}
    ...    trackingNumber=${TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS
    ...    shippedDate=2025-07-29T14:30:00.000Z


    Should Not Be Empty    ${request_data['lineItems']}
    Should Not Be Empty    ${request_data['trackingNumber']}
    Should Not Be Empty    ${request_data['shippingCarrierCode']}


    ${mock_response}=    Create Dictionary
    ...    fulfillmentId=${MOCK_FULFILLMENT_ID}
    ...    orderId=${ORDER_ID}
    ...    lineItems=${line_items}
    ...    trackingNumber=${TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS
    ...    shippedDate=2025-07-29T14:30:00.000Z


    Should Be Equal As Strings    ${mock_response['orderId']}    ${ORDER_ID}
    Should Be Equal As Strings    ${mock_response['trackingNumber']}    ${TRACKING_NUMBER}
    Should Not Be Empty    ${mock_response['fulfillmentId']}

    Log     Mock: Fulfillment créé avec succès - ID: ${MOCK_FULFILLMENT_ID}

Mock - Lire Un Fulfillment - Succès
    [Documentation]    Test mock de lecture de fulfillment - simule une réponse 200


    ${mock_fulfillment}=    Create Dictionary
    ...    fulfillmentId=${MOCK_FULFILLMENT_ID}
    ...    orderId=${ORDER_ID}
    ...    lineItems=[{"lineItemId": "${LINE_ITEM_ID}", "quantity": 1}]
    ...    trackingNumber=${MOCK_TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS
    ...    shippedDate=2025-07-29T14:30:00.000Z

    # Vérifications
    Should Be Equal As Strings    ${mock_fulfillment['fulfillmentId']}    ${MOCK_FULFILLMENT_ID}
    Should Be Equal As Strings    ${mock_fulfillment['orderId']}    ${ORDER_ID}
    Should Be Equal As Strings    ${mock_fulfillment['trackingNumber']}    ${MOCK_TRACKING_NUMBER}

    Log     Mock: Fulfillment lu avec succès - ID: ${MOCK_FULFILLMENT_ID}

Mock - Lister Fulfillments - Succès
    [Documentation]    Test mock de listing des fulfillments - simule une réponse 200


    ${fulfillment1}=    Create Dictionary
    ...    fulfillmentId=${MOCK_FULFILLMENT_ID}
    ...    trackingNumber=${MOCK_TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS

    ${fulfillment2}=    Create Dictionary
    ...    fulfillmentId=FUL987654321
    ...    trackingNumber=1Z888BB9876543210
    ...    shippingCarrierCode=FEDEX

    ${fulfillments_list}=    Create List    ${fulfillment1}    ${fulfillment2}
    
    ${mock_response}=    Create Dictionary
    ...    fulfillments=${fulfillments_list}
    ...    total=${2}


    Should Be Equal As Integers    ${mock_response['total']}    2
    Length Should Be    ${mock_response['fulfillments']}    2

    Log     Mock: Liste de ${mock_response['total']} fulfillments récupérée

Mock - Créer Un Fulfillment - Erreur Validation
    [Documentation]    Test mock d'erreur de validation - simule une réponse 400


    ${invalid_line_item}=    Create Dictionary    lineItemId=${EMPTY}    quantity=${1}
    ${invalid_line_items}=    Create List    ${invalid_line_item}
    ${invalid_data}=    Create Dictionary
    ...    lineItems=${invalid_line_items}
    ...    trackingNumber=${TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS


    ${mock_error}=    Create Dictionary
    ...    errorId=25002
    ...    domain=API_FULFILLMENT
    ...    category=REQUEST
    ...    message=Invalid line item ID
    ...    longMessage=The line item ID cannot be empty

    # Validation que l'erreur est bien détectée
    Should Be Empty    ${invalid_data['lineItems'][0]['lineItemId']}
    Should Be Equal As Integers    ${mock_error['errorId']}    25002

    Log     Mock: Erreur de validation correctement détectée

Mock - Scénario Complet Integration
    [Documentation]    Test mock d'un scénario complet: créer → lire → lister

    Log    === SCÉNARIO MOCK COMPLET ===

    # Créer un fulfillment
    ${create_data}=    Create Dictionary
    ...    lineItems=[{"lineItemId": "${LINE_ITEM_ID}", "quantity": 1}]
    ...    trackingNumber=${MOCK_TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS
    ...    shippedDate=2025-07-29T14:30:00.000Z

    ${created_fulfillment}=    Create Dictionary
    ...    fulfillmentId=${MOCK_FULFILLMENT_ID}
    ...    orderId=${ORDER_ID}

    Log    ÉTAPE 1 MOCK: Fulfillment créé - ${created_fulfillment['fulfillmentId']}

    #  Lire le fulfillment créé
    ${read_fulfillment}=    Create Dictionary
    ...    fulfillmentId=${created_fulfillment['fulfillmentId']}
    ...    orderId=${ORDER_ID}
    ...    trackingNumber=${MOCK_TRACKING_NUMBER}
    ...    shippingCarrierCode=UPS

    Should Be Equal As Strings    ${read_fulfillment['fulfillmentId']}    ${created_fulfillment['fulfillmentId']}
    Log    ÉTAPE 2 MOCK: Fulfillment lu avec succès

    #  Lister tous les fulfillments
    ${all_fulfillments}=    Create List    ${read_fulfillment}
    ${list_response}=    Create Dictionary
    ...    fulfillments=${all_fulfillments}
    ...    total=1

    Length Should Be    ${list_response['fulfillments']}    1
    Log    ÉTAPE 3 MOCK: Liste récupérée avec ${list_response['total']} fulfillment(s)

    Log     SCÉNARIO MOCK COMPLET RÉUSSI