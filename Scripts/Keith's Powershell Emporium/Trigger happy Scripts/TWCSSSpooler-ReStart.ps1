$user = cat C:\Users\iskrn1da\User.txt
$pass = cat C:\users\iskrn1da\stuff.txt

$password = $Pass | ConvertTo-SecureString

$credential = New-Object System.Management.Automation.PSCredential ` -ArgumentList $user, $password

$date = "{0:MM-dd-yyyy--hh-mm-ss}" -f (Get-Date)

function SendMail
{  
  $time = Get-Date -Format G
  $from = "noreply@emhs.org"
  $to = @("krnelson@emhs.org", "tnadeau@emhs.org")
  $sub = "Allscripts Print Spoolers have been restarted: $time"
  $smtpsvr = "exchange.emh.org"
  $body = @"
    Hello!
    
    The Allscripts print server has encountered an error. The spoolers have automatically restarted.
    
    Jobs should be processing now. Attached is the error log that has triggered this script.
    
    Thanks!! 
     
    
    -MPMAEHRMCS02 (Admin)
"@
  Send-MailMessage -From $from -To $to -Subject $sub -Body $body -Credential $credential -SmtpServer $smtpsvr -Attachments "C:\Scripts\TEMP\Log-$date.txt"

}

function CleanUP
{
  Remove-Item -Path C:\Scripts\TEMP\*.txt | where {$_.creationTime -gt (get-date).adddays(-7)}
}

Get-Process -Name splwow64 | kill -Force


Get-Service -Name Spooler | Stop-Service 

Start-Sleep -Milliseconds 30

Get-Service -Name TWCSSSpooler | Restart-Service

Start-Sleep -Seconds 10

Get-Service -Name Spooler | Start-Service


Get-eventlog -LogName System -After (get-date).AddHours(-1) -EntryType Error | Select-Object -Property * | Out-File "C:\Scripts\TEMP\log-$date.txt"

SendMail


CleanUP