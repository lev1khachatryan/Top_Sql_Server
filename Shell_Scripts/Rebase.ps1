#before executing we have to add git.exe path 
# to windows "PATH" envirement variables list
# My local path for git.exe is D:\Programs\Git\cmd

#backup bath
$path = "F:\CI\"
# Set SQL Server instance name
$sqlName= "sis2s013"
# Set SQL Server instance login
$username = "jenkins"
# Set SQL Server instance pass
$pass = "jenkins" 
# Set the databse name which you want to backup without postfix
# , for example RWA_IECMS-bugfix_RWAIECMS-2786- instead of RWA_IECMS-bugfix_RWAIECMS-2786-DATA
$dbname = "_ArtashTest_RWA_IECMS-bugfix_RWAIECMS-2768-1-"
#scripts path
$ScriptPath1 = "rwa-iecms-db\src\main\scripts"

$date = Get-Date -format "yyyyMMddhhmm"
# path of the porject
$projectPath = "D:\Projects\rwa-iecms\"
# full path  of KB, DATA, DE folder
$ScriptPath = $projectPath + $ScriptPath1
# path of the build.properties file
$buildNumberPath = $projectPath + "src\main\resources\build.properties"
$buildNumber = Get-Content -Path $buildNumberPath
$buildNumber =  $buildNumber.Replace("build.version=", "")
[Sctirng] $buildNumber = 5

#<#
# Checkout rebase from origin dev
try {
$ErrorActionPreference = "Stop"
cd $projectPath 
$branch = git rev-parse --abbrev-ref HEAD
}
catch {
"Error:" +$_.Exception.Message
}
##>
# Checkout to the dev 
try {
$ErrorActionPreference = "Stop"
cd $projectPath
git checkout dev 
}
catch {
"Error:" +$_.Exception.Message
}

# rebase from origin dev
try {
$ErrorActionPreference = "Stop"
cd $projectPath 
git pull --rebase
}
catch {
"Error:" +$_.Exception.Message
}

