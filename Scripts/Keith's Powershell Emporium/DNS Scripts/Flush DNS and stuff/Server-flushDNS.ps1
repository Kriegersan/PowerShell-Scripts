# I do stuff.. and things by that I mean This script takes a text document and runs a loop over each server to flush DNS and Register DNS

#Will need DA creds for accessing the servers remotely

param(
  [Parameter(Position=0,mandatory=$true)]
  $list
)

$cred= (get-credential)

$servers = Get-Content $list

#This loop takes line by line from the Text file and Invokes WMI calls on each remote server
foreach ($server in $servers) {

Invoke-WmiMethod -class Win32_process -name Create -ArgumentList ("cmd.exe /c ipconfig /flushdns") -ComputerName $server -Credential $cred


}
