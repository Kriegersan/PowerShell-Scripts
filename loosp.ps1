$IN = 12
$t = 0

while($IN -gt -1){
 $n = Read-Host "Enter number ctx"

 $t += [int]$n
 $IN - 1
}
Write-host "$t"