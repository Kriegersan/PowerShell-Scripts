$csv = Import-Csv c:\temp\volumes.txt

foreach ($line in $csv)
{
$dirname = $line.label
write-host $dirname
New-Item c:\IMPAX\$dirname -type directory
"sel disk $($line.disk)`r create partition primary size=512000`r assign mount=C:\IMPAX\$($line.label)`r format FS=NTFS LABEL=`"$($line.label)`" QUICK" | diskpart
}