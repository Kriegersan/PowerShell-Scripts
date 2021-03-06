#You will need to call OCS-All.ps1 before iniating this script.

#$users = Get-WmiObject -Query "Select * from MSFT_SIPESUserSetting where LineURI like '%ext=5577%'"
$stream = [System.IO.StreamWriter] "c:\temp\ocsusers.txt"
#$users = Get-WmiObject -Query "Select * from MSFT_SIPESUserSetting where LineURI like '%ext=5577%' or LineURI like '%ext=4648%'"
$users = Get-WmiObject -Query "Select * from MSFT_SIPESUserSetting where LineURI like '%ext=%' and LineURI like 'tel:+973%'"
foreach ($user in $users) {
$uri = $user.LineURI
$pos = $uri.IndexOf(";")
$leftPart = $uri.Substring(0, $pos)
$newext = $leftpart.substring($leftpart.length-5)
$newuri = "$leftpart;ext=$newext"
$name = $user.DisplayName
write-host $name $uri $newuri
$tofile = "`"$name`",$uri,$newuri"
$stream.WriteLine($tofile)

$user.LineURI = $newuri
$user.Put() | out-null
}
$stream.close()