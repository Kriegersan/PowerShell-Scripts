$cred = Get-Credential

$BangorHubCAS = @('Campbell', 'Castro', 'Corozal', 'Crivitz', 'Hussey', 'Hutash')
$BangorMailBox = @('Mariko', 'Marina', 'Marius', 'Matara')

function CsPace($server)
{
    Invoke-Command $server -Credential $cred -ScriptBlock{
        Get-WmiObject -class win32_logicalDisk | ?{$_.DeviceID -eq 'C:'} | select SystemName,DeviceID, @{n='Free(GB)';e={[System.Math]::Round($_.FreeSpace/1GB)}}, @{n='Used(GB)';e={[System.Math]::Round(($_.Size - $_.FreeSpace)/1GB)}} | Format-Table -AutoSize
    }
}


function work($server)
{
  Invoke-Command $server -Credential $cred -ScriptBlock{
     $drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq '3'}
     foreach ($drive in $drives) 
     {
        $id = ($drive.DeviceID).Split("=")
        $sys = $drive.SystemName
        $total = $drive.FreeSpace / $drive.Size
        if ($total -lt .10)
        {
            "$Sys drive $id is at {0:P2}" -f $total 
        }
     }
  }
}

foreach ($server in $BangorMailBox) {work($server) }

foreach ($server in $BangorHubCAS) {CsPace($server)}