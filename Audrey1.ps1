$user = "admin\iskrn1da"
$password= cat C:\securestring.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential `
         -argumentlist $user, $password


new-pssession -computername audrey -credential $cred -authentication CredSSP 

