@echo off
git commit -a %*
exit /b %errorlevel%
