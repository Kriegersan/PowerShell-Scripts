    $server = "ellsley"
    $drive = "Datavol1"
    $disk = Get-WMIObject Win32_LogicalDisk -computer $server -filter "DeviceID = '$drive'"
    echo $drive
    $gbfree = [Math]::Round(($disk.freespace/1073741824),2)
    write-host $gbfree



