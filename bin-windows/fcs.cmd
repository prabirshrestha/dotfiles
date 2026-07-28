@echo off
setlocal EnableExtensions DisableDelayedExpansion
for /f "tokens=1" %%C in ('tv -s "git log --color=always --pretty=oneline --abbrev-commit --reverse" --ansi --no-sort') do (
    echo %%C
    exit /b 0
)
exit /b 1
