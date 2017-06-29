<#
This script Adds Computer accounts to the Security Group for Direct access via a CSV file that should be located in the c:\Temp\computers.csv 


#>

$Computers = Import-csv C:\Temp\computers.csv

Foreach($computer in $Computers) {
$PC = $computer.computer


write-host " "
write-host " "
Write-host "Please wait . . . Adding  $PC  to RES_APP-DirectAccess" 


start-sleep -s 3


Add-ADGroupMember -Identity "RES_APP-DirectAccess" -Members "$PC`$"

Write-Host "Done!"


}