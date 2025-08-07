*** Settings ***
Library          Collections
Library          BuiltIn
Variables        ../pageobject/variable.py
Variables        ../pageobject/user_variables.py
*** Variables ***
${USER_COLLECTION}    ${None}

*** Keywords ***
Connecter MongoDB Users
    [Documentation]    Se connecter à MongoDB Atlas pour les users
    ${client}=    Evaluate    __import__('pymongo').MongoClient("${MONGODB_CONNECTION_STRING}")
    ${db}=        Evaluate    $client["${DATABASE_NAME}"]
    ${coll}=      Evaluate    $db["users"]

    Set Global Variable    ${DB_CLIENT}        ${client}
    Set Global Variable    ${DATABASE}         ${db}
    Set Global Variable    ${USER_COLLECTION}  ${coll}

    Log     Connexion MongoDB Users réussie

Nettoyer Tests Users
    [Documentation]    Supprimer les données de test des users
    TRY
        ${result}=    Evaluate    $USER_COLLECTION.delete_many({"id": {"$gte": 9999}})
        Log     ${result.deleted_count} users supprimés
    EXCEPT
        Log     Nettoyage users ignoré
    END

Créer Utilisateur
    [Arguments]    &{user_data}
    [Documentation]    Créer un utilisateur dans MongoDB
    ${result}=    Evaluate    $USER_COLLECTION.insert_one($user_data)
    RETURN    ${result}

Lire Utilisateur
    [Arguments]    ${user_id}
    [Documentation]    Lire un utilisateur par ID
    ${user}=    Evaluate    $USER_COLLECTION.find_one({"id": ${user_id}})
    RETURN    ${user}

Modifier Utilisateur
    [Arguments]    ${user_id}    &{update_data}
    [Documentation]    Modifier un utilisateur
    ${result}=    Evaluate    $USER_COLLECTION.update_one({"id": ${user_id}}, {"$set": $update_data})
    RETURN    ${result}

Supprimer Utilisateur
    [Arguments]    ${user_id}
    [Documentation]    Supprimer un utilisateur
    ${result}=    Evaluate    $USER_COLLECTION.delete_one({"id": ${user_id}})
    RETURN    ${result}

Compter Utilisateurs
    [Arguments]    ${user_id}
    [Documentation]    Compter les utilisateurs avec cet ID
    ${count}=    Evaluate    $USER_COLLECTION.count_documents({"id": ${user_id}})
    RETURN    ${count}

Lire Utilisateur Par Email
    [Arguments]    ${email}
    [Documentation]    Lire un utilisateur par email
    ${user}=    Evaluate    $USER_COLLECTION.find_one({"email": "${email}"})
    RETURN    ${user}

Lire Utilisateur Par Username
    [Arguments]    ${username}
    [Documentation]    Lire un utilisateur par username
    ${user}=    Evaluate    $USER_COLLECTION.find_one({"username": "${username}"})
    RETURN    ${user}

Compter Utilisateurs Par Email
    [Arguments]    ${email}
    [Documentation]    Compter les utilisateurs avec cet email
    ${count}=    Evaluate    $USER_COLLECTION.count_documents({"email": "${email}"})
    RETURN    ${count}

Compter Utilisateurs Par Username
    [Arguments]    ${username}
    [Documentation]    Compter les utilisateurs avec ce username
    ${count}=    Evaluate    $USER_COLLECTION.count_documents({"username": "${username}"})
    RETURN    ${count}