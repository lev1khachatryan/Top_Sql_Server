if ($host.name -notmatch 'ISE') {
	$consoleHost = $true
	$scriptRoot = $PSScriptRoot 
} else {
	$scriptRoot = "H:\Synergy\Final Replication Scripts"
}

Start-Transcript $(join-path $scriptRoot "log.txt")

$tablesCSV = Join-Path $scriptRoot "Tables To be replicated.csv"
$functionsScript = Join-Path $scriptRoot "function.ps1"
$configsFile = Join-Path $scriptRoot "config.ps1"

$percentage = 0
$count = 0

. $configsFile 
. $functionsScript 

if ($consoleHost){
	Use-RunAs 
	"Script Running As Administrator" 
	Sleep 1
}

if (-not (Test-Path $replDataDirectory)){
    New-Item -Path $replDataDirectory -ItemType directory -Force -Verbose
}

$importedColumnList = $(Import-Csv $tablesCSV).Tables
$tablesCount = $importedColumnList.Count

Get-Set-ACL -User $sqlAgnetServiceAccount -Rights "Modify" -Folder $replDataDirectory -noInheritance 

Import-Module sqlps -DisableNameChecking

$username = 'sis'
$mssqlSrvPswd = Read-Host -assecurestring "Enter password for the user $username"
$mssqlSrvPswdNon = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($mssqlSrvPswd))

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Replication") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.RMO") | Out-Null

$mySrvConn = new-object Microsoft.SqlServer.Management.Common.ServerConnection
$mySrvConn.ServerInstance=$Server
$mySrvConn.LoginSecure = $false
$mySrvConn.Login = $username
$mySrvConn.SecurePassword = $mssqlSrvPswd

$srv = $(New-Object Microsoft.SqlServer.Management.Smo.Server $mySrvConn).Name
$db = $(New-Object Microsoft.SqlServer.Management.Smo.Server $mySrvConn).Databases

$checkDistribution = Invoke-Sqlcmd -ServerInstance $Server -Query $(Check-Publication -Distribution $DistributorDbName) -Username $username -Password $mssqlSrvPswdNon -ErrorAction SilentlyContinue
if ($checkDistribution -and $checkDistribution.length -ne 0){
	writeLog "Executing --> Drop-Replication on [$publicationName]" Cyan
    Invoke-Sqlcmd -ServerInstance $Server -Query $(Drop-Replication -Data_DB_Name $Data_DB_Name -publicationName $publicationName) -Username $username -Password $mssqlSrvPswdNon
	#writeLog "Executing --> Drop-Replication-Cleanup on [$publicationName]" Cyan
    #Invoke-Sqlcmd -ServerInstance $Server -Query $(Drop-Replication-cleanup -Data_DB_Name $Data_DB_Name) -Username $username -Password $mssqlSrvPswdNon -Database 'master'
}

if ($db.name -notcontains $DistributorDbName){
    writeLog "Executing --> Create-DistributorDbQuery" Cyan
    Invoke-Sqlcmd -ServerInstance $Server -Query $(Create-DistributorDbQuery -DataPath $DBDataPath -LogPath $DBLogPath -ReplicationPath $replDataDirectory -SQLServer $srv -DBName $DistributorDbName) -Username $username -Password $mssqlSrvPswdNon
}

writeLog "Executing --> CreateReplication_Article" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(CreateReplication_Articles -importedColumnList $importedColumnList -Data_DB_Name $Data_DB_Name -publicationName $publicationName -publisherName $publisherName) -Username $username -Password $mssqlSrvPswdNon

writeLog "Executing --> Update-Articles" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Update-Articles -Data_DB_Name $Data_DB_Name -publicationName $publicationName) -Username $username -Password $mssqlSrvPswdNon

writeLog "Executing --> Alter_Replication_No_replicate_DDL" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Alter_Replication_No_replicate_DDL -Data_DB_Name $Data_DB_Name -publicationName $publicationName) -Username $username -Password $mssqlSrvPswdNon

