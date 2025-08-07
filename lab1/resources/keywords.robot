*** Settings ***
Library          Collections
Library          BuiltIn
Variables        ../pageobject/variable.py
Variables        ../pageobject/locator.py

*** Variables ***
${DB_CLIENT}      ${None}
${DATABASE}       ${None}
${COLLECTION}     ${None}

*** Keywords ***
Connecter MongoDB
    [Documentation]    Se connecter à MongoDB Atlas
    ${client}=    Evaluate    __import__('pymongo').MongoClient("${MONGODB_CONNECTION_STRING}")
    ${db}=        Evaluate    $client["${DATABASE_NAME}"]
    ${coll}=      Evaluate    $db["${COLLECTION_NAME}"]

    Set Global Variable    ${DB_CLIENT}     ${client}
    Set Global Variable    ${DATABASE}      ${db}
    Set Global Variable    ${COLLECTION}    ${coll}

    Log     Connexion MongoDB réussie

Fermer MongoDB
    [Documentation]    Fermer la connexion
    Run Keyword If    "${DB_CLIENT}" != "${None}"    Evaluate    $DB_CLIENT.close()
    Log     Connexion fermée

Nettoyer Tests
    [Documentation]    Supprimer les données de test
    TRY
        ${result}=    Evaluate    $COLLECTION.delete_many({"id": {"$gte": 999}})
        Log     ${result.deleted_count} documents supprimés
    EXCEPT
        Log     Nettoyage ignoré
    END

Créer Produit
    [Arguments]    &{product_data}
    [Documentation]    Créer un produit dans MongoDB
    ${result}=    Evaluate    $COLLECTION.insert_one($product_data)
    RETURN    ${result}

Lire Produit
    [Arguments]    ${product_id}
    [Documentation]    Lire un produit par ID
    ${product}=    Evaluate    $COLLECTION.find_one({"id": ${product_id}})
    RETURN    ${product}

Modifier Produit
    [Arguments]    ${product_id}    &{update_data}
    [Documentation]    Modifier un produit
    ${result}=    Evaluate    $COLLECTION.update_one({"id": ${product_id}}, {"$set": $update_data})
    RETURN    ${result}

Supprimer Produit
    [Arguments]    ${product_id}
    [Documentation]    Supprimer un produit
    ${result}=    Evaluate    $COLLECTION.delete_one({"id": ${product_id}})
    RETURN    ${result}

Compter Produits
    [Arguments]    ${product_id}
    [Documentation]    Compter les produits avec cet ID
    ${count}=    Evaluate    $COLLECTION.count_documents({"id": ${product_id}})
    RETURN    ${count}