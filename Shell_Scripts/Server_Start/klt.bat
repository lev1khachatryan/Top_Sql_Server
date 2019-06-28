@echo off
setlocal EnableDelayedExpansion
set /p input="Do you want to create folder?(y/n)"
if %input% == y (
    set /p NewFolderName="Please enter a new folder name"
    Powershell.exe -executionpolicy remotesigned -File   C:\Users\levon.khachatryan\Desktop\Gorillaz_Levon\testing.ps1 !NewFolderName! "%input%"
) 
else if %input% == n (
)
pause
