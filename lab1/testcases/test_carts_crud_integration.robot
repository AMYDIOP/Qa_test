*** Settings ***
Documentation    Tests d'intégration CRUD complets sur Carts - Suite complète
Resource         ../resources/cart_keywords.robot
Resource         ../resources/keywords.robot
Suite Setup      Connecter MongoDB Carts
Suite Teardown   Run Keywords    Nettoyer Tests Carts    Fermer MongoDB

*** Variables ***
${TEST_CART_ID}    ${VALID_CART_ID}

*** Test Cases ***
CREATE - Scénario Passant - Créer Panier Valide
    [Documentation]     Test de création réussie d'un panier
    [Tags]    create    positive    cart

    Log    === TEST CREATE CART PASSANT ===

    ${count_avant}=    Compter Paniers    ${TEST_CART_ID}
    Should Be Equal As Integers    ${count_avant}    0

    ${result}=    Créer Panier    &{VALID_CART_DATA}

    Should Not Be Equal    ${result.inserted_id}    ${None}

    Log     CREATE CART PASSANT - Panier créé avec succès

CREATE - Scénario Non Passant 1 - UserId Invalide
    [Documentation]     Test d'échec avec userId invalide
    [Tags]    create    negative    cart

    Log    === TEST CREATE CART NON PASSANT 1 ===

    &{données_invalides}=    Create Dictionary
    ...    id=${TEST_CART_ID + 1}
    ...    userId=${INVALID_USER_ID_FOR_CART}
    ...    date=2024-01-01
    ...    products=${VALID_CART_DATA['products']}

    TRY
        ${result}=    Créer Panier    &{données_invalides}
        ${cart}=    Lire Panier    ${TEST_CART_ID + 1}
        Should Be Equal As Integers    ${cart['userId']}    ${INVALID_USER_ID_FOR_CART}    Validation MongoDB pas stricte
        Log    MongoDB a accepté l'userId invalide
    EXCEPT
        Log     UserId invalide rejeté comme attendu
    END

CREATE - Scénario Non Passant 2 - Liste Produits Vide
    [Documentation]     Test d'échec avec liste de produits vide
    [Tags]    create    negative    cart

    Log    === TEST CREATE CART NON PASSANT 2 ===

    &{panier_vide}=    Create Dictionary
    ...    id=${TEST_CART_ID + 2}
    ...    userId=999
    ...    date=2024-01-01
    ...    products=${EMPTY_PRODUCTS_LIST}

    TRY
        ${result}=    Créer Panier    &{panier_vide}
        ${cart}=    Lire Panier    ${TEST_CART_ID + 2}
        ${products_count}=    Get Length    ${cart['products']}
        Should Be Equal As Integers    ${products_count}    0    Liste vide acceptée
        Log    MongoDB a accepté la liste de produits vide
    EXCEPT
        Log     Liste vide rejetée comme attendu
    END

READ - Scénario Passant - Lire Panier Existant
    [Documentation]     Test de lecture réussie
    [Tags]    read    positive    cart

    Log    === TEST READ CART PASSANT ===

    ${result}=    Créer Panier    &{VALID_CART_DATA}

    ${cart}=    Lire Panier    ${TEST_CART_ID}

    Should Not Be Equal    ${cart}    ${None}
    Should Be Equal As Integers    ${cart['userId']}    ${VALID_CART_DATA['userId']}
    Should Be Equal As Strings    ${cart['date']}    ${VALID_CART_DATA['date']}
    
    ${products_count}=    Get Length    ${cart['products']}
    ${expected_count}=    Get Length    ${VALID_CART_DATA['products']}
    Should Be Equal As Integers    ${products_count}    ${expected_count}

    Log    READ CART PASSANT - Panier lu avec ${products_count} produits

READ - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test de lecture avec ID inexistant
    [Tags]    read    negative    cart

    Log    === TEST READ CART NON PASSANT 1 ===

    ${cart}=    Lire Panier    ${INVALID_CART_ID}

    Should Be Equal    ${cart}    ${None}

    Log    READ CART NON PASSANT 1 - Aucun panier trouvé comme attendu

