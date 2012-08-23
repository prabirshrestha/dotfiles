@echo off
PUSHD "%~dp0"
rake install[mklink]
POPD
pause