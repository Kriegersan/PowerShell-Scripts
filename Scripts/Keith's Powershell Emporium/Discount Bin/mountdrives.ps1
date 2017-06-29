$csv = Import-Csv c:\temp\volumes.txt

foreach ($line in $csv)
{
$dirname = $line.label
write-host $dirname
New-Item c:\IMPAX\$dirname -type directory
"sel disk $($line.disk)`r select partition $($line.partition)`r remove`r assign mount=C:\IMPAX\$($line.label)" | diskpart
}