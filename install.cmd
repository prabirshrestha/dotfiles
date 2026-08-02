@echo off
busybox.exe sh "%~dp0install" busybox.exe
exit /b %ERRORLEVEL%
