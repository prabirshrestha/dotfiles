@echo off
for /f "delims=" %%B in ('git-wt list --format json 2^>nul ^| powershell.exe -NoProfile -Command "$json = $input ^| Out-String ^| ConvertFrom-Json; if ($json.schema -eq 2) { @($json.items).branch } else { @($json).branch }" ^| tv') do (
    for %%I in ("%~$PATH:0") do call "%%~dpI_worktrunk.cmd" remove "%%B"
    exit /b
)
exit /b 1
