$stream = [System.IO.StreamWriter] "c:\temp\mydocssizes.txt"
$root = "J:\UserData_EMMC\"
#$dirs = (gci $root -recurse)
$dirs = (dir $root | ? { $_.psiscontainer } | select fullname, name, lastwritetime)
foreach ($dir in $dirs){
#	$user = $dir.fullname.trimstart($root)
	$user = $dir.name
	write-host $dir.fullname
#	write-host $root
#	write-host $user
		if ($user -like "a*"){
			$path =  $dir.fullname
			$pathsize =  (gci $dir.fullname -recurse | measure-object Length -sum).Sum
			write-host $path
			$mymusic = $dir.fullname + "\My Documents\My Music"
				if (test-path $mymusic){
					$mymusicsize = (gci $mymusic -recurse | measure-object Length -sum).Sum
				}else{
					$mymusicsize = "NA"
				}
			$tofile = "`"$path`",$pathsize,$mymusicsize,`"$mymusicsize`""
			$stream.WriteLine($tofile)
		} else {
			break
		}
	}
$stream.close()