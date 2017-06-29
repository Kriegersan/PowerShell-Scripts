$username =  Read-Host "Enter Domain Admin username"
$password = Read-Host "Enter Password"
$pass = $password | ConvertTo-SecureString

$credential = New-Object -TypeName System.Management.Automation.PSCredential ` -ArgumentList $username, $pass


function get-CitrixPrintService($servers)
{
    Invoke-Command -ComputerName $servers -Credential $credential -ScriptBlock{get-service cpsvc} | sort PSCOmputerName| ft -GroupBy PSComputerName

}


function EMMC {

$servers = @('EMMC-CTX1',
'EMMC-CTX2',
'EMMC-CTX3',
'EMMC-CTX4',
'EMMC-CTX5',
'EMMC-CTX6',
'EMMC-CTX7',
'EMMC-CTX8',
'EMMC-CTX9',
'EMMC-CTX10',
'EMMC-CTX11',
'EMMC-CTX12',
'EMMC-CTX13',
'EMMC-CTX14',
'EMMC-CTX15'
)

 get-CitrixPrintService($servers)

 }


function TAMC {
$servers = @('TAMC-CTX1' ,'TAMC-CTX2' ,'TAMC-CTX3' ,'TAMC-CTX4' ,'TAMC-CTX5' ,'TAMC-CTX6')

get-CitrixPrintService($servers)

}

function SVH {
$servers = @('SVH-CTX1', 'SVH-CTX2', 'SVH-CTX3')

get-CitrixPrintService($servers)

}

function BHMH {
$servers = @('BH-CTX1', 'BH-CTX2', 'BH-CTX3', 'BH-CTX4', 'BH-CTX5')

get-CitrixPrintService($servers)
}

function CADean {
$servers = @('CADEAN-CTX1', 'CADEAN-CTX2', 'CADEAN-CTX3', 'CADEAN-CTX4')

get-CitrixPrintService($servers)

}

function Inland {
$servers = @('Inland-CTX1',
'Inland-CTX2',
'Inland-CTX3',
'Inland-CTX4',
'Inland-CTX5',
'Inland-CTX6',
'Inland-CTX7',
'Inland-CTX8',
'Inland-CTX9',
'Inland-CTX10',
'Inland-CTX11',
'Inland-CTX12')

get-CitrixPrintService($servers)

}

function NECA {
$servers = @('NECA-CTX1', 'NECA-CTX2', 'NECA-CTX3', 'NECA-CTX4', 'NECA-CTX5', 'NECA-CTX6', 'NECA-CTX7')

get-CitrixPrintService($servers)

}

function menu{
clear

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 8 ){
write-host "Select Service Site"
Write-host "1. Blue Hill"
Write-host "2. CA Dean"
Write-host "3. EMMC"
Write-host "4. Inland"
Write-host "5. NECA"
Write-host "6. SVH"
Write-host "7. TAMC"
Write-host "8. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 8..." }
Switch( $xMenuChoiceA ){
  1{BHMH}
  2{CADean}
  3{EMMC}
  4{Inland}
  5{NECA}
  6{SVH}
  7{TAMC}
  8{exit}
default{exit}
}
}

Menu
