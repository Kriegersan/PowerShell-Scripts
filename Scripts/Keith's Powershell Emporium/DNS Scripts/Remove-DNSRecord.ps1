# This script Removes DNS A Records

param(
$Zone,
$ServerName
)

if ($Zone -eq $null)
{
Remove-DnsServerResourceRecord -ZoneName 'me.emh.org' -Name $ServerName -RRType A
}
else
{
Remove-DnsServerResourceRecord -ZoneName $Zone -Name $ServerName -RRType A
}
