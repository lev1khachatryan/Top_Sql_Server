cls;
#Path for scripts to be executed
$path = "C:\Users\levon.khachatryan\Desktop\New folder"
# Set SQL Server instance name
$sqlName= "sis2s082"
# Set SQL Server instance user
$user = "idmdaduser" 
# Set SQL Server instance pass
$pwd = "idmdaduser" 
$dbname = "DEV-RWA_IECMS-DE_Live_20190106"


foreach ($f in Get-ChildItem -path "$path" -Filter "*.sql" | sort-object ){

try {
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
