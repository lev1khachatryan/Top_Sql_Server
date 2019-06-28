#Path for scripts to be executed
$path = "C:\MyProjects\mrt-sigip\mrt-sigip-db\src\main\scripts\DEV-MRT_SIGIP-DATA\migrate\Test"
# Set SQL Server instance name
$sqlName= "sis2s013"
# Set SQL Server instance pass
$pass = "jenkins" 
# Set the databse name which you want to backup without postfix
# , for example RWA_IECMS-bugfix_RWAIECMS-2786- instead of RWA_IECMS-bugfix_RWAIECMS-2786-DATA
$dbname = "DEV-MRT_SIGIP-DATA_Live_20161213"
#scripts path


foreach ($f in Get-ChildItem -path "$path" -Filter "*.sql" | sort-object ){

try {

#$MyFile = Get-Content $f.FullName
#$MyFile | Out-File -Encoding "UTF8" $f.FullName
Write-Host "...Executing file " $f.Name "on " $dbname "Database"
invoke-sqlcmd -InputFile $f.FullName -serverinstance $sqlName -database $dbname -ErrorAction Stop -QueryTimeout 65535
#>
}
catch {
       Write-Host "...error while executing file " $f.Name "on " $dbname "Database"
       Write-Host $_.Exception.Message
       throw             
    }
}

