$cred = Get-Credential
$Servers = @('MPMAEHRMCS01',
'MPMAEHRMCS02',
'MPMAEHRMCS03',
'MPMAEHRMCS04',
'MPMAEHRMCS05',
'MPMAEHRWEB01',
'MPMAEHRWEB02',
'MPMAEHRWEB03',
'MPMAEHRWEB04',
'MPMAEHRWEB05',
'MPMAEHRWEB06',
'MPMAEHRWEB07',
'MPMAEHRWEB08',
'MP-ENTEHR04',
'MP-ENTEHR03'
)

function StopAV($server){

Invoke-command -ComputerName $server -Credential $cred -ScriptBlock{
cd "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\"
.\smc.exe -stop
Start-Sleep -Seconds 10

#if((Get-service -Name "SMC*") -eq 'Running'){
##}
#else{
#   write-host "$Server does not have SMC service"
}
}

foreach ($server in $Servers) {StopAV($server)}