
cls;
$Name = "20170124_Diff"
$Location = "\\sis2s013\RWA IECMS2\BACKUP\_FromCountry\Live\"
$LocationFile = $Location + $Name
<#
If((Test-Path $LocationFile) -eq $False) {
New-Item -Path $Location -name $Name -ItemType "directory"
    }
Else {"The $LocationFile is already there."
    }




#foldery ksarqi kprcni

    $ftp = "ftp://iecms@52.42.201.99:50005" 
    $user = 'iecms' 
    $pass = 'iecms!admin'
    $folder = 'Diff'
    $target = $Location 

    #SET CREDENTIALS
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

    #SET FOLDER PATH
    $folderPath= $ftp + "/" + $folder + "/"

    $Allfiles=Get-FTPDir -url $folderPath -credentials $credentials
    $files = ($Allfiles -split "`r`n")

    $files 

    $webclient = New-Object System.Net.WebClient 
    $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 
foreach ($file in ($files | where {$_ -like "*.zip"})){
        $source=$folderPath + $file  
        $destination = $target + $Name + "\"  + $file 
        $webclient.DownloadFile($source, $destination)
}

#>

#download arel prcela

cls;
$Name = "DBs"
$Location = "C:\Scripteby\"
$LocationFile = $Location + $Name


Function UnzipEverything($src, $dest)
{
   Add-Type -AssemblyName System.IO.Compression.FileSystem
   $zps = Get-ChildItem $src -Filter *.zip

   foreach ($zp IN $zps)
   {
       $all = $src + $zp
       [System.IO.Compression.ZipFile]::ExtractToDirectory($all, $dest)
   }
}

UnzipEverything -src "C:\Scripteby\DBs\"  -dest "C:\Scripteby\DBs"

