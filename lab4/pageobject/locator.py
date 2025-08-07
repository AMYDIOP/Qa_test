# locator.py

# Champs de login
USERNAME = 'android=new UiSelector().className("android.widget.EditText").instance(0)'
PASSWORD = 'android=new UiSelector().className("android.widget.EditText").instance(1)'
LOGIN = 'android=new UiSelector().description("Se connecter")'

PAGE_TITLE = 'android=new UiSelector().description("Connexion")'
PAGE_FORM = 'android=new UiSelector().className("android.view.View").instance(3)'
AJOUT_BUTTON  = 'android=new UiSelector().description("Ajouter")'
PRODUIT_ITEM  = 'android=new UiSelector().textContains("Rain Jacket Women")'
# Champs formulaire produit (exemples)
PRODUIT_TITLE     = 'android=new UiSelector().className("android.widget.EditText").instance(0)'
PRODUIT_PRICE     = 'android=new UiSelector().className("android.widget.EditText").instance(1)'
PRODUIT_DESC      = 'android=new UiSelector().className("android.widget.EditText").instance(2)'
PRODUIT_CATEGORY  = 'android=new UiSelector().className("android.widget.EditText").instance(3)'

PRODUIT_IMAGE     = 'android=new UiSelector().className("android.widget.EditText").instance(4)'

BTN_AJOUT_PRODUIT = 'android=new UiSelector().description("Ajouter")'
PRODUIT_ITEM = 'android=new UiSelector().textContains("Fjallraven")'
