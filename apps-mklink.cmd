@echo off
PUSHD "%~dp0"
mklink /d "%USERPROFILE%/apps" "d:/apps/"
POPD
pause

