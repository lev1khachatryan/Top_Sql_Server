cls 
@echo off
setlocal EnableDelayedExpansion
:CONFIRM 
set /p input1="Do you want to delete unused files ?(y/n)  "
if %input1% == y goto START
if %input1% == Y goto START
if %input1% == n goto END
if %input1% == N goto END
echo Invalid choice. 
set /p 
goto CONFIRM 
:START
    Powershell.exe -executionpolicy remotesigned -File   %~dp0\StartService.ps1
:END
pause
