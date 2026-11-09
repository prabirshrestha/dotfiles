@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "dotfiles_busybox=%LOCALAPPDATA%\Microsoft\WinGet\Links\busybox.exe"
if exist "%dotfiles_busybox%" goto run

winget.exe install --id frippery.busybox-w32 --exact --source winget --scope user --accept-package-agreements --accept-source-agreements --disable-interactivity --no-upgrade
if errorlevel 1 exit /b %ERRORLEVEL%
if exist "%dotfiles_busybox%" goto run
echo WinGet did not create the user BusyBox command at "%dotfiles_busybox%". 1>&2
exit /b 1

:run
"%dotfiles_busybox%" sh "%~dp0install"
exit /b %ERRORLEVEL%
