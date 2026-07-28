@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "result=0"
for /f "delims=" %%B in ('git branch --format^="%%(refname:short)" ^| tv') do call :delete_branch "%%B"
exit /b %result%

:delete_branch
set "branch=%~1"
git branch -d "%branch%" 2>nul
if not errorlevel 1 exit /b 0
set "confirm="
set /p "confirm=Force delete %branch%? [y/N] "
if /i "%confirm%"=="y" (
    git branch -D "%branch%"
    if errorlevel 1 set "result=1"
) else (
    set "result=1"
)
exit /b 0
