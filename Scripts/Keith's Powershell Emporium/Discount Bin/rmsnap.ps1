#Remove Snapshot
param($DBServerName,$VolumeName)
$PortalAddress = "192.168.63.10"
$PortalPort = "3260"
$PortalAdmin = "scriptadmin"
$PortalPass = "K1ll3rbeeS"
$logfiledir = "c:\Backup_Scripts\log\"
$logfilename = $logfiledir + $dbservername + "_" + "{0:yyyyMMdd}.txt" -f(get-date)
$logtime = '"{0:HH:mm:ss}" -f(get-date)'

function LogIt{
    param($log)
    $logout = ("{0:HH:mm:ss}" -f(get-date))+" "+$log
    $logout | out-file -append $logfilename
    }
    
function MailIt{
    $emailFrom = "centricitybackupscript@emh.org"
    $emailTo = "#PPSNotify@emh.org"
    $subject = "Script Failed for $dbservername"
    $body = "An error has occured in the backup script for $dbservername at {0:HH:mm:ss}.  Please check $logfilename for details." -f(get-date)
    $smtpServer = "exchange.me.emh.org"
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $smtp.Send($emailFrom, $emailTo, $subject, $body)
}    
    
trap{LogIt "ERROR: $error[0].Exception.Message";MailIt;Break;}

LogIt -log "Beginning Post-Backup Script for $dbservername" 
   
# Load Equallogic PowerShell extensions
import-module -name "c:\program files\EqualLogic\bin\EqlPSTools.dll"

# Take Disks offline
LogIt -log "Taking Disk Offline"
$iscsiSsn = gwmi -namespace "root\wmi" -class MSiSCSIInitiator_SessionClass
$targets = Get-Content c:\Backup_Scripts\temp\targets.txt
foreach($target in $targets)
{

for($i=0; $i -le $iscsiSsn.length - 1; $i++)
{
	if ($iscsiSsn[$i].targetname -eq $target)
	{
		$disknum = $iscsiSsn[$i].devices[0].deviceNumber
		# Skip duplicates
		if ($disknum -ne $savenum)
	       	{
$command = @"
select disk $disknum
offline disk
"@
$command | diskpart
		}
		$savenum = $disknum
	}
}
}

# Remove iscsi Sessions
LogIt -log "Removing iSCSI Sessions"
foreach($target in $targets)
{

		if ($iscsiSsn.targetname -eq $target)
		{
			iscsicli LogoutTarget $iscsiSsn.SessionID
		}

}

# Delete Snapshots from SAN

Connect-EqlGroup -GroupAddress $PortalAddress -Username $PortalAdmin -Password $PortalPass
LogIt -log "Connection Established to $PortalAddress"
$snapshots = Get-Content c:\Backup_Scripts\temp\ssnames.txt
LogIt -log "Deleting $snapshots from $PortalAddress"
	Set-eqlSnapshot -GroupAddress $PortalAddress -VolumeName $VolumeName -SnapshotName $snapshots -OnlineStatus offline
	Remove-eqlSnapshot -GroupAddress $PortalAddress -VolumeName $VolumeName -SnapshotName $snapshots
    
Disconnect-EqlGroup -GroupAddress $PortalAddress
LogIt -log "Connection Closed to $PortalAddress"
LogIt -log "Ending Post-Backup Script for $dbservername"
Out-File c:\Backup_Scripts\temp\targets.txt
Out-File c:\Backup_Scripts\temp\ssnames.txt