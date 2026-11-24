<<<<<<< HEAD
## 🎥 Vidéo de démonstration

[▶ Regarder la vidéo du projet CV Flutter](./vidéo.mp4)

<img width="495" height="936" alt="Accuiel" src="https://github.com/user-attachments/assets/016dde2d-3fbb-4b7b-92ec-ce8ebd6afc5a" /><img width="495" height="940" alt="Presentation de la famille" src="https://github.com/user-attachments/assets/a1345991-3b3f-4bbb-9815-347c0b4ea61b" />
<img width="494" height="940" alt="Mon CV" src="https://github.com/user-attachments/assets/e0b03f70-d668-4036-90a9-c479ad7a7102" />
<img width="495" height="935" alt="Contacts" src="https://github.com/user-attachments/assets/fdbbd2c4-2cc6-4b60-8dfe-016088f5c94c" />

<<<<<<< HEAD
=======
>>>>>>> 0be8a02 (Finalisation du projet CV Flutter : passage de CV1 à CV2, tests API REST et maillage des membres de la famille)
# CV Flutter Nadia

Application Flutter de présentation personnelle (TP1) connectée à une API REST PHP/MySQL (TP2) :
- page de connexion avec **authentification réelle** (`POST /accounts/login`, e-mail + mot de passe)
- CV
- famille **dynamique** : liste, ajout, modification et suppression via l'API (`/famille-membres`), données stockées dans MySQL
- contacts cliquables (téléphone, e-mail, GitHub)
- navigation par barre inférieure, tiroir latéral et balayage horizontal

## TP2 : API REST

Flux : Flutter → requête HTTP → API PHP (Apache/XAMPP) → MySQL.

1. Installer l'API de l'enseignant (https://github.com/espoirbaraka/api-test) dans `C:\xampp\htdocs\api-test`.
2. Démarrer Apache et MySQL dans XAMPP, créer la base `api` et importer `api.sql` dans phpMyAdmin.
3. Vérifier `.env` (`DB_HOST=127.0.0.1`, `DB_PORT=3306`, `DB_DATABASE=api`, `DB_USERNAME=root`, mot de passe vide).
4. Tester http://localhost/api-test/public/famille-membres → `{"success":true,"data":[]}`.
5. Créer un compte (ou, plus simplement, via le lien « Créer un compte » de l'écran de connexion de l'application) :
   ```bash
   curl.exe -X POST "http://localhost/api-test/public/accounts/register" -H "Content-Type: application/json" -d "{\"email\":\"votre_email@example.com\",\"password\":\"votre_mot_de_passe\"}"
   ```
6. `flutter pub get`, puis `flutter run` (émulateur Android : l'app utilise automatiquement `10.0.2.2`).

Le code réseau est centralisé dans `lib/services/api_service.dart`.
Note : l'API ne protège pas les routes CRUD par jeton/session ; seule la vérification des identifiants est réelle.

## Démonstration vidéo

[Regarder la démonstration de l'application Flutter de Nadia](./video.mp4)

> La vidéo `video.mp4` doit se trouver dans le même dossier que ce README (la racine du projet `cv_flutter_nadia`), puis être envoyée sur GitHub avec `git push`.

## Dépôt GitHub

Projet Flutter de Nadia : https://github.com/NadiaMugoli/cv_flutter_nadia
(à corriger si le dépôt porte un autre nom). Ne pas confondre avec le dépôt de l'API de l'enseignant : https://github.com/espoirbaraka/api-test

```bash
git add .
git commit -m "TP2: integration API et gestion dynamique de la famille"
git push
```

## Lancer sur un téléphone Android physique

1. Active le débogage USB sur le téléphone et branche-le au PC (`flutter devices` doit le lister).
2. Connecte le téléphone et le PC au **même Wi-Fi** (ou partage de connexion).
3. Trouve l'IP du PC : `ipconfig` → « Adresse IPv4 » (ex. `192.168.1.20`).
4. Vérifie dans le navigateur du téléphone : `http://192.168.1.20/api-test/public/famille-membres` doit afficher du JSON. Sinon, autorise Apache (port 80) dans le pare-feu Windows.
5. Lance : `flutter run --dart-define=API_HOST=192.168.1.20`

## Installation dans ton projet Flutter

1. Ouvre le dossier de ton projet `cv_flutter_nadia` dans VS Code.
2. Remplace le contenu de `lib/main.dart` par le fichier `lib/main.dart` fourni ici.
3. Remplace le contenu de `pubspec.yaml` par celui fourni ici.
4. Dans le terminal, à la racine du projet, exécute :
   ```bash
   flutter pub get
   ```
5. Lance l'application :
   ```bash
   flutter run -d chrome
   ```
   Ou sur un émulateur Android (voir `LANCER_SUR_ANDROID.md`) :
   ```bash
   flutter create --platforms=android .
   flutter run
   ```

## Ajouter les photos

Place tes photos dans `assets/images/` avec exactement ces noms :

- `nadia.jpg` — ta photo
- `jeanson.jpg` — ton père, Jeanson Abanabo
- `anuarite.jpg` — ta mère, Anouarite Bengehia Abamwezi
- `lydia.jpg` — Lydia
- `claudia.jpg` — Claudia
- `johny.jpg` — Johny
- `jonathan.jpg` — Jonathan
- `joachim.jpg` — Joachim
- `dorcas.jpg` — Dorcas

Si une photo n'est pas encore présente, l'application affiche des initiales à sa place. Tu peux donc commencer à tester l'application avant d'ajouter les photos.

## Informations à vérifier avant la remise

- Confirmer que l'identifiant GitHub est bien `NadiaMugoli` et que l'adresse `https://github.com/NadiaMugoli` est la bonne.
- Vérifier l'orthographe officielle de tous les prénoms et noms de famille.
- Préciser les niveaux réels en anglais, espagnol et swahili si le professeur le demande.
- Confirmer l'adresse e-mail avant de publier le projet.

## Important

Les identifiants ne sont plus codés en dur : ils sont vérifiés par l'API. L'API ne renvoie ni jeton ni session, et les routes de la famille restent accessibles sans authentification côté serveur.
