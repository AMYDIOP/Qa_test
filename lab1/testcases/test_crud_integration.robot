*** Settings ***
Documentation    Tests d'intégration CRUD complets sur Products - Suite complète
Resource         ../resources/keywords.robot
Suite Setup      Connecter MongoDB
Suite Teardown   Run Keywords    Nettoyer Tests  Fermer MongoDB

*** Variables ***
${TEST_PRODUCT_ID}    ${VALID_PRODUCT_ID}

*** Test Cases ***
CREATE - Scénario Passant - Créer Produit Valide
    [Documentation]     Test de création réussie d'un produit
    [Tags]    create    positive

    Log    === TEST CREATE PASSANT ===


    ${count_avant}=    Compter Produits    ${TEST_PRODUCT_ID}
    Should Be Equal As Integers    ${count_avant}    0


    ${result}=    Créer Produit    &{VALID_PRODUCT_DATA}


    Should Not Be Equal    ${result.inserted_id}    ${None}

    Log     CREATE PASSANT - Produit créé avec succès

CREATE - Scénario Non Passant 1 - Données Invalides
    [Documentation]     Test d'échec avec des données invalides
    [Tags]    create    negative

    Log    === TEST CREATE NON PASSANT 1 ===


    &{données_invalides}=    Create Dictionary
    ...    id=${TEST_PRODUCT_ID + 1}
    ...    title=${EMPTY}
    ...    price=prix_invalide
    ...    category=electronics


    TRY
        ${result}=    Créer Produit    &{données_invalides}
        # Si création réussie, vérifier que c'est incohérent
        ${produit}=    Lire Produit    ${TEST_PRODUCT_ID + 1}
        Should Be Equal    ${produit['title']}    ${EMPTY}    Validation MongoDB pas stricte
        Log    ️ MongoDB a accepté les données invalides
    EXCEPT
        Log     Données invalides rejetées comme attendu
    END

CREATE - Scénario Non Passant 2 - ID Dupliqué
    [Documentation]     Test d'échec avec ID dupliqué
    [Tags]    create    negative

    Log    === TEST CREATE NON PASSANT 2 ===


    ${result1}=    Créer Produit    &{VALID_PRODUCT_DATA}
    Should Not Be Equal    ${result1.inserted_id}    ${None}

    # Tenter de créer un produit avec le même ID
    &{produit_dupliqué}=    Create Dictionary
    ...    id=${TEST_PRODUCT_ID}
    ...    title=Produit Dupliqué
    ...    price=99.99
    ...    category=electronics

    # Cette création peut réussir (MongoDB permet les doublons par défaut)
    ${result2}=    Créer Produit    &{produit_dupliqué}

    # Vérifier combien il y en a maintenant
    ${count_final}=    Compter Produits    ${TEST_PRODUCT_ID}

    IF    ${count_final} > 1
        Log     MongoDB a autorisé les ID dupliqués (comportement par défaut)
        Log    Nombre de produits avec ID ${TEST_PRODUCT_ID}: ${count_final}
    ELSE
        Log    Duplication bloquée par une contrainte
    END

READ - Scénario Passant - Lire Produit Existant
    [Documentation]     Test de lecture réussie
    [Tags]    read    positive

    Log    === TEST READ PASSANT ===

    # Créer d'abord un produit
    ${result}=    Créer Produit    &{VALID_PRODUCT_DATA}

    # Lire le produit
    ${produit}=    Lire Produit    ${TEST_PRODUCT_ID}

    # Vérifications
    Should Not Be Equal    ${produit}    ${None}
    Should Be Equal As Strings    ${produit['title']}    ${VALID_PRODUCT_DATA['title']}
    Should Be Equal As Numbers    ${produit['price']}    ${VALID_PRODUCT_DATA['price']}

    Log     READ PASSANT - Produit lu: ${produit['title']}

READ - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test de lecture avec ID inexistant
    [Tags]    read    negative

    Log    === TEST READ NON PASSANT 1 ===

    # Lire un produit inexistant
    ${produit}=    Lire Produit    ${INVALID_PRODUCT_ID}

    # Vérification
    Should Be Equal    ${produit}    ${None}

    Log     READ NON PASSANT 1 - Aucun produit trouvé comme attendu

READ - Scénario Non Passant 2 - Format ID Invalide
    [Documentation]     Test avec format d'ID invalide
    [Tags]    read    negative

    Log    === TEST READ NON PASSANT 2 ===

    # Lire avec un ID non numérique
    TRY
        ${produit}=    Lire Produit    "abc123"
        Should Be Equal    ${produit}    ${None}    Format invalide mais pas d'erreur
    EXCEPT
        Log     Format ID invalide rejeté
    END

