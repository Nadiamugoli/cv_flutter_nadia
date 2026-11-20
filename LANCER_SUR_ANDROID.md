# Lancer le CV dans l'émulateur Android Studio

## Méthode rapide : Pixel 6, API 36.0 (Baklava, Android 16, Google APIs)
1. Double-clique sur `1_creer_pixel6.bat` (une seule fois). Il crée le téléphone
   "Pixel_6_API_36". Pour retirer l'ancien "Medium Phone" :
   Android Studio > Device Manager > menu ⋮ du Medium Phone > Delete.
2. Double-clique sur `2_lancer_cv.bat`. Il allume le Pixel 6 puis lance le CV dessus.

La méthode détaillée ci-dessous fait la même chose à la main.

## 1. Créer les fichiers Android (une seule fois)
Ton projet n'a pas de dossier `android/`. Sans lui, Flutter ne peut pas
lancer l'application sur un téléphone Android.

Dans le terminal, à la racine du projet :

    flutter create --platforms=android .
    flutter pub get

(Le point à la fin est important. Tes fichiers lib/main.dart, pubspec.yaml
et assets/ ne sont pas supprimés.)

## 2. Démarrer un téléphone virtuel
Android Studio > Device Manager > choisis un appareil (ex. Pixel 7) > bouton ▶.
Attends que le téléphone soit complètement allumé.

## 3. Vérifier que Flutter voit le téléphone
    flutter devices

Tu dois voir une ligne "sdk gphone ... (mobile) • emulator-5554 • android".

## 4. Lancer
    flutter run -d emulator-5554

(ou simplement `flutter run` s'il n'y a qu'un appareil.)

## Dans Android Studio
Ouvre le dossier du projet, choisis l'émulateur dans la liste en haut,
puis clique sur ▶ (Run) avec `lib/main.dart` sélectionné.

## Connexion
Identifiant : nadia
Mot de passe : 1234
