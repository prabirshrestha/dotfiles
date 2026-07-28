@echo off
setlocal EnableExtensions DisableDelayedExpansion
for /f "tokens=1" %%C in ('tv -s "git log --pretty=oneline --abbrev-commit --reverse" --no-sort') do (
    git checkout %%C
    exit /b
)
exit /b 1
