#This script will get the following attributes for any mailbox accounts on the servers designated: MailboxDisplayName, StorageGroupName, ServerName, StoreName, Size, DateDiscoveredAbsentInDS, TotalItems, DeletedMessageSizeExtended, LastLogonTime
#For more information on other possible attributes go to http://msdn.microsoft.com/en-us/library/aa143732(v=exchg.65).aspx
#Script created and maintained by Mike Stover

$day = Get-Date -UFormat "%Y%m%d"
 
$computers = "brunner","elinor","espin","mackin","makola","namiko","valier"

foreach ($computer in $computers) {
  Get-Wmiobject -namespace root\MicrosoftExchangeV2 -class Exchange_Mailbox -computer $computer | sort-object -desc MailboxDisplayName | select-object MailboxDisplayName,StorageGroupName,ServerName,StoreName,Size,DateDiscoveredAbsentInDS,TotalItems,DeletedMessageSizeExtended,LastLogonTime | Export-CSV -Path c:\temp\$computer-$day.csv 
}
