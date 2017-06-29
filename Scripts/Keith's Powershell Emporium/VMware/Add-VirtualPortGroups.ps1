#This script bulk adds Virtual Portgroups to one Standard vSwitch2

<#
This refers to a CSV file located on your local Desktop

if you are copying ports over from another host you can use this command to export the port groups to a csv
Get-VirtualPortGroup -VMHost Someserver.me.emh.org | select Name, VirtualSwitch, VLanId | export-csv C:\Tmp\PGroups.csv

#>
$portGroups = import-csv C:\Tmp\PGroups.csv

$server = 'Basho.me.emh.org' #Here is where we can modify what server we are pointing too.. May want to setup Parameters??
$Data = Get-VirtualSwitch -VMHost $server -Name vSwitch2 # Here we are getting the info for the virtual switch that we are going to be adding all the ports too
#again consideration of setting this to a parameter?

#Finally Right!? The fun stuff!
foreach ($pGroup in $portGroups) # taking eache line from The CSV and putting them in to Vars.
{
$vLanID = $pGroup.VLanId
$vName = $pGroup.name

#The Command we have been building up, This adds the portgroup with the VlanID to the switch Neat!
New-VirtualPortGroup -VirtualSwitch $Data -Name $vName -VLanId $vLanID

}


<#
This Script is still under development, feel free to make changes as seen
#>


#Created By Keith Nelson
#made possible by Viewers like you
