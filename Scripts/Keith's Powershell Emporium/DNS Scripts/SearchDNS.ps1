Get-WmiObject -ComputerName ritter.me.emh.org -namespace "root\microsoftdns"-class MICROSOFTDNS_ATYPE -filter "IPAddress='192.168.132.161'" |
    Sort OwnerName |
        % {
            New-Object PSObject -Property @{
                Name=$_.OwnerName 
                IP=$_.RecordData ;
                }
       }