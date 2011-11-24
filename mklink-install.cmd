@echo off
PUSHD "%~dp0"
mklink /d "%USERPROFILE%/apps" "d:/apps/"
mklink /d "%USERPROFILE%/.VirtualBox" "d:/Prabir/.VirtualBox"
mklink /d "%USERPROFILE%/VirtualBox VMs" "d:/Prabir/VirtualBox VMs"
POPD
pause