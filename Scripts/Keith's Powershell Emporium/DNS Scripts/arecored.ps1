#This script creates a DNS A recorded 

param(
	$zone,
	$name,
	$ip
)



Add-DnsServerResourceRecord -ZoneName $zone -Name $name -IPv4Address $ip -A


write-host "The $name $zone has been created"
