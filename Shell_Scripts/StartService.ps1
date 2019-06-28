
cls;
$WinRar = "C:\Program Files\WinRAR\winrar.exe"
$FullDBFolderName = $args[0]
$DiffDBFolderName = $args[1]
$ServerName       = $args[2]
$YesOrNoFull      = $args[3]
$YesOrNoDiff      = $args[4]
$Path013 = "\\sis2s013\RWA IECMS2\BACKUP\_FromCountry\Live\"
$Path082 = "\\sis2s082\BACKUP_E\RWA_IECMS\FromCountry\Live\"
$LocationPath013Diff = $Path013 + $DiffDBFolderName
$LocationPath013Full = $Path013 + $FullDBFolderName
$LocationPath082Diff = $Path082 + $DiffDBFolderName
$LocationPath082Full = $Path082 + $FullDBFolderName
$LocationPath013Diff_2 = "$($Path013)$($DiffDBFolderName)\"
$LocationPath013Full_2 = "$($Path013)$($FullDBFolderName)\"
$LocationPath082Diff_2 = "$($Path082)$($DiffDBFolderName)\"
$LocationPath082Full_2 = "$($Path082)$($FullDBFolderName)\"
$DiffDBDate = ($DiffDBFolderName).Substring(0,8)
$FullDBDate = ($FullDBFolderName).Substring(0,8)
$ftp = "ftp://iecms@149.56.129.101" 
$user = 'iecms'
$pass = 'iecms12password'
$DiffFolderInFTP = 'Diff'
$FullFolderInFTP = 'Full'
$KBDBName   = "[DEV-RWA_IECMS-KB_Live_" + $DiffDBDate +   "]"
$DataDBName = "[DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "]"
$DEDBName   = "[DEV-RWA_IECMS-DE_Live_" + $DiffDBDate +   "]"


#hamapataskhan folder e sarqum
If($YesOrNoFull -eq 'y'){
    If($ServerName -like "*013"){
        If((Test-Path $LocationPath013Full) -eq $False) {
        New-Item -Path $Path013 -name $FullDBFolderName -ItemType "directory" | Out-Null
        }
        Else { 
            "The $Location path is already there." 
        }
    }
    else 
    {
        If($ServerName -like "*082"){
            If((Test-Path $LocationPath082Full) -eq $False) {
            New-Item -Path $Path082 -name $FullDBFolderName -ItemType "directory" | Out-Null
            }
            Else { 
                "The $Location path is already there." 
            }
        }
    }
}
else{
    If($YesOrNoDiff -eq 'y')
    {
        If($ServerName -like "*013"){
            If((Test-Path $LocationPath013Diff) -eq $False) {
            New-Item -Path $Path013 -name $DiffDBFolderName -ItemType "directory" | Out-Null
            }
            Else { 
                "The $Location path is already there." 
            }
        }
        else 
        {
            If($ServerName -like "*082"){
                If((Test-Path $LocationPath082Diff) -eq $False) {
                New-Item -Path $Path082 -name $DiffDBFolderName -ItemType "directory" | Out-Null
                }
                Else { 
                    "The $Location path is already there." 
                }
            }
        }
    }
}
cls;
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

