$a = (netsh dhcp server 172.23.161.67 scope 172.23.156.0 show clients 1)

$lines = @()
#start by looking for lines where there is both IP and MAC present:
foreach ($i in $a){
    if ($i -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"){
        If ($i -match "[0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}"){    
            $lines += $i.Trim()
        }
    }
}
$csvfile = @()
#Trim the lines for uneeded stuff, leaving only IP, Subnet mask and hostname.
foreach ($l in $lines){
    $Row = "" | select Hostname,IP
    $l = $l -replace '[0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}', ''
    $l = $l -replace ' - ',','
    $l = $l -replace '\s{4,}',''
    $l = $l -replace '--','-'
    $l = $l -replace '-D-','-'
    $l = $l -replace '[-]{1}\d{2}[/]\d{2}[/]\d{4}',''
    $l = $l -replace '[-]{1}\d{2}[/]\d{1}[/]\d{4}',''
    $l = $l -replace '\d{1,2}[:]\d{2}[:]\d{2}',''
    $l = $l -replace 'AM',''
    $l = $l -replace 'PM',''
    $l = $l -replace '\s{1}',''
    $l = $l + "`n"
    $l = $l -replace '[,][-]',','
    $Row.IP = ($l.Split(","))[0]
    #Subnet mask not used, but maybe in a later version, so let's leave it in there:
    #$Row.SubNetMask = ($l.Split(","))[1]
    $Row.Hostname = ($l.Split(","))[2]
    $csvfile += $Row
    echo $row.Hostname
}