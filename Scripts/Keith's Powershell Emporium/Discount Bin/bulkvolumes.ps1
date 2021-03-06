# Set variables

# Group address
$GroupAddress = "192.168.63.254"

# User with permissions to create volumes
$GroupAdmin = "scriptadmin"

# Password for user
$GroupPass = "K1ll3rbeeS"

# Space delimited list of allowed networks
$NetworkList = "192.168.63.175"

# Size of volume in MB
$VolSize = "512000"

# Load Equallogic PowerShell extensions
import-module -name "c:\program files\EqualLogic2\bin\EqlPSTools.dll"

# Open session to SAN Group
Connect-EqlGroup -GroupAddress $GroupAddress -Username $GroupAdmin -Password $GroupPass

# Open file with volume names
$openfile = "c:\volumes.txt"

#Create each volume
foreach ($Volume in (Get-Content $openfile))
{
    New-EqlVolume -VolumeName $Volume -VolumeSizeMB $Volsize
# Set permissions on volume
    foreach ($Network in [regex]::split($NetworkList, ('\s')))
        {
            New-EqlVolumeACL -VolumeName $Volume -InitiatorIpAddress $Network -ACLTargetType volume_and_snapshot
        }
}