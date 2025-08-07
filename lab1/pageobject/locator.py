
PRODUCTS_COLLECTION = "products"

REQUIRED_FIELDS = ["id", "title", "price", "category"]


OPTIONAL_FIELDS = ["description", "image", "rating"]


FIELD_TYPES = {
    "id": "number",
    "title": "string", 
    "price": "number",
    "description": "string",
    "category": "string",
    "image": "string",
    "rating": "object"
}


VALIDATION_RULES = {
    "title": {"min_length": 1, "max_length": 200},
    "price": {"min_value": 0, "max_value": 10000},
    "category": ["electronics", "jewelery", "men's clothing", "women's clothing"]
}