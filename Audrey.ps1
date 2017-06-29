$cred = Get-Credential 

enter-pssession -computername audrey -credential $cred -authentication credssp
