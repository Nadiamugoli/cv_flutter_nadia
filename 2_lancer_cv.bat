@echo off
REM Allume le Pixel 6 puis lance le CV dessus
setlocal
set SDK=%LOCALAPPDATA%\Android\Sdk
if not exist "%SDK%" set SDK=%ANDROID_HOME%
cd /d "%~dp0"
if not exist android (
  echo Creation des fichiers Android...
  call flutter create --platforms=android .
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0patch_android.ps1"
call flutter pub get
echo Demarrage du Pixel 6 (attends que l'ecran d'accueil Android apparaisse)...
start "" "%SDK%\emulator\emulator.exe" -avd Pixel_6_API_36
echo Attente du telephone...
"%SDK%\platform-tools\adb.exe" wait-for-device
:boot
for /f %%i in ('"%SDK%\platform-tools\adb.exe" shell getprop sys.boot_completed') do set B=%%i
if not "%B%"=="1" (timeout /t 3 >nul & goto boot)
call flutter run -d emulator-5554
pause
