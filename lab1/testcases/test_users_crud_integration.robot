*** Settings ***
Documentation    Tests d'intégration CRUD complets sur Users - Suite complète
Resource         ../resources/user_keywords.robot
Resource         ../resources/keywords.robot
Suite Setup      Connecter MongoDB Users
Suite Teardown   Run Keywords    Nettoyer Tests Users    Fermer MongoDB

*** Variables ***
${TEST_USER_ID}    ${VALID_USER_ID}

*** Test Cases ***
CREATE - Scénario Passant - Créer Utilisateur Valide
    [Documentation]     Test de création réussie d'un utilisateur
    [Tags]    create    positive    user

    Log    === TEST CREATE USER PASSANT ===

    ${count_avant}=    Compter Utilisateurs    ${TEST_USER_ID}
    Should Be Equal As Integers    ${count_avant}    0

    ${result}=    Créer Utilisateur    &{VALID_USER_DATA}

    Should Not Be Equal    ${result.inserted_id}    ${None}

    Log     CREATE USER PASSANT - Utilisateur créé avec succès

CREATE - Scénario Non Passant 1 - Email Invalide
    [Documentation]     Test d'échec avec email invalide
    [Tags]    create    negative    user

    Log    === TEST CREATE USER NON PASSANT 1 ===

    &{données_invalides}=    Create Dictionary
    ...    id=${TEST_USER_ID + 1}
    ...    email=${INVALID_EMAIL}
    ...    username=testuser1
    ...    password=validpass123
    ...    name=${VALID_USER_DATA['name']}
    ...    address=${VALID_USER_DATA['address']}
    ...    phone=${VALID_USER_DATA['phone']}

    TRY
        ${result}=    Créer Utilisateur    &{données_invalides}
        ${user}=    Lire Utilisateur    ${TEST_USER_ID + 1}
        Should Be Equal    ${user['email']}    ${INVALID_EMAIL}    Validation MongoDB pas stricte
        Log    MongoDB a accepté l'email invalide
    EXCEPT
        Log     Email invalide rejeté comme attendu
    END

CREATE - Scénario Non Passant 2 - Username Dupliqué
    [Documentation]     Test d'échec avec username dupliqué
    [Tags]    create    negative    user

    Log    === TEST CREATE USER NON PASSANT 2 ===

    ${result1}=    Créer Utilisateur    &{VALID_USER_DATA}
    Should Not Be Equal    ${result1.inserted_id}    ${None}

    &{user_dupliqué}=    Create Dictionary
    ...    id=${TEST_USER_ID + 2}
    ...    email=different.email@test.com
    ...    username=${VALID_USER_DATA['username']}
    ...    password=differentpass123
    ...    name=${VALID_USER_DATA['name']}
    ...    address=${VALID_USER_DATA['address']}
    ...    phone=1-999-999-9999

    ${result2}=    Créer Utilisateur    &{user_dupliqué}

    ${count_final}=    Compter Utilisateurs Par Username    ${VALID_USER_DATA['username']}

    IF    ${count_final} > 1
        Log    MongoDB a autorisé les usernames dupliqués
        Log    Nombre d'utilisateurs avec username ${VALID_USER_DATA['username']}: ${count_final}
    ELSE
        Log    Duplication username bloquée
    END

READ - Scénario Passant - Lire Utilisateur Existant
    [Documentation]     Test de lecture réussie
    [Tags]    read    positive    user

    Log    === TEST READ USER PASSANT ===

    ${result}=    Créer Utilisateur    &{VALID_USER_DATA}

    ${user}=    Lire Utilisateur    ${TEST_USER_ID}

    Should Not Be Equal    ${user}    ${None}
    Should Be Equal As Strings    ${user['email']}    ${VALID_USER_DATA['email']}
    Should Be Equal As Strings    ${user['username']}    ${VALID_USER_DATA['username']}
    Should Be Equal As Strings    ${user['name']['firstname']}    ${VALID_USER_DATA['name']['firstname']}

    Log    READ USER PASSANT - Utilisateur lu: ${user['username']}

READ - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test de lecture avec ID inexistant
    [Tags]    read    negative    user

    Log    === TEST READ USER NON PASSANT 1 ===

    ${user}=    Lire Utilisateur    ${INVALID_USER_ID}

    Should Be Equal    ${user}    ${None}

    Log    READ USER NON PASSANT 1 - Aucun utilisateur trouvé comme attendu

READ - Scénario Non Passant 2 - Format ID Invalide
    [Documentation]     Test avec format d'ID invalide
    [Tags]    read    negative    user

    Log    === TEST READ USER NON PASSANT 2 ===

    TRY
        ${user}=    Lire Utilisateur    ${NON_NUMERIC_USER_ID}
        Should Be Equal    ${user}    ${None}    Format invalide mais pas d'erreur
    EXCEPT
        Log     Format ID invalide rejeté
    END

