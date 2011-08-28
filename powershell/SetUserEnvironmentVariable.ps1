$userProfile = [Environment]::GetEnvironmentVariable("USERPROFILE")

$apps = "$userProfile\apps"

"$apps\node;" +
"$apps\git;" +
"$apps\kdiff3;" +
"$apps\ruby-1.9.2-p0-i386-mingw32\bin;" +
"$apps\vim\vim73;"
