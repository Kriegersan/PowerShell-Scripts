$info = @()

function MailIt{
    param($output)
    $smtpServer = "exchange.me.emh.org"
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $msg.From = "EXCHANGEBOTOFREPORTINGDOOM@emh.org"
    $msg.To.Add("mstover@emh.org")
    $msg.Subject = "Stuff!"
    $msg.Body = "$output" -f(get-date)
    $smtp.Send($msg)
} 

# No-Refresh + Refresh (in Days)
Function GetDBs{
$dbs = Get-MailboxDatabase -Status | Sort-Object DatabaseSize -Descending
foreach ($db in $dbs){
    $drive = ([string]$db.edbfilepath).substring(0,2)
    $server = [string]$db.server
    $disk = Get-WMIObject Win32_LogicalDisk -computer $server -filter "DeviceID = '$drive'"
    $gbfree = [Math]::Round(($disk.freespace/1073741824),2)
    $Properties = @{Name=$db.Name; DatabaseSize=$db.DatabaseSize; AvailableNewMailboxSpace=$db.AvailableNewMailboxSpace; DiskFree=$gbfree}
    $Newobject = New-Object PSObject -Property $Properties
    $info += $Newobject
        }
    return $info
   
}

$output = GetDBs | format-table | out-string

MailIT($output)
