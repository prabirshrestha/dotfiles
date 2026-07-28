@echo off
setlocal EnableExtensions DisableDelayedExpansion
for /f "delims=" %%B in ('git branch -a --format^="%%(refname:short)" ^| tv') do call :checkout "%%B"
exit /b %errorlevel%

:checkout
set "branch=%~1"
if /i "%branch:~0,7%"=="origin/" set "branch=%branch:~7%"
git checkout "%branch%"
exit /b %errorlevel%
