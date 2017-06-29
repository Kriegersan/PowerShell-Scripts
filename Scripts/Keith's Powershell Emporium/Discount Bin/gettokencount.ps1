#Param(
#    [Parameter(Mandatory=$True)]
#    [String]$Username
#)
$username = "admin\mercyclnwks"
$domain = ($username.split("\"))[0]
$user = ($username.split("\"))[1]
Import-Module ActiveDirectory
$rootdse = (Get-ADDomain $domain).distinguishedname
$server = (Get-ADDomain $domain).pdcemulator
$usergroups = Get-ADPrincipalGroupMembership -server $server $user | select distinguishedname,groupcategory,groupscope,name
$domainlocal = [int]@($usergroups | where {$_.groupscope -eq "DomainLocal"}).count
$global = [int]@($usergroups | where {$_.groupscope -eq "Global"}).count
$universaloutside = [int]@($usergroups | where {$_.distinguishedname -notlike "*$rootdse" -and $_.groupscope -eq "Universal"}).count
$universalinside = [int]@($usergroups | where {$_.distinguishedname -like "*$rootdse" -and $_.groupscope -eq "Universal"}).count
$tokensize = 1200 + (40 * ($domainlocal + $universaloutside)) + (8 * ($global + $universalinside))
Write-Host "
Domain local groups: $domainlocal
Global groups: $global
Universal groups outside the domain: $universaloutside
Universal groups inside the domain: $universalinside
Kerberos token size: $tokensize"