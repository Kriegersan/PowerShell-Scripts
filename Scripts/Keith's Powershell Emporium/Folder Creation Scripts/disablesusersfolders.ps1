$root = "C:\temp\"
$file = Import-Csv c:\temp\disabled.txt
foreach ($user in $file)
{
$dir = $root+$user.username
write-host $dir
$size = (get-childitem $dir -recurse | Measure-Object -property length -sum)
	write-host $dir $size.sum
            $sum = $size.sum
			"`"$dir`",$sum"  >> c:\temp\what.txt
	}
