$erroractionpreference = "SilentlyContinue"
param($hostnames = $(get-content c:\temp\compnames.txt))
$hostnames | ForEach-Object {
    $ips = [System.Net.Dns]::GetHostAddresses($_)
    $obj = 1 | Select-Object Hostname,Address
    #$obj.hostname = $_
    $obj.Address = [string]::join(",",$ips)
    write-output $obj
    write-host $_.name
} | export-csv "c:\temp\exportedfile.csv" -notype