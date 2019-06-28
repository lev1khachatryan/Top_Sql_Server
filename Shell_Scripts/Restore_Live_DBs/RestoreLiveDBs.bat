cls 
@echo off
setlocal EnableDelayedExpansion
:CONFIRM 
set /p input1="Do you want to download Full DBs?(y/n)  "
if %input1% == y goto L1
if %input1% == Y goto L1
if %input1% == n goto L2
if %input1% == N goto L2
echo Invalid choice. 
set /p 
goto CONFIRM 
:L1
    set /p NewFullDBFolder="Please enter a new FullDB folder name(yyyymmdd_Full)  "
    set /p ServerName="Please enter a Server name  "
    Powershell.exe -executionpolicy remotesigned -File   %~dp0\StartService.ps1        !NewFullDBFolder!   !NewFullDBFolder!  !ServerName!   "%input1%"
    goto END
:L2
set /p input2="Do you want to download Differential DBs?(y/n)  "
if %input2% == y goto L3
if %input2% == Y goto L3
if %input2% == n goto L3
if %input2% == N goto L3
echo Invalid choice. 
set /p 
goto L2
:L3
    set /p FullDBFolder="Please enter a fullDB folder name(yyyymmdd_Full)  "
    set /p DiffDBFolder="Please enter a DifferentialDB folder name(yyyymmdd_Diff)  "
    set /p ServerName="Please enter a Server name  "
    Powershell.exe -executionpolicy remotesigned -File   %~dp0\StartService.ps1        !FullDBFolder!      !DiffDBFolder!     !ServerName!   "%input1%"  "%input2%"
:END
pause
