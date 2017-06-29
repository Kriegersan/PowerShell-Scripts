#Opt Vars



[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 5 ){
Write-host "1. PETA"
Write-host "2. PETAVIUS"
Write-host "3. INGRID"
Write-host "4. PRINZ"
write-host "5. Snowman"
[Int]$xMenuChoiceA = read-host "Please choose a print server . . . " }
Switch( $xMenuChoiceA ){
  1{$serverName = "PETA"}
  2{$serverName = "PETAVIUS"}
  3{$serverName = "INGRID"}
  4{$serverName = "PRINZ"}
  5{$serverName = "Snowman"}
default{$serverName = "PETA"}
}



$printDriver = "HP Universal Printing PCL 6 (v5.9.0)" 


###################################################################

#Imput Vars 

$printer = read-host "Please enter the Printer name"
$printerIP= read-host "Please enter the IP address of the printer"
$printerLoc = read-host "Please enter the location of the printer"

###################################################################



try
  {
   Add-PrinterPort -Name $printerIP -ComputerName $serverName -PrinterHostAddress $printerIP -ErrorAction Stop

  }
catch
  {
  Write-host "Unable to add printer port $printerIP, it may already exist or there my be a problem"
  Start-Sleep -Seconds 5
  exit
  
  }

try 
  {
    Add-Printer -DriverName $printDriver -Name $printer -ShareName $printer -PortName $printerIP -ComputerName $serverName -Location $printerLoc -Published -Shared -ErrorAction Stop
  }

catch 
  {
    write-host "There was a problem adding $printer to $serverName, please check the infor mation you added is correct. If it looks correct please contact support." 
    start-sleep -s 5
    exit

  }

  
    
Write-host "$printer has beeen added to $serverName, the share is \\$serverName\$printer" 
 