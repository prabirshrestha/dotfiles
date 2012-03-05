@echo off
PUSHD "%~dp0"
"%USERPROFILE%\apps\ruby-1.9.3-p125-i386-mingw32\bin\rake.bat" install[mklink]
POPD
pause