
$param1 = $args[0]
$param2 = $args[1]

if ($param2 -eq 'y'){
   $path = 'C:\'
   New-Item -Path $path -name $param1 -ItemType "directory"
}
