Add-PSSnapin SqlServerCmdletSnapin100
Add-PSSnapin SqlServerProviderSnapin100

#Path for scripts to be executed
$path = "C:\_Prof\ddxk"
# Set SQL Server instance name
$sqlName= "sis2s082"
# Set SQL Server instance user
$user = "jenkins" 
# Set SQL Server instance pass
$pwd = "jenkins" 
# , for example RWA_IECMS-bugfix_RWAIECMS-2786- instead of RWA_IECMS-bugfix_RWAIECMS-2786-DATA
$dbname = "DEV-RWA_IECMS-KB_Training_20180409_ddxk"
#scripts path

<#try{
Invoke-Sqlcmd -Query "USE [master]

ALTER DATABASE [DEV-RWA_IECMS-DE_Live_20170124] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE [DEV-RWA_IECMS-DE_Live_20170124]
GO
RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_20170124] FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\20170115_Full\DEV-RWA_IECMS-DE_DB_FULL_backup_20170115.bak' WITH  FILE = 1,  MOVE N'cu_RWA_IECMS' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_20170124_20160130_17_14.mdf',  MOVE N'cu_RWA_IECMS_DATA' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_20170124_DATA.ndf',  MOVE N'cu_RWA_IECMS_INDEX' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_20170124_INDEX.ndf',  MOVE N'cu_RWA_IECMS_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DE_Live_20170124_20160130_17_14_Log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_20170124] FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\20170124_Diff\DEV-RWA_IECMS-DE_DB_DIFF_backup_20170124.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5
GO" -Username $user -Password $pwd -ServerInstance $sqlName -Database "master" -QueryTimeout 65535 -ErrorAction Stop
}
catch{        
       Write-Host $_.Exception.Message
       throw 
}
#>

foreach ($f in Get-ChildItem -path "$path" -Filter "*.sql" | sort-object ){

try {

#$MyFile = Get-Content $f.FullName
#$MyFile | Out-File -Encoding "UTF8" $f.FullName
Write-Host "...Executing file " $f.Name "on " $dbname "Database"
invoke-sqlcmd -InputFile $f.FullName –Username $user –Password $pwd -serverinstance $sqlName -database $dbname -QueryTimeout 65535 -ErrorAction 'Stop'
#>
}
catch {
       Write-Host "...error while executing file " $f.Name "on " $dbname "Database"
       Write-Host $_.Exception.Message
       throw             
    }
}

