$TotalCores = 0
$TotalSockets =0
$result = @()
$vmHosts = get-vmHost

foreach ($esxi in $VMHots)
{
$hostCPU=$esxi.ExtensionData.Summary.Hardware.NumCpuPkgs
$hostCPUcore=$esxi.ExtensionData.Summary.Hardware.NumCpuCores/$hostCPU
$TotalCores += $esxi.ExtensionData.Summary.Hardware.NumCpuCores
$TotalSockets += $hostCPU
$obj = New-Object psobject
$obj | Add-Member -MemberType NoteProperty -Name Name -Value $esxi.Name
$obj | Add-Member -MemberType NoteProperty -name "Total CPU Sockets" -Value $hostCPU
$obj | Add-Member -MemberType NoteProperty -Name "Cores Per Socket" -Value $hostCPUcore
 $result += $obj
}


$result | export-csv .\ESXiHosts.csv


Write-host
write-host
Write-host "The Total number of CPU Cores is: $TotalCores"
Write-host
Write-host "The Total number of CPU Sockets is: $TotalSockets"
