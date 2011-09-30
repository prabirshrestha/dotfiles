@echo off
PUSHD "%~dp0"
D:\apps\ruby-1.9.2-p0-i386-mingw32\bin\rake.bat install[mklink]
POPD
pause

