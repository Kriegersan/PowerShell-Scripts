$computers = import-csv c:\temp\computers.csv
$dnsservers = "10.20.22.10","10.20.22.11"
foreach ($computer in $computers){
    $computername = $computer.ComputerName
    $nics = Get-WmiObject win32_networkadapterconfiguration -computer $computername -filter "ipenabled = 'true'"
    foreach ($nic in $nics){
        $nicname = $nic.description
        if($nic.SetDNSServerSearchOrder($dnsservers)){
            "$computername,$nicname,Successful" >> c:\temp\dnschangelog.csv
        } else {
            "$computername,$nicname,Failed" >> c:\temp\dnschangelog.csv
        }
    }
}