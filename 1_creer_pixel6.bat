@echo off
REM Cree le telephone virtuel Pixel 6 - API 36.0 (Baklava, Android 16, Google APIs)
setlocal
set SDK=%LOCALAPPDATA%\Android\Sdk
if not exist "%SDK%" set SDK=%ANDROID_HOME%
set CMD=%SDK%\cmdline-tools\latest\bin
if not exist "%CMD%\avdmanager.bat" (
  echo.
  echo ERREUR : outils en ligne de commande Android introuvables.
  echo Dans Android Studio : Settings ^> Languages ^& Frameworks ^> Android SDK ^> onglet SDK Tools
  echo coche "Android SDK Command-line Tools (latest)" puis Apply.
  pause & exit /b 1
)
set IMG=system-images;android-36;google_apis;x86_64
echo Installation de l'image systeme (une seule fois, quelques minutes)...
call "%CMD%\sdkmanager.bat" "%IMG%" "emulator" "platform-tools"
echo Creation du Pixel 6...
echo no | call "%CMD%\avdmanager.bat" create avd -n Pixel_6_API_36 -k "%IMG%" -d pixel_6 --force
echo.
echo Termine. Le telephone "Pixel_6_API_36" apparait maintenant dans Device Manager.
pause
