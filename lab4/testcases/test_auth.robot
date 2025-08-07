*** Settings ***
Resource    ../ressources/common.robot
Suite Setup    Ouvrir l'app Looma

*** Test Cases ***
Test Authentification Looma
    Se connecter à Looma

Test Création et Affichage Produit
    Se connecter à Looma
    Ajouter un produit
    Afficher un produit
