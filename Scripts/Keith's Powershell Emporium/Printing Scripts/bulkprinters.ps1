$printerdriver = "PCL6 Driver for Universal Print"
$servername = "PETA"
$printers = import-csv C:\temp\printers.csv
foreach($printer in $printers){
	$printername = $printer.name

	$ip = $printer.ip
	$location = $printer.location


	$addport = Add-PrinterPort -Name $ip -ComputerName $servername -PrinterHostAddress $ip
	if (!$addport){write-host "Unable to add printer port $ip, it may already exist or there may be a problem."}
	$addprinter = Add-Printer -DriverName $printerdriver -Name $printername -Shared -ShareName $printername -PortName $ip -ComputerName $servername -location $location -Published
	if (get-printer -computername $servername -name $printername) {
		write-host "$printername has been added to $servername, the share is \\$servername\$printername"
	} else {
		write-host "There was a problem adding $printername to $servername, please check that the information you added is correct.  If the information looks correct please contact support."
	}
}