$computer = "makola"
$disk = Get-WMIObject Win32_LogicalDisk -computer $computer -filter "DeviceID = 'L:'"
$gbfree = $disk.freespace/1073741824
write-host $gbfree