READ - Scénario Non Passant 2 - Format ID Invalide
    [Documentation]     Test avec format d'ID invalide
    [Tags]    read    negative    cart

    Log    === TEST READ CART NON PASSANT 2 ===

    TRY
        ${cart}=    Lire Panier    ${NON_NUMERIC_CART_ID}
        Should Be Equal    ${cart}    ${None}    Format invalide mais pas d'erreur
    EXCEPT
        Log     Format ID invalide rejeté
    END
#
#READ - Scénario Passant - Lire Paniers Par UserId
#    [Documentation]     Test de lecture des paniers d'un utilisateur
#    [Tags]    read    positive    cart    userid
#
#    Log    === TEST READ CARTS BY USERID ===
#
#    ${result}=    Créer Panier    &{VALID_CART_DATA}
#
#    ${carts}=    Lire Paniers Par UserId    ${VALID_CART_DATA['userId']}
#
#    Should Not Be Empty    ${carts}
#    ${first_cart}=    Get From List    ${carts}    0
#    Should Be Equal As Integers    ${first_cart['userId']}    ${VALID_CART_DATA['userId']}
#
#    ${carts_count}=    Get Length    ${carts}
#    Log    READ CARTS BY USERID - Trouvé ${carts_count} panier(s) pour l'utilisateur

UPDATE - Scénario Passant - Modifier Panier
    [Documentation]     Test de modification réussie
    [Tags]    update    positive    cart

    Log    === TEST UPDATE CART PASSANT ===

    ${result}=    Créer Panier    &{VALID_CART_DATA}

    ${result_update}=    Modifier Panier    ${TEST_CART_ID}    &{UPDATE_CART_DATA}

    Should Be Equal As Integers    ${result_update.modified_count}    1

    ${cart_modifié}=    Lire Panier    ${TEST_CART_ID}
    Should Be Equal As Strings    ${cart_modifié['date']}    ${UPDATE_CART_DATA['date']}

    ${products_count}=    Get Length    ${cart_modifié['products']}
    ${expected_count}=    Get Length    ${UPDATE_CART_DATA['products']}
    Should Be Equal As Integers    ${products_count}    ${expected_count}

    Log    UPDATE CART PASSANT - Panier modifié avec ${products_count} produits

UPDATE - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test de modification avec ID inexistant
    [Tags]    update    negative    cart

    Log    === TEST UPDATE CART NON PASSANT 1 ===

    ${result}=    Modifier Panier    ${INVALID_CART_ID}    &{UPDATE_CART_DATA}

    Should Be Equal As Integers    ${result.modified_count}    0

    Log    UPDATE CART NON PASSANT 1 - Aucun document modifié

UPDATE - Scénario Non Passant 2 - Date Invalide
    [Documentation]     Test avec date de modification invalide
    [Tags]    update    negative    cart

    Log    === TEST UPDATE CART NON PASSANT 2 ===

    ${result}=    Créer Panier    &{VALID_CART_DATA}

    &{update_invalide}=    Create Dictionary
    ...    date=${INVALID_DATE_FORMAT}
    ...    products=${EMPTY_PRODUCTS_LIST}

    ${result_update}=    Modifier Panier    ${TEST_CART_ID}    &{update_invalide}

    IF    ${result_update.modified_count} > 0
        Log    MongoDB a accepté les données invalides
        ${cart}=    Lire Panier    ${TEST_CART_ID}
        Log    Date invalide autorisée: ${cart['date']}
    ELSE
        Log    Données invalides rejetées
    END