#Download e anum miayn Full -ery
If ($YesOrNoFull -eq 'y')
{
    $FullFolderPath= $ftp + "/" + $FullFolderInFTP + "/"
    $FullFolderFilesInFTP=Get-FTPDir -url $FullFolderPath -credentials $credentials
    $filesInFull = ($FullFolderFilesInFTP -split "`r`n")
    $filesInFull 
        $webclient = New-Object System.Net.WebClient 
        $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 
        cls;
        Write-Host "The Backups are being downloaded, please wait…"
    foreach ($file in ($filesInFull | where {$_ -like "*$FullDBDate.zip"})){
            $source = $FullFolderPath + $file  
            If($ServerName -like "*013"){
                $destination = $LocationPath013Full + "\"  + $file
            }
            else{
                If($ServerName -like "*082"){
                    $destination = $LocationPath082Full + "\"  + $file
                }
            }
            $webclient.DownloadFile($source, $destination)
    }
    cls;
    Write-Host "The Backups are being extracted, please wait… "
    #Exstract anenq Full-i ZIP-file -ery
    If($ServerName -like "*013"){
        $ZipsInFull = Get-ChildItem -filter "*.zip" -path $LocationPath013Full_2 -Recurse
        $Destination = $LocationPath013Full + '\'
    }
    else{ 
        If($ServerName -like "*082"){
            $ZipsInFull = Get-ChildItem -filter "*.zip" -path $LocationPath082Full_2 -Recurse
            $Destination = $LocationPath082Full + '\'
        }
    }

    foreach ($zip in $ZipsInFull)
    {
    &$Winrar x $zip.FullName $Destination
    Get-Process winrar | Wait-Process
    }
}
#download e anum miayn Diff-ery 
else
{
    If($YesOrNoDiff -eq 'y')
    {
        $DiffFolderPath= $ftp + "/" + $DiffFolderInFTP + "/"
        $DiffFolderFilesInFTP=Get-FTPDir -url $DiffFolderPath -credentials $credentials
        $filesInDiff = ($DiffFolderFilesInFTP -split "`r`n")
        $filesInDiff 
            $webclient = New-Object System.Net.WebClient 
            $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 
            cls;
            Write-Host "The Backups are being downloaded, please wait…"
        foreach ($file in ($filesInDiff | where {$_ -like "*$DiffDBDate.zip"})){
                $source = $DiffFolderPath + $file  
                If($ServerName -like "*013"){
                    $destination = $Path013 + $DiffDBFolderName + "\"  + $file
                }
                else{ 
                    If($ServerName -like "*082"){
                        $destination = $Path082 + $DiffDBFolderName + "\"  + $file
                    }
                }
                $webclient.DownloadFile($source, $destination)
        }
        cls;
        Write-Host "The Backups are being extracted, please wait…"
        #Exstract anenq Diff-i ZIP-file -ery
        If($ServerName -like "*013"){
            $ZipsInDiff = Get-ChildItem -filter "*.zip" -path $LocationPath013Diff_2 -Recurse 
            $Destination = $LocationPath013Diff + '\'
        }
        else{ 
            If($ServerName -like "*082"){
                $ZipsInDiff = Get-ChildItem -filter "*.zip" -path $LocationPath082Diff_2 -Recurse
                $Destination = $LocationPath082Diff + '\'
            }
        }

        foreach ($zip in $ZipsInDiff)
        {
        &$Winrar x $zip.FullName $Destination
        Get-Process winrar | Wait-Process
        }
    }
}
cls;
Write-Host "The Backups are being restored, please wait…"

#Restore anenq DB-nery
Add-PSSnapin SqlServerCmdletSnapin100
Add-PSSnapin SqlServerProviderSnapin100

