@echo off
git cherry-pick %*
exit /b %errorlevel%
