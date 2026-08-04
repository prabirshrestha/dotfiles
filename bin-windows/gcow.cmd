@echo off
if "%~1"=="" goto usage
if /i not "%~1"=="-b" goto switch
if "%~2"=="" goto usage
for %%I in ("%~$PATH:0") do set "worktrunk_bin=%%~dpI"
call "%worktrunk_bin%_worktrunk.cmd" switch %2 %3 %4 %5 %6 %7 %8 %9 --create
exit /b %errorlevel%

:switch
for %%I in ("%~$PATH:0") do set "worktrunk_bin=%%~dpI"
call "%worktrunk_bin%_worktrunk.cmd" switch %*
exit /b %errorlevel%

:usage
echo Usage: gcow [-b] ^<branch^>
exit /b 1
