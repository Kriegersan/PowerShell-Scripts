$options = @('','')
$things = Import-Csv -Path c:\temp\test.config -delimiter ' ' -header Root,Datastore
$things = $things | where { $_.Root -eq "emhs" }
foreach ($thing in $things){
#write-host $thing.root $thing.datastore
$datastore = $thing.datastore
#$datastore = $datastore.replace("\\","")
$split = ($datastore.replace("\\","")).split("\")
$server = $split[0]
$drive = $split[1]

$disk = Get-WMIObject Win32_LogicalDisk -computer $server -filter "VolumeName = '$drive'"
$gbfree = [Math]::Round(($disk.freespace/1073741824),2)
write-host $datastore $gbfree

$options += ,@($datastore,$gbfree)
}
$sorted = $options | sort-object @{Expression={$_[1]}; Ascending=$false}
$winner = $sorted[0][0]
$space = $sorted[0][1]
echo "Winner: $winner  Space: $space"