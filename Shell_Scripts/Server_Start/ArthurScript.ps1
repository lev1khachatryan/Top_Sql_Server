@echo off
setlocal EnableDelayedExpansion
set /p input="Do you want to change de war?(y/n)"
if %input% == y (
set /p downloadFileLink="Please enter a download file link"
Powershell.exe -executionpolicy remotesigned -File C:\Users\arthur.rafayelyan\Desktop\GorillazRemoteProjects\remoteStopStartWithChangeFiles4.ps1 803 MRT C:\Users\arthur.rafayelyan\Desktop\GorillazRemoteProjects !downloadFileLink!
) else if %input% == n (
Powershell.exe -executionpolicy remotesigned -File   C:\Users\arthur.rafayelyan\Desktop\GorillazRemoteProjects\remoteStopStartWithChangeFiles4.ps1 803 MRT C:\Users\arthur.rafayelyan\Desktop\GorillazRemoteProjects 
)
pause 



$projectTomcatServerNumber = $args[0]
#the main folder with project war and xml file

$project = $args[1]
$projectPath = $args[2]
$deDownloadLink = $args[3]

$tomcatName = 'Tomcat' + $projectTomcatServerNumber

$service = Get-Service -Name $tomcatName -ComputerName sis2s014

if ($service.Status -notlike "Stopped"){
        (Get-WmiObject Win32_Process -ComputerName sis2s014 | ?{ $_.ProcessName -match $tomcatName }).Terminate()        
}

$mrtPath = '8.0.3'
$rwaPath = '8.0.4'


if($projectTomcatServerNumber -eq "803") {
    $path = "c$\Program Files\Apache Software Foundation\Tomcat" + " " + $mrtPath
    $dePath = "c$\idmFor803\idm-mrt-sigip-home\logs"
    if($deDownloadLink) {
        $client = new-object System.Net.WebClient
        $client.DownloadFile($deDownloadLink,"C:\Users\arthur.rafayelyan\Desktop\GorillazRemoteProjects\MRT\mrt-sigip-de.war")    
    }
} else {
    $path = "c$\Program Files\Apache Software Foundation\Tomcat" + " " + $rwaPath
    $dePath = "c$\idmFor804\idm-rwa-iecms-home\logs"    
    if($deDownloadLink) {
        $client = new-object System.Net.WebClient
        $client.DownloadFile($deDownloadLink,"C:\Users\arthur.rafayelyan\Desktop\GorillazRemoteProjects\RWA\rwa-iecms-de.war")    
    }
}

$folders = @("work", "temp", "logs")
# delete work, temp, log folder
foreach ($f in $folders) {
    if (Test-Path -Path "\\sis2s014\$path\$($f)") {
        Remove-Item -Path "\\sis2s014\$path\$($f)"  -Recurse -Force
    }
}

foreach ($p in Get-ChildItem "\\sis2s014\$dePath\") {
    Remove-Item -Path "\\sis2s014\$dePath\$($p)"  -Recurse -Force
}

$webAppPath = "\\sis2s014\\$($path)\webapps"

foreach ($p in Get-ChildItem $webAppPath -Filter "*.war") {
    Remove-Item -Path $p.FullName -Force -Recurse
    if(Test-Path -Path $p.FullName.Replace(".war", "")) {
        Remove-Item -Path $p.FullName.Replace(".war", "") -Force -Recurse
    }
}

$fullPath = $projectPath + "\" + $project

foreach($f in Get-ChildItem $fullPath) {
    if($f.Name -like "*.war") {
        Copy-Item $f.FullName "$webAppPath\"
    }
}

if($service.Status -notlike "Started") {    
    $service.Start()        
}
