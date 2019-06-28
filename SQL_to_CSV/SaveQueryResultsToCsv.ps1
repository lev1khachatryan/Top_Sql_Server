$sqlName= "sis2s082"
# Set SQL Server instance user
$user = "idmdaduser" 
# Set SQL Server instance pass
$pwd = "idmdaduser"
# Set SQL Server db name
$dbname = "DB name"
# File Path
$scriptPath = "Script Path"

foreach ($f in Get-ChildItem -path "$scriptPath" -Filter "*.sql" | sort-object ){
    $csv_file_name = $f.FullName -replace ".sql", ".csv"
    if (Test-Path $csv_file_name) 
    {
      Remove-Item $csv_file_name
    }
    invoke-sqlcmd -InputFile $f.FullName –Username $user –Password $pwd -serverinstance $sqlName -database $dbname -QueryTimeout 65535 -ErrorAction 'Stop'`
    |Export-Csv -Path $csv_file_name
}
