@echo off
SET vim_path = %USERPROFILE%\apps\vim\vim73\gvim.exe
>  edit_with_vim.reg ECHO REGEDIT4
>> edit_with_vim.reg ECHO [HKEY_CLASSES_ROOT\*\shell\vim]
>> edit_with_vim.reg ECHO @="Edit with &Vim"
>> edit_with_vim.reg ECHO [HKEY_CLASSES_ROOT\*\shell\vim\command]
SET v_test=%USERPROFILE%\apps\vim\vim73\gvim.exe
Set v_replacement=\\
SET v_result=%v_test:\=\\%
>> edit_with_vim.reg ECHO @="%v_result% \"%%1\""