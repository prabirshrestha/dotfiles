@echo off
for %%I in ("%~$PATH:0") do set "worktrunk_bin=%%~dpI"
call "%worktrunk_bin%_worktrunk.cmd" switch main %*
exit /b %errorlevel%
