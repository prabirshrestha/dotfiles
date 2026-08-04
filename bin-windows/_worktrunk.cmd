@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "wt_cd_file=%TEMP%\worktrunk-cd-%RANDOM%-%RANDOM%.tmp"
set "wt_exec_file=%TEMP%\worktrunk-exec-%RANDOM%-%RANDOM%.tmp"
type nul > "%wt_cd_file%"
type nul > "%wt_exec_file%"

set "WORKTRUNK_DIRECTIVE_CD_FILE=%wt_cd_file%"
set "WORKTRUNK_DIRECTIVE_EXEC_FILE=%wt_exec_file%"
set "WORKTRUNK_SHELL="
rem Use Worktrunk's conflict-free name; wt.exe is Windows Terminal by default.
git-wt %*
set "result=%errorlevel%"

set "wt_target="
for /f "usebackq delims=" %%D in ("%wt_cd_file%") do set "wt_target=%%D"
if not defined wt_target goto run_exec
cd /d "%wt_target%"
if not errorlevel 1 goto run_exec
if "%result%"=="0" set "result=%errorlevel%"

:run_exec
for %%F in ("%wt_exec_file%") do set "wt_exec_size=%%~zF"
if "%wt_exec_size%"=="0" goto cleanup
busybox.exe sh "%wt_exec_file%"
if not errorlevel 1 goto cleanup
if "%result%"=="0" set "result=%errorlevel%"

:cleanup
del /q "%wt_cd_file%" "%wt_exec_file%" >nul 2>&1
if defined wt_target goto finish_with_cd
endlocal & exit /b %result%

:finish_with_cd
for /f "tokens=1,* delims=|" %%A in ("%result%|%wt_target%") do endlocal & cd /d "%%B" & exit /b %%A
