# NeoBank — Flutter Banking App

Application bancaire complète construite avec Flutter et Firebase.

## Fonctionnalités

- Authentification (inscription / connexion / déconnexion)
- Dashboard avec carte bancaire interactive
- Solde en temps réel via Firestore
- Envoi d'argent
- Historique des transactions avec filtres
- Reçus de paiement numériques
- Génération de QR code pour recevoir des paiements
- Page compte avec photo de profil
- Paramètres de sécurité
- Changement de mot de passe (Firebase Auth)
- PIN à 4 chiffres avec clavier personnalisé

## Stack

- Flutter 3.x / Dart 3.x
- Firebase Auth
- Cloud Firestore
- Google Fonts (Poppins)
- QR Flutter

## Démarrage

1. Crée un projet Firebase sur https://console.firebase.google.com
2. Active Authentication (Email/Password) et Firestore
3. Télécharge `google-services.json` (Android) et `GoogleService-Info.plist` (iOS)
4. Place-les dans les bons dossiers
5. `flutter pub get && flutter run`
