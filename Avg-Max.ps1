$BH1 = read-host "Enter CTX1"
$BH2 = read-host "Enter CTX2"
$BH3 = read-host "Enter CTX3"
$BH4 = read-host "Enter CTX4"
$BH5 = read-host "Enter CTX5"


Write-host "Finding the Average for BlueHill ..."
Start-Sleep -s 4

$tot = [int]$BH1 +[int]$BH2 +[int]$BH3 +[int]$BH4 +[int]$BH5
$avg = [int]$tot/5
Write-host "The Avg for BlueHill is: $avg"
 