
cls;
$FullDBFolderName = $args[1]
$Name = $args[2]
$ServerName = $args[3]
$Location = "\\sis2s013\RWA IECMS2\BACKUP\_FromCountry\Live\"
$LocationFile = $Location + $Name
$LocationFile1 = "$($Location)$($Name)\"
$DiffDBDate = ($Name).Substring(0,8)
$FullDBDate = ($FullDBFolderName).Substring(0,8)

#hamapataskhan folder e sarqum
If((Test-Path $LocationFile) -eq $False) {
New-Item -Path $Location -name $Name -ItemType "directory"
    }
Else {"The $LocationFile is already there."
    }


#download e anum Diff-ery 
$ftp = "ftp://iecms@52.56.35.121:50005" 
$user = 'iecms' 
$pass = 'iecms!admin'
$folder = 'Diff'

$credentials = new-object System.Net.NetworkCredential($user, $pass)

function Get-FtpDir ($url,$credentials) {
        $request = [Net.WebRequest]::Create($url)
        $request.Method = [System.Net.WebRequestMethods+FTP]::ListDirectory
        if ($credentials) { $request.Credentials = $credentials }
        $response = $request.GetResponse()
        $reader = New-Object IO.StreamReader $response.GetResponseStream() 
        $reader.ReadToEnd()
        $reader.Close()
        $response.Close()
}

$folderPath= $ftp + "/" + $folder + "/"
$Allfiles=Get-FTPDir -url $folderPath -credentials $credentials
$files = ($Allfiles -split "`r`n")
$files 
    $webclient = New-Object System.Net.WebClient 
    $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 
foreach ($file in ($files | where {$_ -like "*$DiffDBDate.zip"})){
        $source=$folderPath + $file  
        $destination = $Location + $Name + "\"  + $file 
        $webclient.DownloadFile($source, $destination)
}

#Exstract anenq Diff-i ZIP-file -ery

$Zips = Get-ChildItem -filter "*.zip" -path $LocationFile1 -Recurse
$Destination = $LocationFile + '\'
$WinRar = "C:\Program Files\WinRAR\winrar.exe"

foreach ($zip in $Zips)
{
&$Winrar x $zip.FullName $Destination
Get-Process winrar | Wait-Process
}


##########################################################################################################


cls;
$FullDBFolderName = '20170201_Full'
$Name = "20170209_Diff_2"
$Location = "\\sis2s013\RWA IECMS2\BACKUP\_FromCountry\Live\"
$LocationFile = $Location + $Name
$LocationFile1 = "$($Location)$($Name)\"
$DiffDBDate = ($Name).Substring(0,8)
$FullDBDate = ($FullDBFolderName).Substring(0,8)

#Restore anenq DB-nery
Add-PSSnapin SqlServerCmdletSnapin100
Add-PSSnapin SqlServerProviderSnapin100


[string]$str = "
RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_$DiffDBDate              _2] 
FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\$FullDBFolderName\DEV-RWA_IECMS-KB_DB_FULL_backup_$FullDBDate.bak' 
WITH  FILE = 1,  
MOVE N'IDM-Kb-Dev-Release-7.61' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-KB_Live_$DiffDBDate _20160130_17_27.mdf',  
MOVE N'IDM-Kb-Dev-Release-7.61_DATA' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_DATA_Live_$DiffDBDate.ndf',  
MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live_$DiffDBDate.ndf',  
MOVE N'IDM-Kb-Dev-Release-7.61_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-KB_Live_$DiffDBDate        _20160130_17_27_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5

RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_$DiffDBDate                _2] 
FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\$Name\DEV-RWA_IECMS-KB_DB_DIFF_backup_$DiffDBDate.bak' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 5
"


Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $str









<#

RESTORE DATABASE [DEV-RWA_IECMS-KB_Live] 
FROM  DISK = N'C:\MSSQL\BACKUP\RWA-IECMS_Levon\DEV-RWA_IECMS-KB_DB_FULL_backup_20170201.bak' 
WITH  FILE = 1,  
MOVE N'IDM-Kb-Dev-Release-7.61' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DEV-RWA_IECMS-KB_Live_20160130_17_27.mdf',  
MOVE N'IDM-Kb-Dev-Release-7.61_DATA' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\IDM-Kb-Dev-Release-7.61_DATA_Live.ndf',  
MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live.ndf',  
MOVE N'IDM-Kb-Dev-Release-7.61_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\DEV-RWA_IECMS-KB_Live_20160130_17_27_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE DATABASE [DEV-RWA_IECMS-KB_Live] 
FROM  DISK = N'C:\MSSQL\BACKUP\RWA-IECMS_Levon\DEV-RWA_IECMS-KB_DB_DIFF_backup_20170207.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

#>



Invoke-Sqlcmd  -ServerInstance sis2s019 -Database master -QueryTimeout 65536 -Query "
RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "] 
FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\"$FullDBFolderName"\DEV-RWA_IECMS-DATA_DB_FULL_backup_" + $FullDBDate + ".bak' 
WITH  FILE = 1,  
MOVE N'IDM-Data-Dev-Release-7.61' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DATA_Live_"$DiffDBDate"_20160130_17_14.mdf',  
MOVE N'IDM-Data-Dev-Release-7.61_DATA' TO N'D:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
MOVE N'IDM-Data-Dev-Release-7.61_INDEX' TO N'D:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
MOVE N'IDM-Data-Dev-Release-7.61_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "_20160130_17_14_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5

RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "] 
FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $Name + "\DEV-RWA_IECMS-DATA_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 5
"


Invoke-Sqlcmd  -ServerInstance sis2s019 -Database master -QueryTimeout 65536 -Query "
RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "] 
FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DE_DB_FULL_backup_" + $FullDBDate + ".bak' 
WITH  FILE = 1,  
MOVE N'cu_RWA_IECMS' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_14.mdf',  
MOVE N'cu_RWA_IECMS_DATA' TO N'D:\DEFAULT.DATA\cu_RWA_IECMS_DATA_Live_" + $DiffDBDate + ".ndf',  
MOVE N'cu_RWA_IECMS_INDEX' TO N'D:\DEFAULT.DATA\cu_RWA_IECMS_INDEX_Live_" + $DiffDBDate + ".ndf',  
MOVE N'cu_RWA_IECMS_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_14_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5

RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "] 
FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\$Name\DEV-RWA_IECMS-DE_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 5
"
