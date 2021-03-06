#Read the text file
Get-Content c:\temp\shared_volume.txt | ForEach-Object {
 #Write-Progress -Activity "Scanning shares" -Status $_

  # Get the server name
  $Server = "ellsley"

  # Get the share
  $ShareName = [string]'Datavol1'
  $Share = [WMI]"\\$Server\root\cimv2:Win32_Share.Name='$Sharename'"

  # Get the disk
  $VolumeDeviceID = $Share.Path -Replace '\\.*$'
  $Volume = [WMI]"\\$Server\root\cimv2:Win32_LogicalDisk.DeviceID='$VolumeDeviceID'"

  # Build the output combining everything we found above
  $_ | Select-Object `
    @{n='ServerName';e={ $Server }},
    @{n='ShareName';e={ $ShareName }},
    @{n='Path';e={ $Share.Path }},
    @{n='Volume';e={ $Volume.Name }},
    @{n='TotalSize';e={ '{0:N2}' -f ($Volume.Size / 1Gb) }},
    @{n='Freespace';e={ '{0:N2}' -f ($Volume.Freespace / 1Gb) }},
    @{n='ShareSize';e={ '{0:N2}' -f ((New-Object -ComObject Scripting.FileSystemObject).GetFolder($_).Size / 1Gb) }}

# Export the results to a CSV file
} | Export-Csv c:\temp\File.csv -NoTypeInformation