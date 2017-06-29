$printerName = Read-Host "Please enter printer name" 
write-host "`n"
Get-PrintJob -PrinterName $printerName

Write-Host "`n"

$printJobID = Read-Host "Enter Job ID you wish to remove(To clear entire Queue enter `"All`")"


write-host "`n"
write-host "Removing ID: $printJobID from $printerName Please wait . . ." 

Start-Sleep -s 4

if($printJobID -like "all"){Get-PrintJob -PrinterName $printerName | remove-printjob}

else {Remove-PrintJob -PrinterName $printerName -ID $printJobID}

write-host "`n"

Write-Host "Done!" 
