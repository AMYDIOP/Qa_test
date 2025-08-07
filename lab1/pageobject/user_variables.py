

USERS_COLLECTION = "users"
USER_REQUIRED_FIELDS = ["id", "email", "username", "password", "name", "address", "phone"]
USER_FIELD_TYPES = {
    "id": "number",
    "email": "string", 
    "username": "string",
    "password": "string",
    "name": "object",
    "address": "object",
    "phone": "string"
}

USER_VALIDATION_RULES = {
    "email": {"pattern": r"^[^\s@]+@[^\s@]+\.[^\s@]+$"},
    "username": {"min_length": 3, "max_length": 50},
    "password": {"min_length": 6, "max_length": 100},
    "phone": {"min_length": 10, "max_length": 15}
}


VALID_USER_DATA = {
    "id": 9999,
    "email": "john.doe.test@gmail.com",
    "username": "johndoetest",
    "password": "m38rmF$",
    "name": {
        "firstname": "John",
        "lastname": "Doe"
    },
    "address": {
        "city": "Kilcoole",
        "street": "7835 new road",
        "number": 3,
        "zipcode": "12926-3874",
        "geolocation": {
            "lat": "-37.3159",
            "long": "81.1496"
        }
    },
    "phone": "1-570-236-7033"
}

UPDATE_USER_DATA = {
    "email": "john.updated.test@gmail.com",
    "phone": "1-570-236-9999",
    "name": {
        "firstname": "John Updated",
        "lastname": "Doe Updated"
    }
}


INVALID_USER_DATA = {
    "email": "invalid-email",
    "username": "",
    "password": "123",
    "phone": "abc"
}


VALID_USER_ID = 9999
INVALID_USER_ID = 999999
NON_NUMERIC_USER_ID = "abc123"


INVALID_EMAIL = "not-an-email"
SHORT_PASSWORD = "123"
EMPTY_USERNAME = ""
INVALID_PHONE = "not-a-phone"