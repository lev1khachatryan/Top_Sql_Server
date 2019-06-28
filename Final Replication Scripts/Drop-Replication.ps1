if ($host.name -notmatch 'ISE') {
	$consoleHost = $true
	$scriptRoot = $PSScriptRoot 
} else {
	$scriptRoot = "E:\Synergy\replication"
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

pause
