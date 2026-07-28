@echo off
git checkout main
if not errorlevel 1 exit /b 0
git checkout master %*
exit /b %errorlevel%
