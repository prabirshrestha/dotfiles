@echo off
setlocal
for /f "delims=" %%d in ('tv -s "fd --type d"') do (
    cd /d "%%d"
    endlocal
    goto :eof
)
endlocal
