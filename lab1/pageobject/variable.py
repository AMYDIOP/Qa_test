# Connexion MongoDB Atlas
MONGODB_CONNECTION_STRING = "mongodb+srv://cabsene:passer123@fakestorecluster.qdewjiz.mongodb.net/"
DATABASE_NAME = "fakeStoreDB"
COLLECTION_NAME = "products"


VALID_PRODUCT_DATA = {
    "id": 999,
    "title": "Test Product Robot Framework",
    "price": 29.99,
    "description": "Un produit de test créé par Robot Framework",
    "category": "electronics",
    "image": "https://fakestoreapi.com/img/test.jpg",
    "rating": {
        "rate": 4.5,
        "count": 10
    }
}


UPDATE_PRODUCT_DATA = {
    "title": "Test Product UPDATED",
    "price": 39.99,
    "description": "Produit mis à jour par Robot Framework"
}


INVALID_PRODUCT_DATA = {
    "title": "",
    "price": "invalid_price",
    "category": None
}


VALID_PRODUCT_ID = 999
INVALID_PRODUCT_ID = 99999
NON_NUMERIC_ID = "abc123"


NEGATIVE_PRICE = -10.50
EMPTY_STRING = ""
NULL_VALUE = None