If($YesOrNoFull -eq 'y')
{
    If($ServerName -like "*013"){
        [string]$StringFull013_1 = "
        RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-KB_DB_FULL_backup_" + $FullDBDate + ".bak' 
        WITH  FILE = 1,  
        MOVE N'IDM-Kb-Dev-Release-7.61' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "_20160130_17_27.mdf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_DATA' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "_20160130_17_27_Log.ldf',  
        NOUNLOAD,  STATS = 5
        "
        Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $StringFull013_1

        [string]$StringFull013_2 = "
        RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DATA_DB_FULL_backup_" + $FullDBDate + ".bak' 
        WITH  FILE = 1,  
        MOVE N'IDM-Kb-Dev-Release-7.61' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "_20160130_17_27.mdf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_DATA' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "_20160130_17_27_Log.ldf',  
        NOUNLOAD,  STATS = 5
        "
        Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $StringFull013_2

        [string]$StringFull013_3 = "
        RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DE_DB_FULL_backup_" + $FullDBDate + ".bak' 
        WITH  FILE = 1,  
        MOVE N'IDM-Kb-Dev-Release-7.61' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_27.mdf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_DATA' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_27_Log.ldf',  
        NOUNLOAD,  STATS = 5
        "
        Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $StringFull013_3
    }

    else
    { 
        If($ServerName -like "*082"){
            [string]$StringFull082_1 = "
            RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_" + $FullDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-KB_DB_FULL_backup_" + $FullDBDate + ".bak' 
            WITH  FILE = 1,  
            MOVE N'IDM-Kb-Dev-Release-7.61' 
            TO N'E:\DEFAULT.DATA\DEV-RWA_IECMS-KB_Live_" + $FullDBDate + "_20160130_17_27.mdf',  
            MOVE N'IDM-Kb-Dev-Release-7.61_DATA' 
            TO N'E:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_DATA_Live_" + $FullDBDate + ".ndf',  
            MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' 
            TO N'E:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live_" + $FullDBDate + ".ndf',  
            MOVE N'IDM-Kb-Dev-Release-7.61_log' 
            TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-KB_Live_" + $FullDBDate + "_20160130_17_27_Log.ldf',  
            NOUNLOAD,  STATS = 5
            "
            Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $StringFull082_1

            [string]$StringFull082_2 = "
            RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $FullDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DATA_DB_FULL_backup_" + $FullDBDate + ".bak' 
            WITH  FILE = 1,  
            MOVE N'IDM-Data-Dev-Release-7.61' 
            TO N'E:\DEFAULT.DATA\DEV-RWA_IECMS-DATA_Live_" + $FullDBDate + "_20160130_17_14.mdf',  
            MOVE N'IDM-Data-Dev-Release-7.61_DATA' 
            TO N'E:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_DATA_Live_" + $FullDBDate + ".ndf',  
            MOVE N'IDM-Data-Dev-Release-7.61_INDEX' 
            TO N'E:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_INDEX_Live_" + $FullDBDate + ".ndf',  
            MOVE N'IDM-Data-Dev-Release-7.61_log' 
            TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DATA_Live_" + $FullDBDate + "_20160130_17_14_Log.ldf',  
            NOUNLOAD,  STATS = 5
            "
            Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $StringFull082_2

            [string]$StringFull082_3 = "
            RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $FullDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DE_DB_FULL_backup_" + $FullDBDate + ".bak' 
            WITH  FILE = 1,  
            MOVE N'cu_RWA_IECMS' 
            TO N'E:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_" + $FullDBDate + "_20160130_17_14.mdf',  
            MOVE N'cu_RWA_IECMS_DATA' 
            TO N'E:\DEFAULT.DATA\cu_RWA_IECMS_DATA_Live_" + $FullDBDate + ".ndf',  
            MOVE N'cu_RWA_IECMS_INDEX' 
            TO N'E:\DEFAULT.DATA\cu_RWA_IECMS_INDEX_Live_" + $FullDBDate + ".ndf',  
            MOVE N'cu_RWA_IECMS_log' 
            TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DE_Live_" + $FullDBDate + "_20160130_17_14_Log.ldf',  
            NOUNLOAD,  STATS = 5
            "
            Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $StringFull082_3
        }
    }
}
else{
    If($ServerName -like "*013"){
        [string]$StringDiff013_1 = "
        RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-KB_DB_FULL_backup_" + $FullDBDate + ".bak' 
        WITH  FILE = 1, 
        MOVE N'IDM-Kb-Dev-Release-7.61' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "_20160130_17_27.mdf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_DATA' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' TO N'D:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Kb-Dev-Release-7.61_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "_20160130_17_27_Log.ldf',  
        NORECOVERY,  NOUNLOAD,  STATS = 5
        RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $DiffDBFolderName + "\DEV-RWA_IECMS-KB_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
        WITH  FILE = 1,  NOUNLOAD,  STATS = 5"
        Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $StringDiff013_1
        
        [string]$StringDiff013_2 = "
        RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DATA_DB_FULL_backup_" + $FullDBDate + ".bak' 
        WITH  FILE = 1,  
        MOVE N'IDM-Data-Dev-Release-7.61' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "_20160130_17_14.mdf',  
        MOVE N'IDM-Data-Dev-Release-7.61_DATA' TO N'D:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Data-Dev-Release-7.61_INDEX' TO N'D:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'IDM-Data-Dev-Release-7.61_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "_20160130_17_14_Log.ldf',  
        NORECOVERY,  NOUNLOAD,  STATS = 5
        RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $DiffDBFolderName + "\DEV-RWA_IECMS-DATA_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
        WITH  FILE = 1,  NOUNLOAD,  STATS = 5
        "
        Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $StringDiff013_2
    
        [string]$StringDiff013_3 = "
        RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DE_DB_FULL_backup_" + $FullDBDate + ".bak' 
        WITH  FILE = 1,  
        MOVE N'cu_RWA_IECMS' TO N'D:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_14.mdf',  
        MOVE N'cu_RWA_IECMS_DATA' TO N'D:\DEFAULT.DATA\cu_RWA_IECMS_DATA_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'cu_RWA_IECMS_INDEX' TO N'D:\DEFAULT.DATA\cu_RWA_IECMS_INDEX_Live_" + $DiffDBDate + ".ndf',  
        MOVE N'cu_RWA_IECMS_log' TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_14_Log.ldf',  
        NORECOVERY,  NOUNLOAD,  STATS = 5    
        RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "] 
        FROM  DISK = N'F:\RWA IECMS\BACKUP\_FromCountry\Live\" + $DiffDBFolderName + "\DEV-RWA_IECMS-DE_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
        WITH  FILE = 1,  NOUNLOAD,  STATS = 5"
        Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $StringDiff013_3
    }

    else 
    {
        If($ServerName -like "*082"){
            [string]$StringDiff082_1 = "
            RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-KB_DB_FULL_backup_" + $FullDBDate + ".bak' 
            WITH  FILE = 1,  
            MOVE N'IDM-Kb-Dev-Release-7.61' 
            TO N'E:\DEFAULT.DATA\DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "_20160130_17_27.mdf',  
            MOVE N'IDM-Kb-Dev-Release-7.61_DATA' 
            TO N'E:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
            MOVE N'IDM-Kb-Dev-Release-7.61_INDEX' 
            TO N'E:\DEFAULT.DATA\IDM-Kb-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
            MOVE N'IDM-Kb-Dev-Release-7.61_log' 
            TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "_20160130_17_27_Log.ldf',  
            NORECOVERY,  NOUNLOAD,  STATS = 5
            RESTORE DATABASE [DEV-RWA_IECMS-KB_Live_" + $DiffDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $DiffDBFolderName + "\DEV-RWA_IECMS-KB_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
            WITH  FILE = 1,  NOUNLOAD,  STATS = 5
            "
            Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $StringDiff082_1

            [string]$StringDiff082_2 = "
            RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DATA_DB_FULL_backup_" + $FullDBDate + ".bak' 
            WITH  FILE = 1,
            MOVE N'IDM-Data-Dev-Release-7.61'
            TO N'E:\DEFAULT.DATA\DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "_20160130_17_14.mdf',  
            MOVE N'IDM-Data-Dev-Release-7.61_DATA' 
            TO N'E:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_DATA_Live_" + $DiffDBDate + ".ndf',  
            MOVE N'IDM-Data-Dev-Release-7.61_INDEX' 
            TO N'E:\DEFAULT.DATA\IDM-Data-Dev-Release-7.61_INDEX_Live_" + $DiffDBDate + ".ndf',  
            MOVE N'IDM-Data-Dev-Release-7.61_log' 
            TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "_20160130_17_14_Log.ldf',  
            NORECOVERY,  NOUNLOAD,  STATS = 5
            RESTORE DATABASE [DEV-RWA_IECMS-DATA_Live_" + $DiffDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $DiffDBFolderName + "\DEV-RWA_IECMS-DATA_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
            WITH  FILE = 1,  NOUNLOAD,  STATS = 5
            "
            Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $StringDiff082_2

            [string]$StringDiff082_3 = "
            RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $FullDBFolderName + "\DEV-RWA_IECMS-DE_DB_FULL_backup_" + $FullDBDate + ".bak' 
            WITH  FILE = 1,  
            MOVE N'cu_RWA_IECMS' 
            TO N'E:\DEFAULT.DATA\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_14.mdf',  
            MOVE N'cu_RWA_IECMS_DATA' 
            TO N'E:\DEFAULT.DATA\cu_RWA_IECMS_DATA_Live_" + $DiffDBDate + ".ndf',  
            MOVE N'cu_RWA_IECMS_INDEX' 
            TO N'E:\DEFAULT.DATA\cu_RWA_IECMS_INDEX_Live_" + $DiffDBDate + ".ndf',  
            MOVE N'cu_RWA_IECMS_log' 
            TO N'E:\DEFAULT.LOG\DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "_20160130_17_14_Log.ldf',  
            NORECOVERY,  NOUNLOAD,  STATS = 5
            RESTORE DATABASE [DEV-RWA_IECMS-DE_Live_" + $DiffDBDate + "] 
            FROM  DISK = N'E:\BACKUP_E\RWA_IECMS\FromCountry\Live\" + $DiffDBFolderName + "\DEV-RWA_IECMS-DE_DB_DIFF_backup_" + $DiffDBDate + ".bak' 
            WITH  FILE = 1,  NOUNLOAD,  STATS = 5
            "
            Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $StringDiff082_3
        }
    }
}


[string]$SpoilPasswords = "
USE "+ $KBDBName + "
DECLARE @Password VARCHAR(255)
DECLARE @Salt VARCHAR(255)
SET @Password = N'b0b5deb00d5e9bc6d62333cf1ed45911bfbd73db'
SET @Salt = N'394c8bb8-01c4-48e1-ab5b-545bfa9d8b55' 
UPDATE dbo.um_UserData
SET Psw = @Password,
PswSalt = @Salt
UPDATE dbo.um_PasswordHistory
SET Password = @Password
"
Invoke-Sqlcmd  -ServerInstance $ServerName -Database master -QueryTimeout 65536 -Query $SpoilPasswords


[string]$SpoilEmailsAndURLs = "
USE "+ $KBDBName + "
UPDATE dbo.um_UserProfile
SET UserEmail = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
Update um_Configurations
set AdminEmail = 'Vigen.Vardanyan@arm.synisys.com'
UPDATE dbo.UI_SubTabs
SET ExternalURL = REPLACE(ExternalURL , 'iecms.gov.rw' , 'sis2s014:8807')
USE " + $DataDBName + "
UPDATE dbo.C_User
SET Email = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
UPDATE dbo.C_Group
SET Email = 'testGroup' + CAST(GroupID AS NVARCHAR(50)) + '@test.com'
UPDATE dbo.Party
SET Email = 'testParty' + CAST(PartyID AS NVARCHAR(50)) + '@test.com'
UPDATE dbo.C_DummyParty 
SET OrganisationEmail = 'testDummyPartyOrg' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com', 
PersonEmail = 'testDummyPartyPers' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com'
USE " + $DEDBName + "
UPDATE dbo.C_User
SET Email = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
UPDATE dbo.C_Group
SET Email = 'testGroup' + CAST(GroupID AS NVARCHAR(50)) + '@test.com'
UPDATE dbo.DE_Party
SET Email = 'testParty' + CAST(PartyID AS NVARCHAR(50)) + '@test.com'
UPDATE dbo.C_DummyParty 
SET OrganisationEmail = 'testDummyPartyOrg' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com', 
PersonEmail = 'testDummyPartyPers' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com'
"
Invoke-Sqlcmd  -ServerInstance $ServerName -Database master -QueryTimeout 65536 -Query $SpoilEmailsAndURLs



<#

If($ServerName -like "*082"){
    [string]$SpoilPasswords082 = "
    USE "+ $KBDBName + "
    DECLARE @Password VARCHAR(255)
    DECLARE @Salt VARCHAR(255)
    SET @Password = N'b0b5deb00d5e9bc6d62333cf1ed45911bfbd73db'
    SET @Salt = N'394c8bb8-01c4-48e1-ab5b-545bfa9d8b55' 
    UPDATE dbo.um_UserData
    SET Psw = @Password,
    PswSalt = @Salt
    UPDATE dbo.um_PasswordHistory
    SET Password = @Password
    "
    Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $SpoilPasswords082
    
    
    [string]$SpoilEmailsAndURLs082 = "
    USE "+ $KBDBName + "
    UPDATE dbo.um_UserProfile
    SET UserEmail = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
    Update um_Configurations
    set AdminEmail = 'Vigen.Vardanyan@arm.synisys.com'
    UPDATE dbo.UI_SubTabs
    SET ExternalURL = REPLACE(ExternalURL , 'iecms.gov.rw' , 'sis2s014:8807')
    USE " + $DataDBName + "
    UPDATE dbo.C_User
    SET Email = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
    UPDATE dbo.C_Group
    SET Email = 'testGroup' + CAST(GroupID AS NVARCHAR(50)) + '@test.com'
    UPDATE dbo.Party
    SET Email = 'testParty' + CAST(PartyID AS NVARCHAR(50)) + '@test.com'
    UPDATE dbo.C_DummyParty 
    SET OrganisationEmail = 'testDummyPartyOrg' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com', 
    PersonEmail = 'testDummyPartyPers' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com'
    USE " + $DEDBName + "
    UPDATE dbo.C_User
    SET Email = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
    UPDATE dbo.C_Group
    SET Email = 'testGroup' + CAST(GroupID AS NVARCHAR(50)) + '@test.com'
    UPDATE dbo.DE_Party
    SET Email = 'testParty' + CAST(PartyID AS NVARCHAR(50)) + '@test.com'
    UPDATE dbo.C_DummyParty 
    SET OrganisationEmail = 'testDummyPartyOrg' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com', 
    PersonEmail = 'testDummyPartyPers' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com'
    "
    Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $SpoilEmailsAndURLs082
}
else{
    If($ServerName -like "*013"){
        [string]$SpoilPasswords013 = "
        USE "+ $KBDBName + "
        DECLARE @Password VARCHAR(255)
        DECLARE @Salt VARCHAR(255)
        SET @Password = N'b0b5deb00d5e9bc6d62333cf1ed45911bfbd73db'
        SET @Salt = N'394c8bb8-01c4-48e1-ab5b-545bfa9d8b55' 
        UPDATE dbo.um_UserData
        SET Psw = @Password,
        PswSalt = @Salt
        UPDATE dbo.um_PasswordHistory
        SET Password = @Password
        "
        Invoke-Sqlcmd  -ServerInstance sis2s013 -Database master -QueryTimeout 65536 -Query $SpoilPasswords
        
        
        [string]$SpoilEmailsAndURLs013 = "
        USE "+ $KBDBName + "
        UPDATE dbo.um_UserProfile
        SET UserEmail = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
        Update um_Configurations
        set AdminEmail = 'Vigen.Vardanyan@arm.synisys.com'
        UPDATE dbo.UI_SubTabs
        SET ExternalURL = REPLACE(ExternalURL , 'iecms.gov.rw' , 'sis2s014:8807')
        
        USE " + $DataDBName + "
        UPDATE dbo.C_User
        SET Email = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
        UPDATE dbo.C_Group
        SET Email = 'testGroup' + CAST(GroupID AS NVARCHAR(50)) + '@test.com'
        UPDATE dbo.Party
        SET Email = 'testParty' + CAST(PartyID AS NVARCHAR(50)) + '@test.com'
        UPDATE dbo.C_DummyParty 
        SET OrganisationEmail = 'testDummyPartyOrg' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com', 
        PersonEmail = 'testDummyPartyPers' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com'
        USE " + $DEDBName + "
        UPDATE dbo.C_User
        SET Email = 'testUser' + CAST(UserID AS NVARCHAR(50)) + '@test.com'
        UPDATE dbo.C_Group
        SET Email = 'testGroup' + CAST(GroupID AS NVARCHAR(50)) + '@test.com'
        UPDATE dbo.DE_Party
        SET Email = 'testParty' + CAST(PartyID AS NVARCHAR(50)) + '@test.com'
        UPDATE dbo.C_DummyParty 
        SET OrganisationEmail = 'testDummyPartyOrg' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com', 
        PersonEmail = 'testDummyPartyPers' + CAST(DummyPartyID AS NVARCHAR(50)) + '@test.com'
        "
        Invoke-Sqlcmd  -ServerInstance sis2s082 -Database master -QueryTimeout 65536 -Query $SpoilEmailsAndURLs013
    }
}
#>

