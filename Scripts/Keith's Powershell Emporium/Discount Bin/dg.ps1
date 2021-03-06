#This script will take a list of employee IDs in a text file and add the corresponding users to the specified distribution group.  It must be run from the Exchange Management Shell and the W: drive must be mapped.

Param([string]$dg,[string]$file,[string]$remove)
 
#Check if dg and file are specified.  If not echo instructions and abort script. 
if (!$dg -or !$file){
write-host "`n`nUsage: dg.ps1 -dg `"groupname`" -file `"c:\temp\file.txt`" -remove yes`n
     -dg	Distribution group name, in quotes.  This is a required parameter.
     -file	Complete path to the text file containing employee IDs, in quotes.  Make sure each ID is it`'s own line.
                This is a required parameter.
     -remove	Use this option ONLY if you want to remove all group members before adding the new members.
                This is NOT a required parameter.`n`n"
break
}

#Check if the remove flag is set
if ($remove -eq "yes"){
Get-DistributionGroupMember -identity $dg | Remove-DistributionGroupMember -identity $dg -BypassSecurityGroupManagerCheck
}

#Get content of text file.
$empids = Get-Content $file

#Correlate employee IDs to userids from the nightly Lawson dump, add the userid to the specified distribution group, and output what's going on.
Import-Csv "W:\EMHS\Enterprise Infrastructure\Network Applications\Lawson Exports\e122p_one.csv" |% {if ($empids -contains $_.nbr){
Add-DistributionGroupMember -Identity $dg -Member $_.networkid -BypassSecurityGroupManagerCheck
write-host Adding $_.firstname $_.lastname
}}