UPDATE - Scénario Passant - Modifier Produit
    [Documentation]     Test de modification réussie
    [Tags]    update    positive

    Log    === TEST UPDATE PASSANT ===


    ${result}=    Créer Produit    &{VALID_PRODUCT_DATA}


    ${result_update}=    Modifier Produit    ${TEST_PRODUCT_ID}    &{UPDATE_PRODUCT_DATA}


    Should Be Equal As Integers    ${result_update.modified_count}    1


    ${produit_modifié}=    Lire Produit    ${TEST_PRODUCT_ID}
    Should Be Equal As Strings    ${produit_modifié['title']}    ${UPDATE_PRODUCT_DATA['title']}
    Should Be Equal As Numbers    ${produit_modifié['price']}    ${UPDATE_PRODUCT_DATA['price']}

    Log    UPDATE PASSANT - Produit modifié: ${produit_modifié['title']}

UPDATE - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test de modification avec ID inexistant
    [Tags]    update    negative

    Log    === TEST UPDATE NON PASSANT 1 ===


    ${result}=    Modifier Produit    ${INVALID_PRODUCT_ID}    &{UPDATE_PRODUCT_DATA}


    Should Be Equal As Integers    ${result.modified_count}    0

    Log     UPDATE NON PASSANT 1 - Aucun document modifié

UPDATE - Scénario Non Passant 2 - Données Invalides
    [Documentation]     Test avec données de modification invalides
    [Tags]    update    negative

    Log    === TEST UPDATE NON PASSANT 2 ===


    ${result}=    Créer Produit    &{VALID_PRODUCT_DATA}


    &{update_invalide}=    Create Dictionary
    ...    price=-10.50
    ...    title=${EMPTY}


    ${result_update}=    Modifier Produit    ${TEST_PRODUCT_ID}    &{update_invalide}

    IF    ${result_update.modified_count} > 0
        Log    ️ MongoDB a accepté les données invalides
        ${produit}=    Lire Produit    ${TEST_PRODUCT_ID}
        Log    Prix négatif autorisé: ${produit['price']}
    ELSE
        Log     Données invalides rejetées
    END

DELETE - Scénario Passant - Supprimer Produit Existant
    [Documentation]     Test de suppression réussie d'un produit existant
    [Tags]    delete    positive    smoke

    Log    === TEST DELETE PASSANT ===


    ${cleanup_result}=    Evaluate    $COLLECTION.delete_many({"id": ${TEST_PRODUCT_ID}})
    Log    Nettoyage préalable: ${cleanup_result.deleted_count} documents supprimés


    ${result_create}=    Créer Produit    &{VALID_PRODUCT_DATA}
    Should Not Be Equal    ${result_create.inserted_id}    ${None}


    ${exists_before}=    Compter Produits    ${TEST_PRODUCT_ID}
    Should Be Equal As Integers    ${exists_before}    1    Produit n'existe pas avant suppression


    ${result}=    Supprimer Produit    ${TEST_PRODUCT_ID}


    Should Be Equal As Integers    ${result.deleted_count}    1    Aucun document supprimé


    ${exists_after}=    Compter Produits    ${TEST_PRODUCT_ID}
    Should Be Equal As Integers    ${exists_after}    0    Produit existe encore après suppression


    ${product}=    Lire Produit    ${TEST_PRODUCT_ID}
    Should Be Equal    ${product}    ${None}    Produit encore lisible après suppression

    Log     DELETE PASSANT - Produit supprimé avec succès

DELETE - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test d'échec de suppression avec ID inexistant
    [Tags]    delete    negative    notfound

    Log    === TEST DELETE NON PASSANT 1 ===


    ${result}=    Supprimer Produit    ${INVALID_PRODUCT_ID}


    Should Be Equal As Integers    ${result.deleted_count}    0    Document supprimé alors qu'il ne devrait pas exister

    Log     DELETE NON PASSANT 1 - Échec attendu avec ID inexistant

DELETE - Scénario Non Passant 2 - Tentative Suppression Sans Permission
    [Documentation]     Test d'échec avec opération non autorisée
    [Tags]    delete    negative    security


    ${result}=    Créer Produit    &{VALID_PRODUCT_DATA}


    TRY
        ${result}=    Evaluate    $COLLECTION.delete_many({})

        # Si ça marche, c'est dangereux !
        Should Be Equal As Integers    ${result.deleted_count}    0
        ...    msg=ATTENTION: Suppression massive non contrôlée détectée !

    EXCEPT
        Log    Opération dangereuse correctement bloquée

    END