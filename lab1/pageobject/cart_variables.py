# Variables pour les tests Carts - Fake Store API

# Collections MongoDB
CARTS_COLLECTION = "carts"

# Champs obligatoires pour Carts
CART_REQUIRED_FIELDS = ["id", "userId", "date", "products"]

# Champs optionnels pour Carts  
CART_OPTIONAL_FIELDS = []

# Types de données attendus pour Carts
CART_FIELD_TYPES = {
    "id": "number",
    "userId": "number", 
    "date": "string",
    "products": "array"
}

# Contraintes de validation pour Carts
CART_VALIDATION_RULES = {
    "userId": {"min_value": 1, "max_value": 10000},
    "date": {"pattern": r"^\d{4}-\d{2}-\d{2}$"},
    "products": {"min_items": 1, "max_items": 50}
}

# Données de test valides pour Carts
VALID_CART_DATA = {
    "id": 9999,
    "userId": 999,
    "date": "2024-01-01",
    "products": [
        {
            "productId": 1,
            "quantity": 2
        },
        {
            "productId": 5,
            "quantity": 1
        }
    ]
}

# Données de mise à jour pour Carts
UPDATE_CART_DATA = {
    "date": "2024-01-15",
    "products": [
        {
            "productId": 1,
            "quantity": 3
        },
        {
            "productId": 10,
            "quantity": 1
        },
        {
            "productId": 15,
            "quantity": 2
        }
    ]
}

# Données invalides pour Carts
INVALID_CART_DATA = {
    "userId": -1,  # ID utilisateur invalide
    "date": "invalid-date",
    "products": []  # Liste vide
}

# IDs de test pour Carts
VALID_CART_ID = 9999
INVALID_CART_ID = 999999
NON_NUMERIC_CART_ID = "abc123"

# Valeurs de test spécifiques
INVALID_USER_ID_FOR_CART = -1
INVALID_DATE_FORMAT = "2024/01/01"
EMPTY_PRODUCTS_LIST = []
INVALID_PRODUCT_ID = -1
INVALID_QUANTITY = -1

# Produit de test valide pour les paniers
VALID_PRODUCT_IN_CART = {
    "productId": 1,
    "quantity": 1
}

INVALID_PRODUCT_IN_CART = {
    "productId": -1,
    "quantity": -1
}