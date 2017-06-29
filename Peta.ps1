$cred = Get-Credential
Enter-PSSession -Computername Peta -Credential $cred -Authentication Credssp