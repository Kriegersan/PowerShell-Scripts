$ErrorActionPreference = "SilentlyContinue"
$leases = get-dhcpserverv4lease -computername 'hermes' -scopeid "10.20.129.0"
$count = 0
$removed = 0
foreach($lease in $leases){
    $ip = $lease.IPAddress
    if(!(test-connection $ip -count 1)){
        write-host "$ip is not in use"
        Remove-DhcpServerv4Lease -IPAddress $ip -computername 'hermes'
        $removed++
    } else {
        write-host "$ip is in use"
    }
$count++
}
write-host "Removed $removed out of $count"