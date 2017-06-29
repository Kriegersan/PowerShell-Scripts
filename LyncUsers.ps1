 $cred = Get-Credential

 invoke-command -computername leonard -credential $cred -authentication CredSSP -scriptblock {C:\users\iskrn1da\Desktop\Lync-Users.ps1}

 Write-host "Done!"

