LOGIN_LINK = "xpath=/html/body/nav/ul/li/a"
LOGIN_FORM = "xpath=/html/body/section/div/div/div/div/form"
LOGIN_EMAIL = "id=email-id"
LOGIN_PASSWORD = "id=password"
LOGIN_SUBMIT_BUTTON = "id=submit-id"
DASHBOARD_TEXT = "xpath=//h2[contains(text(),'Our Happy Customers')]"
LOGOUT_LINK = "xpath=/html/body/nav/ul/li/a"
CUSTOMERS_MENU_LINK = "xpath=//a[contains(text(),'Customers')]"
CUSTOMERS_TABLE = "id=customers"
NEW_CUSTOMER_BUTTON = "xpath=//a[text()='New Customer']"

# === Champs formulaire ajout client ===
NEW_CUSTOMER_BUTTON = "id=new-customer"  # reste inchangé

CUSTOMER_EMAIL_FIELD = "id=EmailAddress"
CUSTOMER_FIRSTNAME_FIELD = "id=FirstName"
CUSTOMER_LASTNAME_FIELD = "id=LastName"
CUSTOMER_CITY_FIELD = "id=City"
CUSTOMER_STATE_DROPDOWN = "id=StateOrRegion"
CUSTOMER_GENDER_RADIO = "name=gender"
CUSTOMER_PROMOTION_CHECKBOX = "name=promos-name"
CUSTOMER_SUBMIT_BUTTON = "xpath=//button[@type='submit']"
NEW_CUSTOMER_FORM = "xpath=//form[@action='customer-success.html']"