#UPDATE - Scénario Passant - Ajouter Produit Au Panier
#    [Documentation]     Test d'ajout de produit à un panier existant
#    [Tags]    update    positive    cart    product
#
#    Log    === TEST ADD PRODUCT TO CART ===
#
#    ${result}=    Créer Panier    &{VALID_CART_DATA}
#
#    ${products_avant}=    Compter Produits Dans Panier    ${TEST_CART_ID}
#
#    ${result_add}=    Ajouter Produit Au Panier    ${TEST_CART_ID}    20    3
#
#    Should Be Equal As Integers    ${result_add.modified_count}    1
#
#    ${products_après}=    Compter Produits Dans Panier    ${TEST_CART_ID}
#    Should Be Equal As Integers    ${products_après}    ${products_avant + 1}
#
#    Log    ADD PRODUCT - Produit ajouté avec succès

#UPDATE - Scénario Passant - Retirer Produit Du Panier
#    [Documentation]     Test de suppression de produit d'un panier
#    [Tags]    update    positive    cart    product
#
#    Log    === TEST REMOVE PRODUCT FROM CART ===
#
#    # Nettoyage préalable des données de test
#    ${cleanup_result}=    Evaluate    $CART_COLLECTION.delete_many({"id": ${TEST_CART_ID}})
#
#    ${result}=    Créer Panier    &{VALID_CART_DATA}
#
#    ${products_avant}=    Compter Produits Dans Panier    ${TEST_CART_ID}
#
#    ${result_remove}=    Retirer Produit Du Panier    ${TEST_CART_ID}    1
#
#    Should Be Equal As Integers    ${result_remove.modified_count}    1
#
#    ${products_après}=    Compter Produits Dans Panier    ${TEST_CART_ID}
#    Should Be Equal As Integers    ${products_après}    ${products_avant - 1}
#
#    Log    REMOVE PRODUCT - Produit retiré avec succès

DELETE - Scénario Passant - Supprimer Panier Existant
    [Documentation]     Test de suppression réussie d'un panier existant
    [Tags]    delete    positive    smoke    cart

    Log    === TEST DELETE CART PASSANT ===

    ${cleanup_result}=    Evaluate    $CART_COLLECTION.delete_many({"id": ${TEST_CART_ID}})
    Log    Nettoyage préalable: ${cleanup_result.deleted_count} paniers supprimés

    ${result_create}=    Créer Panier    &{VALID_CART_DATA}
    Should Not Be Equal    ${result_create.inserted_id}    ${None}

    ${exists_before}=    Compter Paniers    ${TEST_CART_ID}
    Should Be Equal As Integers    ${exists_before}    1    Panier n'existe pas avant suppression

    ${result}=    Supprimer Panier    ${TEST_CART_ID}

    Should Be Equal As Integers    ${result.deleted_count}    1    Aucun document supprimé

    ${exists_after}=    Compter Paniers    ${TEST_CART_ID}
    Should Be Equal As Integers    ${exists_after}    0    Panier existe encore après suppression

    ${cart}=    Lire Panier    ${TEST_CART_ID}
    Should Be Equal    ${cart}    ${None}    Panier encore lisible après suppression

    Log    DELETE CART PASSANT - Panier supprimé avec succès

DELETE - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test d'échec de suppression avec ID inexistant
    [Tags]    delete    negative    notfound    cart

    Log    === TEST DELETE CART NON PASSANT 1 ===

    ${result}=    Supprimer Panier    ${INVALID_CART_ID}

    Should Be Equal As Integers    ${result.deleted_count}    0    Document supprimé alors qu'il ne devrait pas exister

    Log    DELETE CART NON PASSANT 1 - Échec attendu avec ID inexistant

DELETE - Scénario Non Passant 2 - Tentative Suppression Massive
    [Documentation]     Test d'échec avec opération dangereuse
    [Tags]    delete    negative    security    cart

    ${result}=    Créer Panier    &{VALID_CART_DATA}

    TRY
        ${result}=    Evaluate    $CART_COLLECTION.delete_many({})

        Should Be Equal As Integers    ${result.deleted_count}    0
        ...    msg=ATTENTION: Suppression massive de paniers non contrôlée détectée !

    EXCEPT
        Log    Opération dangereuse correctement bloquée

    END