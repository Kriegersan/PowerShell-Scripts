$stream = [System.IO.StreamWriter] "c:\temp\dnsentries.txt"
$searchip = "10.20.29.28"

$records = Get-WmiObject -ComputerName ritter.me.emh.org -namespace "root\microsoftdns"-class MICROSOFTDNS_ATYPE -filter "IPAddress='$searchip'" 
    foreach ($record in $records){
    if ($record.OwnerName -like "*emh*"){
                $ownername =  $record.OwnerName 
                $recorddata = $record.RecordData
                write-host $ownername $recorddata
                $tofile = "`"$ownername`",$recorddata"
                $stream.WriteLine($tofile)
                }}
                $stream.close()
                