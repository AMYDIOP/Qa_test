
# Collections MongoDB
PRODUCTS_COLLECTION = "products"

# Champs obligatoires pour Products
REQUIRED_FIELDS = ["id", "title", "price", "category"]

# Champs optionnels pour Products  
OPTIONAL_FIELDS = ["description", "image", "rating"]

# Types de données attendus
FIELD_TYPES = {
    "id": "number",
    "title": "string", 
    "price": "number",
    "description": "string",
    "category": "string",
    "image": "string",
    "rating": "object"
}

# Contraintes de validation
VALIDATION_RULES = {
    "title": {"min_length": 1, "max_length": 200},
    "price": {"min_value": 0, "max_value": 10000},
    "category": ["electronics", "jewelery", "men's clothing", "women's clothing"]
}