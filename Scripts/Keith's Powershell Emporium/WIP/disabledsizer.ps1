$root = "J:\UserData_EMMC\"
$file = Import-Csv c:\temp\disabledusers.txt
foreach ($user in $file)
{
write-host $user.username
$dir = $root+$user.username
$size = (get-childitem $dir -recurse | Measure-Object -property length -sum)
	write-host $dir $size.sum
			$sum = $size.sum
			"`"$dir`",$sum" >> sizes.txt
	}
