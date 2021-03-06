# Make and Mount Snapshot

param($DBServerName,$VolumeName,$database)
$PortalAddress = "192.168.63.10"
$PortalPort = "3260"
$PortalAdmin = "scriptadmin"
$PortalPass = "K1ll3rbeeS"
$Iniator = "ROOT\ISCSIPRT\0000_0"
$LogFileDir = "c:\Backup_Scripts\log\"
$LogFileName = $logfiledir + $dbservername + "_" + "{0:yyyyMMdd}.txt" -f(get-date)
$LogTime = '"{0:HH:mm:ss}" -f(get-date)'
$oracleconsole = "OracleDBConsole" + $database
$oracleservice = "OracleService" + $database

function LogIt{
    param($log)
    $Logout = ("{0:HH:mm:ss}" -f(get-date))+" "+$log
    $Logout | out-file -append $LogFileName
    }
    
function MailIt{
    $emailFrom = "centricitybackupscript@emh.org"
    $emailTo = "mstover@emh.org"
    $subject = "Script Failed for $dbservername"
    $body = "An error has occured in the backup script for $dbservername at {0:yyyyMMdd}.  Please check $logfilename for details." -f(get-date)
    $smtpServer = "exchange.me.emh.org"
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $smtp.Send($emailFrom, $emailTo, $subject, $body)
}    

function DisconnectSAN{
Disconnect-EqlGroup -GroupAddress $PortalAddress
LogIt -log "Connection Closed to $PortalAddress"
}
    
trap{LogIt "ERROR: $error[0].Exception.Message";MailIt;DisconnectSAN;Break;}    
    
function StopService{
    param($ServiceName)
    $arrService = Get-Service -computername $dbservername -Name $ServiceName
    LogIt -log "Stopping $ServiceName on $dbservername"
    if ($arrService.Status -ne "Stopped"){
        Get-WmiObject -Class Win32_Service -Filter "name='$ServiceName'" -ComputerName $dbservername | Invoke-WmiMethod -Name StopService
        $arrService.WaitForStatus('Stopped',(new-timespan -seconds 600))
        LogIt -log "$ServiceName Stopped"
    } else {
        LogIt -log "$ServiceName Already Stopped"
    }
}

LogIt -log "Beginning Pre-Backup Script for $dbservername"

# Load Equallogic PowerShell extensions
import-module -name "c:\program files\EqualLogic\bin\EqlPSTools.dll"

# Open session to SAN Group
Connect-EqlGroup -GroupAddress $PortalAddress -Username $PortalAdmin -Password $PortalPass
LogIt -log "Connection Established to $PortalAddress"

# Clear list of targets and snapshot names
Out-File c:\Backup_Scripts\temp\targets.txt
Out-File c:\Backup_Scripts\temp\ssnames.txt

StopService -ServiceName $oracleconsole
StopService -ServiceName $oracleservice

# Attempt to create new snapsot and set online
    if (New-EqlSnapshot -GroupAddress $PortalAddress -VolumeName $VolumeName -OnlineStatus online){
    # Get IQN of most resent snapshot
    $Snaps = Get-EqlSnapshot -GroupAddress $PortalAddress -VolumeName $VolumeName
    $iqn = $Snaps.ISCSITargetName
    $ssname = $Snaps.SnapshotName
    $ssname | Out-File -Append c:\Backup_Scripts\temp\ssnames.txt
    $iqn | Out-File -Append c:\Backup_Scripts\temp\targets.txt
    LogIt -log "Snapshot $ssname Created for $VolumeName"

    #Refresh Portal Info
    $command = "iscsicli.exe RefreshTargetPortal $PortalAddress $PortalPort"
    invoke-expression -Command $command

    #Login to Target
    $command = "iscsicli.exe LoginTarget $IQN T $Initiator $PortalAddress $PortalPort * * * * * * * * * * * * * 0"
    invoke-expression -Command $command
    LogIt -log "Snapshot $ssname Mounted"
    } else {
    throw "Snapshot Failed aborting script - "
    }
# Allow time for drive letter mapping before returning to backup
start-sleep 30

# Close Session to SAN Group
DisconnectSAN
LogIt -log "Ending Pre-Backup Script for $dbservername"