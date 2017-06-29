$stream = [System.IO.StreamWriter] "c:\temp\mydocssizes.txt"
$root = "C:\temp\"
$file = Import-Csv c:\temp\disabled.txt
foreach ($user in $file)
{
$dir = $root+$user.username
write-host $dir
$size = (get-childitem $dir -recurse | Measure-Object -property length -sum)
#foreach ($dir in $dirs){
#	$user = $dir.name
	write-host $dir $size.sum
#			$path =  $dir.fullname
#			$pathsize =  (gci $dir.fullname -recurse | measure-object Length -sum).Sum
#			write-host $path
			$tofile = "`"$dir`",$size.sum"
			$stream.WriteLine($tofile)
	}
#}
$stream.close()