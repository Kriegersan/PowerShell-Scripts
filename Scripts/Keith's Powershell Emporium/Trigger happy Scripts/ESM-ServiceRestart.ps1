$user = cat C:\Users\iskrn1da\User.txt
$pass = cat C:\Users\iskrn1da\stuff.txt

$name = hostname

$password = $Pass | ConvertTo-SecureString

$credential = New-Object System.Management.Automation.PSCredential ` -ArgumentList $user, $password

$date = "{0:MM-dd-yyyy--hh-mm-ss}" -f (Get-Date)

function SendMail
{
  $time = Get-Date -Format G
  $from = "noreply@emhs.org"
  $to = @("krnelson@emhs.org")
  $sub = "Centricity ESM Kryptiq service has been restarted: $time"
  $smtpsvr = "exchange.emh.org"
  $body = @"
    Hello!

    The EMS server has encountered an error. The Services have automatically restarted.

    Jobs should be processing now. Attached is the error log that has triggered this script.

    Thanks!!


    -$name (Admin)
"@
  Send-MailMessage -From $from -To $to -Subject $sub -Body $body -Credential $credential -SmtpServer $smtpsvr -Attachments "C:\Scripts\TEMP\Log-$date.txt"

}

function CleanUP
{
  Remove-Item -Path C:\Scripts\TEMP\*.txt | where {$_.creationTime -gt (get-date).adddays(-7)}
}

Restart-Service KEsmAgentSvc
start-sleep -seconds 10
Restart-Service KjsUpdateService2


Get-eventlog -LogName System -After (get-date).AddHours(-1) -EntryType Error | Select-Object -Property * | Out-File "C:\Scripts\TEMP\log-$date.txt"
get-service | ?{$_.DisplayName -like "*Kryptiq*" -or "*AppLife*"} | Out-File "C:\Scripts\TEMP\log-$date.txt" -append


SendMail


CleanUP