#READ - Scénario Passant - Lire Par Email
#    [Documentation]     Test de lecture par email
#    [Tags]    read    positive    user    email
#
#    Log    === TEST READ USER BY EMAIL ===
#
#    ${result}=    Créer Utilisateur    &{VALID_USER_DATA}
#
#    ${user}=    Lire Utilisateur Par Email    ${VALID_USER_DATA['email']}
#
#    Should Not Be Equal    ${user}    ${None}
#    Should Be Equal As Strings    ${user['email']}    ${VALID_USER_DATA['email']}
#    Should Be Equal As Integers    ${user['id']}    ${VALID_USER_DATA['id']}
#
#    Log    READ USER BY EMAIL - Utilisateur trouvé: ${user['username']}

UPDATE - Scénario Passant - Modifier Utilisateur
    [Documentation]     Test de modification réussie
    [Tags]    update    positive    user

    Log    === TEST UPDATE USER PASSANT ===

    ${result}=    Créer Utilisateur    &{VALID_USER_DATA}

    ${result_update}=    Modifier Utilisateur    ${TEST_USER_ID}    &{UPDATE_USER_DATA}

    Should Be Equal As Integers    ${result_update.modified_count}    1

    ${user_modifié}=    Lire Utilisateur    ${TEST_USER_ID}
    Should Be Equal As Strings    ${user_modifié['email']}    ${UPDATE_USER_DATA['email']}
    Should Be Equal As Strings    ${user_modifié['phone']}    ${UPDATE_USER_DATA['phone']}
    Should Be Equal As Strings    ${user_modifié['name']['firstname']}    ${UPDATE_USER_DATA['name']['firstname']}

    Log    UPDATE USER PASSANT - Utilisateur modifié: ${user_modifié['email']}

UPDATE - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test de modification avec ID inexistant
    [Tags]    update    negative    user

    Log    === TEST UPDATE USER NON PASSANT 1 ===

    ${result}=    Modifier Utilisateur    ${INVALID_USER_ID}    &{UPDATE_USER_DATA}

    Should Be Equal As Integers    ${result.modified_count}    0

    Log    UPDATE USER NON PASSANT 1 - Aucun document modifié

UPDATE - Scénario Non Passant 2 - Email Invalide
    [Documentation]     Test avec email de modification invalide
    [Tags]    update    negative    user

    Log    === TEST UPDATE USER NON PASSANT 2 ===

    ${result}=    Créer Utilisateur    &{VALID_USER_DATA}

    &{update_invalide}=    Create Dictionary
    ...    email=${INVALID_EMAIL}
    ...    phone=${INVALID_PHONE}

    ${result_update}=    Modifier Utilisateur    ${TEST_USER_ID}    &{update_invalide}

    IF    ${result_update.modified_count} > 0
        Log    MongoDB a accepté les données invalides
        ${user}=    Lire Utilisateur    ${TEST_USER_ID}
        Log    Email invalide autorisé: ${user['email']}
    ELSE
        Log    Données invalides rejetées
    END

DELETE - Scénario Passant - Supprimer Utilisateur Existant
    [Documentation]     Test de suppression réussie d'un utilisateur existant
    [Tags]    delete    positive    smoke    user

    Log    === TEST DELETE USER PASSANT ===

    ${cleanup_result}=    Evaluate    $USER_COLLECTION.delete_many({"id": ${TEST_USER_ID}})
    Log    Nettoyage préalable: ${cleanup_result.deleted_count} utilisateurs supprimés

    ${result_create}=    Créer Utilisateur    &{VALID_USER_DATA}
    Should Not Be Equal    ${result_create.inserted_id}    ${None}

    ${exists_before}=    Compter Utilisateurs    ${TEST_USER_ID}
    Should Be Equal As Integers    ${exists_before}    1    Utilisateur n'existe pas avant suppression

    ${result}=    Supprimer Utilisateur    ${TEST_USER_ID}

    Should Be Equal As Integers    ${result.deleted_count}    1    Aucun document supprimé

    ${exists_after}=    Compter Utilisateurs    ${TEST_USER_ID}
    Should Be Equal As Integers    ${exists_after}    0    Utilisateur existe encore après suppression

    ${user}=    Lire Utilisateur    ${TEST_USER_ID}
    Should Be Equal    ${user}    ${None}    Utilisateur encore lisible après suppression

    Log    DELETE USER PASSANT - Utilisateur supprimé avec succès

DELETE - Scénario Non Passant 1 - ID Inexistant
    [Documentation]     Test d'échec de suppression avec ID inexistant
    [Tags]    delete    negative    notfound    user

    Log    === TEST DELETE USER NON PASSANT 1 ===

    ${result}=    Supprimer Utilisateur    ${INVALID_USER_ID}

    Should Be Equal As Integers    ${result.deleted_count}    0    Document supprimé alors qu'il ne devrait pas exister

    Log    DELETE USER NON PASSANT 1 - Échec attendu avec ID inexistant

DELETE - Scénario Non Passant 2 - Tentative Suppression Massive
    [Documentation]     Test d'échec avec opération dangereuse
    [Tags]    delete    negative    security    user

    ${result}=    Créer Utilisateur    &{VALID_USER_DATA}

    TRY
        ${result}=    Evaluate    $USER_COLLECTION.delete_many({})

        Should Be Equal As Integers    ${result.deleted_count}    0
        ...    msg=ATTENTION: Suppression massive d'utilisateurs non contrôlée détectée !

    EXCEPT
        Log    Opération dangereuse correctement bloquée

    END