@echo off
setlocal EnableDelayedExpansion
set /p input="Do you want to download FullDBs?(y/n)  "
if %input% == y (
    set /p NewFullDBFolder="Please enter a new FullDB folder name  "
    set /p ServerName="Please enter a ServerName name  "
    Powershell.exe -executionpolicy remotesigned -File   C:\Users\levon.khachatryan\Desktop\Gorillaz_Levon\StartService_2.ps1        !NewFullDBFolder!   !NewFullDBFolder!  !ServerName!   "%input%"
)
if %input% == n (
    set /p FullDBFolder="Please enter a fullDB folder name  "
    set /p DiffDBFolder="Please enter a DifferentialDB folder name  "
    set /p ServerName="Please enter a ServerName name  "
    Powershell.exe -executionpolicy remotesigned -File   C:\Users\levon.khachatryan\Desktop\Gorillaz_Levon\StartService_2.ps1        !FullDBFolder!      !DiffDBFolder!     !ServerName!   "%input%"
)
pause
