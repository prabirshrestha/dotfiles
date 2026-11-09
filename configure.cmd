@echo off
call "%~dp0bin-windows\_sh.cmd" "%~dp0configure" %*
exit /b %ERRORLEVEL%
