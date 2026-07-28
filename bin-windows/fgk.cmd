@echo off
setlocal EnableExtensions DisableDelayedExpansion
for /f "delims=" %%B in ('git branch -a --format^="%%(refname:short)" ^| tv') do (
    start "" gitk "%%B"
    exit /b
)
exit /b 1
