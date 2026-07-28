@echo off
git fetch
if errorlevel 1 exit /b %errorlevel%
git rebase %*
exit /b %errorlevel%
