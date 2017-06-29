
$user = cat C:\user.txt
$password= cat C:\securestring.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential ` -argumentlist $user, $password

function mailer($Body)
{
    $From = "noreply@emhs.org"
    $To = "krnelson@emhs.org"
    $sub = "Job reporting"
    $smtpSrv = "exchange.emh.org"
    Send-MailMessage -From $From -To $To -Subject $sub -Body $Body -Credential $cred -SmtpServer $smtpSrv
}

function SFTP
{
    start-job -Name "SCopy" -ScriptBlock {C:\Test\sftpCopy.ps1}

    Start-Sleep -Seconds 30

    $body = Receive-Job -Name "SCopy" -Keep | Out-String

    mailer($body)

    get-job -Name "SCopy"| Remove-Job

}


SFTP