try {
foreach ($p in Get-ChildItem -path "$ScriptPath" | Where-Object {$_.Name -ne "IDM-Util"}| sort-object){

# try to backup current Database 
try {

$CurrentBuildNumber = $p.Name + ".[$($buildNumber)]"
Write-Host "...Current build number is "$CurrentBuildNumber
$CurrentDBname =  $dbname + $p.Name.Replace("DEV-RWA_IECMS-", "")
Write-Host "...Current DBName is "$CurrentDBname 
# Set the backup file path
$backupPath= "$($path)$($CurrentDBname)_$($date).bak"
$backupFile = "\\$($sqlName)\$path$($CurrentDBname)_$($date).bak"
$backupFile = $backupFile.Replace(":", "$")
#Load the required assemlies SMO and SmoExtended.
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null

 
# Connect SQL Server.

$mySrvConn = new-object Microsoft.SqlServer.Management.Common.ServerConnection
$mySrvConn.ServerInstance=$sqlName
$mySrvConn.LoginSecure = $false
$mySrvConn.Login = $username
$mySrvConn.Password = $pass
$sqlServer = New-Object Microsoft.SqlServer.Management.Smo.Server($mySrvConn)
 
#Create SMO Backup object instance with the Microsoft.SqlServer.Management.Smo.Backup
$dbBackup = new-object ("Microsoft.SqlServer.Management.Smo.Backup")
 
$dbBackup.Database = $CurrentDBname
 
#Add the backup file to the Devices
$dbBackup.Devices.AddDevice($backupPath, "File")
 
#Set the Action as Database to generate a FULL backup 
$dbBackup.Action="Database"
 
#Call the SqlBackup method to complete backup 
$dbBackup.SqlBackup($sqlServer)
 
Write-Host "...Backup of the database"$CurrentDBname" completed..."
$sqlServer.ConnectionContext.Disconnect()
}
catch {
Write-Host $CurrentDBname "...Database backup failed"
"Error:" +$_.Exception.Message
throw "Error during database backup"
}

# try to restore current Database 

$CurrentDBname =  $date + "_" + $dbname + $p.Name.Replace("DEV-RWA_IECMS-", "")
Write-Host "...restoring database"$CurrentDBname
try {
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server($mySrvConn)

# Identify the backup file to use, and the name of the database copy to create
$bckfile = $backupPath
$NewDBname = "$($CurrentDBname)"
 
# Build the physical file names for the database copy
 
# Use the backup file name to create the backup device
$bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')
 
# Create the new restore object, set the database name and add the backup device
$rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
$rs.Database = $NewDBname
$rs.Devices.Add($bdi)
 
# Get the file list info from the backup file
$fl = $rs.ReadFileList($srv)
foreach ($fil in $fl) {
    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
    $rsfile.LogicalFileName = $fil.LogicalName
    if ($fil.Type -eq 'D' -and $fil.FileGroupName -ne 'PRIMARY'){
         $rsfile.PhysicalFileName = $path + $NewDBname + "_" + $fil.LogicalName + ".mdf"
        }
    elseif($fil.Type -eq 'L'){
         $rsfile.PhysicalFileName = $path + $NewDBname + "_" + $fil.LogicalName + ".ldf"       
    }
    else {
         $rsfile.PhysicalFileName = $path + $NewDBname + "_" + $fil.LogicalName + ".ndf"     
    }
        $rs.RelocateFiles.Add($rsfile)   
    }
 
# Restore the database
$rs.SqlRestore($srv)
Write-Host "...Restoring Database "$NewDBname" compelted succesfully"
$srv.ConnectionContext.Disconnect()
}

catch{
Write-Host $CurrentDBname "...Database restore failed"
"Error:" +$_.Exception.Message
throw "Error during database restore"
}
#remove backup files
finally{
Write-Host "...Remove Backup files"
Remove-Item $backupFile
}

Write-Host "...Try to execute scripts on" $CurrentDBname
foreach ($f in Get-ChildItem -path "$($ScriptPath)\$($p.Name)\migrate\" -Filter "*.sql" | Where-Object {$_.name -gt $CurrentBuildNumber}| sort-object){
Write-Host "...Executing file " $f.Name "on " $CurrentDBname "Database"
try {  
invoke-sqlcmd -InputFile $f.fullname -serverinstance $sqlName -database $CurrentDBname -ErrorAction Stop
}
catch {
    "Error:" +$_.Exception.Message
    foreach ($j in Get-ChildItem -path "$ScriptPath" | Where-Object {$_.Name -ne "IDM-Util" -and $_.Name -le $p.Name}| sort-object){       
        $dropingDBName = $date + "_" + $dbname + $j.Name.Replace("DEV-RWA_IECMS-", "")
        Write-Host "droping database " $dropingDBName
        $sqlQuery = "EXEC [ARTASH].[dbo].[dropReplication] '" + $dropingDBName + "' USE [master] Alter Database [" + $dropingDBName + "] SET SINGLE_USER WITH ROLLBACK IMMEDIATE DROP DATABASE [" + $dropingDBName + "]"
        ExecuteSqlQuery $sqlName $dropingDBName $sqlQuery
        Write-Host "database" $dropingDBName "has been droped successfully"         
    }
    throw "Error during execution of the script"
}
}
}
foreach ($p in Get-ChildItem -path "$ScriptPath" | Where-Object {$_.Name -ne "IDM-Util"}| sort-object){
    $CurrentDBname =  $dbname + $p.Name.Replace("DEV-RWA_IECMS-", "")
    Write-Host "Executing migration scripts on " $CurrentDBname
    foreach ($f in Get-ChildItem -path "$($ScriptPath)\$($p.Name)\migrate\" -Filter "*.sql" | Where-Object {$_.name -gt $CurrentBuildNumber}| sort-object){
        try{            
            Write-Host "...Executing file " $f.Name "on " $CurrentDBname "Database" 
            invoke-sqlcmd -InputFile $f.fullname -serverinstance $sqlName -database $CurrentDBname -ErrorAction Stop            
        }
        catch{
            Write-Host "...Executing file " $f.Name "on " $CurrentDBname "Database faile" 
            throw "Error during execution of the script"
        }       
    }
    $dropingDBName = $date + "_" + $CurrentDBname
    $sqlQuery = "EXEC [ARTASH].[dbo].[dropReplication] '" + $dropingDBName + "' USE [master] Alter Database [" + $dropingDBName + "] SET SINGLE_USER WITH ROLLBACK IMMEDIATE DROP DATABASE [" + $dropingDBName + "]"
    ExecuteSqlQuery $sqlName $dropingDBName $sqlQuery
    Write-Host "database" $dropingDBName "has been droped successfully"
}
}
catch {
    throw "Error during execution of the script"
}
finally{
try {
$ErrorActionPreference = "Stop"
cd $projectPath 
git checkout $branch
}
catch {
    "Error:" +$_.Exception.Message
}
}
function ExecuteSqlQuery ($server, $database, $SqlQuery){
    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;"
    $Connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $SQLQuery
    $Command.ExecuteReader()    
    $Connection.Close()
}