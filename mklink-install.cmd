@echo off
PUSHD "%~dp0"
mklink /d "%USERPROFILE%/apps" "C:/apps/"
rem mklink /d "%USERPROFILE%/.VirtualBox" "d:/Prabir/.VirtualBox"
rem mklink /d "%USERPROFILE%/VirtualBox VMs" "d:/Prabir/VirtualBox VMs"
POPD
pause