*** Settings ***
Library          Collections
Library          BuiltIn
Variables        ../pageobject/variable.py
Variables        ../pageobject/cart_variables.py

*** Variables ***
${CART_COLLECTION}    ${None}

*** Keywords ***
Connecter MongoDB Carts
    [Documentation]    Se connecter à MongoDB Atlas pour les carts
    ${client}=    Evaluate    __import__('pymongo').MongoClient("${MONGODB_CONNECTION_STRING}")
    ${db}=        Evaluate    $client["${DATABASE_NAME}"]
    ${coll}=      Evaluate    $db["carts"]

    Set Global Variable    ${DB_CLIENT}         ${client}
    Set Global Variable    ${DATABASE}          ${db}
    Set Global Variable    ${CART_COLLECTION}   ${coll}

    Log     Connexion MongoDB Carts réussie

Nettoyer Tests Carts
    [Documentation]    Supprimer les données de test des carts
    TRY
        ${result}=    Evaluate    $CART_COLLECTION.delete_many({"id": {"$gte": 9999}})
        Log     ${result.deleted_count} carts supprimés
    EXCEPT
        Log     Nettoyage carts ignoré
    END

Créer Panier
    [Arguments]    &{cart_data}
    [Documentation]    Créer un panier dans MongoDB
    ${result}=    Evaluate    $CART_COLLECTION.insert_one($cart_data)
    RETURN    ${result}

Lire Panier
    [Arguments]    ${cart_id}
    [Documentation]    Lire un panier par ID
    ${cart}=    Evaluate    $CART_COLLECTION.find_one({"id": ${cart_id}})
    RETURN    ${cart}

Modifier Panier
    [Arguments]    ${cart_id}    &{update_data}
    [Documentation]    Modifier un panier
    ${result}=    Evaluate    $CART_COLLECTION.update_one({"id": ${cart_id}}, {"$set": $update_data})
    RETURN    ${result}

Supprimer Panier
    [Arguments]    ${cart_id}
    [Documentation]    Supprimer un panier
    ${result}=    Evaluate    $CART_COLLECTION.delete_one({"id": ${cart_id}})
    RETURN    ${result}

Compter Paniers
    [Arguments]    ${cart_id}
    [Documentation]    Compter les paniers avec cet ID
    ${count}=    Evaluate    $CART_COLLECTION.count_documents({"id": ${cart_id}})
    RETURN    ${count}

Lire Paniers Par UserId
    [Arguments]    ${user_id}
    [Documentation]    Lire tous les paniers d'un utilisateur
    ${carts}=    Evaluate    list($CART_COLLECTION.find({"userId": ${user_id}}))
    RETURN    ${carts}

Compter Paniers Par UserId
    [Arguments]    ${user_id}
    [Documentation]    Compter les paniers d'un utilisateur
    ${count}=    Evaluate    $CART_COLLECTION.count_documents({"userId": ${user_id}})
    RETURN    ${count}

Ajouter Produit Au Panier
    [Arguments]    ${cart_id}    ${product_id}    ${quantity}
    [Documentation]    Ajouter un produit à un panier existant
    ${new_product}=    Create Dictionary    productId=${product_id}    quantity=${quantity}
    ${result}=    Evaluate    $CART_COLLECTION.update_one({"id": ${cart_id}}, {"$push": {"products": $new_product}})
    RETURN    ${result}

Retirer Produit Du Panier
    [Arguments]    ${cart_id}    ${product_id}
    [Documentation]    Retirer un produit d'un panier
    ${result}=    Evaluate    $CART_COLLECTION.update_one({"id": ${cart_id}}, {"$pull": {"products": {"productId": ${product_id}}}})
    RETURN    ${result}

Compter Produits Dans Panier
    [Arguments]    ${cart_id}
    [Documentation]    Compter le nombre de produits différents dans un panier
    ${cart}=    Lire Panier    ${cart_id}
    ${count}=    Run Keyword If    $cart is not None    Get Length    ${cart['products']}
    ...    ELSE    Set Variable    0
    RETURN    ${count}