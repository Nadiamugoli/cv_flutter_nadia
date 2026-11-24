# Autorise le HTTP (http://10.0.2.2) et Internet dans AndroidManifest.xml (idempotent)
$f = Join-Path $PSScriptRoot 'android\app\src\main\AndroidManifest.xml'
if (-not (Test-Path $f)) { exit 0 }
$x = Get-Content $f -Raw
if ($x -notmatch 'usesCleartextTraffic') {
  $x = $x -replace '<application', '<application android:usesCleartextTraffic="true"'
}
if ($x -notmatch 'android.permission.INTERNET') {
  $x = $x -replace '(<manifest[^>]*>)', "`$1`n    <uses-permission android:name=`"android.permission.INTERNET`"/>"
}
Set-Content $f $x -Encoding UTF8
Write-Host 'AndroidManifest.xml pret pour l API (HTTP + Internet).'