User-Mapping -db $Data_DB_Name -User $sqlAgnetServiceAccount -db_role $db_role -Username $username -Password $mssqlSrvPswdNon
User-Mapping -db $DE_DB_Name -User $sqlAgnetServiceAccount -db_role $db_role -Username $username -Password $mssqlSrvPswdNon

writeLog "Executing --> Create-Subscription" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Create-Subscription -Data_DB_Name $Data_DB_Name -De_DB_Name $DE_DB_Name -publicationName $publicationName -SQLServer $Server -DitributorName $DistributorDbName) -Username $username -Password $mssqlSrvPswdNon -Verbose

#writeLog "Executing --> Create Replication_BeforeCreate procedure" Cyan
#Invoke-Sqlcmd -ServerInstance $Server -Query $(Replication_BeforeCreate -DE_DB_Name $DE_DB_Name) -Username $username -Password $mssqlSrvPswdNon

#writeLog "Executing --> Create Replication_AfterCreate procedure"  Cyan
#Invoke-Sqlcmd -ServerInstance $Server -Query $(Replication_AfterCreate -DE_DB_Name $DE_DB_Name) -Username $username -Password $mssqlSrvPswdNon

$RepInstanceObject = New-Object Microsoft.SqlServer.Replication.ReplicationServer $mySrvConn 
$RepInstanceStatus = New-Object Microsoft.SqlServer.Replication.ReplicationMonitor $mySrvConn

writeLog "Executing --> Run-procedureBeforeRepl" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Run-procedureBeforeRepl -DE_DB_Name $DE_DB_Name) -Username $username -Password $mssqlSrvPswdNon

writeLog "Executing --> Start-ReplicationJob" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Start-ReplicationJob -Data_DB_Name $Data_DB_Name) -Username $username -Password $mssqlSrvPswdNon

while ($true){
    $a = Get-SnapshotAgentstatus
    $b = Get-DitributorAgentstatus
    $c = Get-LogReaderAgentstatus
    $regex1 = "\[(\d+)%].*"
        
    if ($a -match $regex1){
	    if ($a.length -gt 2){
            write-host $c -ForegroundColor Cyan
            write-host $b -ForegroundColor Yellow
            write-host $a -ForegroundColor Green

            $percentage = [regex]::Matches($a,$regex1).groups[1].value
        }

        if ($percentage -eq "100"){
            $regex2 = "\[(\d+)%].*?of (\d+)"
            $count = [regex]::Matches($a,$regex2).groups[2].value
            if ($tablesCount -eq $count){
                if ($b -match "No replicated" -and $c -match "No replicated"){
                    $replStatus = Invoke-Sqlcmd -ServerInstance $Server -Query $(Check-ReplicationStatus -Data_DB_Name $Data_DB_Name) -Username $username -Password $mssqlSrvPswdNon
                    if ($replStatus.length -ne 0){
                        break
                    }
                }
            }
        }
    }
    start-sleep 1
}

writeLog "Executing --> Alter-Identity" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Alter-Identity -DE_DB_Name $DE_DB_Name) -Username $username -Password $mssqlSrvPswdNon

#writeLog "Executing --> Configure-ReplHistory" Cyan
#Invoke-Sqlcmd -ServerInstance $Server -Query $(Configure-ReplHistory -DE_DB_Name $DE_DB_Name) -Username $username -Password $mssqlSrvPswdNon

writeLog "Executing --> Fix-FK" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Fix-FK -DE_DB_Name $DE_DB_Name) -Username $username -Password $mssqlSrvPswdNon

writeLog "Executing --> Run-procedureAfterRepl" Cyan
Invoke-Sqlcmd -ServerInstance $Server -Query $(Run-procedureAfterRepl -DE_DB_Name $DE_DB_Name) -Username $username -Password $mssqlSrvPswdNon

Stop-Transcript
pause