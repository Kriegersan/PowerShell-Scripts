#REmote Run on audrey 
$user = "admin\iskrn1da"
$password= cat C:\securestring.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $user, $password

invoke-command -ComputerName audrey -Credential $cred -Authentication CredSSP -ScriptBlock {C:\Users\iskrn1da\Desktop\copy.ps1}

Write-host "Done!"

