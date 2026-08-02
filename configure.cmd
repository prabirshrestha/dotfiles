@echo off
busybox.exe sh "%~dp0configure"
exit /b %ERRORLEVEL%
