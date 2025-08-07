# Données de test et constantes

URL = "https://automationplayground.com/crm/"
BROWSER = "Chrome"
LANG = "en"

# Identifiants valides (à adapter selon ton environnement)
VALID_USERNAME_AUTOMATION = "testuser@example.com"
VALID_PASSWORD_AUTOMATION = "password123"

# Messages affichés (multilingue)
VALID_MSG_HOME_en = "Customers Are Priority One!"
VALID_MSG_HOME_fr = "Les clients sont la priorité numéro un !"

INVALID_MSG_LOGIN_en = "Login"
INVALID_MSG_LOGIN_fr = "Se connecter"

VALID_MSG_POST_LOGIN_en = "Our Happy Customers"
VALID_MSG_POST_LOGIN_fr = "Nos clients satisfaits"

VALID_MSG_POST_LOGOUT_en = "Signed Out"
VALID_MSG_POST_LOGOUT_fr = "Déconnecté"
# Sélecteurs utilisés pour vérifier du texte
PERSISTED_EMAIL = "id=email-id"
HOME_PAGE_TEXT = "xpath=//h2[contains(text(),'Customers Are Priority One')]"
LOGIN_PAGE_TEXT = "xpath=//h2[contains(text(),'Login')]"
LOGOUT_SUCCESS_TEXT = "xpath=//h2[contains(text(),'Signed Out')]"
# 🧩 Table des contacts visible après login
CONTACTS_TABLE = "xpath=//table[@id='customers']"

# ✅ Case à cocher "Remember me"
REMEMBER_ME = "id=remember"
