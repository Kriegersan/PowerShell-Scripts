#Example: How to change any A record pointing to 169.255.255.253 to 169.255.255.255 for all zones

Get-WmiObject -ComputerName miranda -namespace "root\microsoftdns"-class MICROSOFTDNS_ATYPE -filter "IPAddress='172.23.128.119'" | foreach-object{$_.modify($null,"10.20.21.192")}