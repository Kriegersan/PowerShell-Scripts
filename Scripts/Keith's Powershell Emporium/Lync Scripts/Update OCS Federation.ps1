#You will need to call OCS-All.ps1 before iniating this script.

#$users = Get-WmiObject -Query "Select * from MSFT_SIPESUserSetting where LineURI like '%ext=5577%'"
$stream = [System.IO.StreamWriter] "c:\temp\nofederationusers2.txt"
#$users = Get-WmiObject -Query "Select * from MSFT_SIPESUserSetting where LineURI like '%ext=5577%' or LineURI like '%ext=4648%'"
$users = Get-WmiObject -Query "Select * from MSFT_SIPESUserSetting where  LineURI like '%ext=%' and EnabledForFederation = False"
foreach ($user in $users) {
$name = $user.DisplayName
$federation = $user.EnabledForFederation
write-host $name $federation
$tofile = "`"$name`",$federation"
$stream.WriteLine($tofile)

#$user.EnabledForFederation = "True"
#$user.Put() | out-null
}
$stream.close()