@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem Locate the shell bundled with Git for Windows.
for /f "delims=" %%G in ('where git.exe 2^>nul') do (
  if exist "%%~dpG..\bin\sh.exe" (
    set "dotfiles_shell=%%~dpG..\bin\sh.exe"
    goto run
  )
)
echo Git for Windows is required. Install it with: winget install --id Git.Git --exact 1>&2
exit /b 1

:run
"%dotfiles_shell%" %*
exit /b %ERRORLEVEL%
