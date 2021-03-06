$servers = "espin"
$origin = "AFFILIATED DB1"
$destination = "DB07"
$destserver = "marius"
$size = "100000"
#$displayname = "Espin, Affiliated DB1 Test"
$logsize = "8"
foreach ($server in $servers) {
    $mailboxes = Get-Wmiobject -namespace root\MicrosoftExchangeV2 -class Exchange_Mailbox -computer $server -filter "StoreName='$origin' and size <= '$size'"
    # and mailboxdisplayname='$displayname'" 
    foreach ($mailbox in $mailboxes){
        write-host "Right now I'd be moving" $mailbox.mailboxdisplayname to $destination
        $disk = Get-WMIObject Win32_LogicalDisk -computer $destserver -filter "DeviceID = 'L:'"
        $gbfree = [Math]::Round($disk.freespace/1073741824)
        if ($gbfree -le $logsize) {
            write-host "Oh no!" $gbfree "gigabytes left on $destserver!"
            exit
        }else{
            write-host "It's all good" $gbfree "gigabytes left on $destserver!"
        }
    }
}