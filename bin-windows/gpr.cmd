@echo off
setlocal EnableExtensions DisableDelayedExpansion
set "use_worktree=0"
set "pr="

:parse_args
if "%~1"=="" goto args_parsed
if /i "%~1"=="-w" (
    set "use_worktree=1"
) else if not defined pr (
    set "pr=%~1"
)
shift
goto parse_args

:args_parsed
if defined pr goto pr_selected
for /f "tokens=1" %%P in ('gh pr list ^| tv') do set "pr=%%P"
if not defined pr exit /b 1

:pr_selected
if "%use_worktree%"=="0" (
    gh pr checkout "%pr%"
    exit /b
)

for /f "delims=" %%R in ('git rev-parse --show-toplevel 2^>nul') do set "repo_root=%%R"
if not defined repo_root exit /b 1
for %%R in ("%repo_root%") do set "worktree_path=%%~dpR%%~nxR-pr%pr%"

if exist "%worktree_path%\" goto existing_worktree
git worktree add "%worktree_path%" -b "pr%pr%"
if errorlevel 1 exit /b %errorlevel%
cd /d "%worktree_path%"
if errorlevel 1 exit /b %errorlevel%
gh pr checkout "%pr%"
set "result=%errorlevel%"
endlocal & cd /d "%worktree_path%" & exit /b %result%

:existing_worktree
endlocal & cd /d "%worktree_path%"
