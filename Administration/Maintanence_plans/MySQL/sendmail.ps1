$EmailFrom = "karen.harutyunyan@arm.synisys.com" 
$EmailTo = "db-dba@arm.synisys.com"
$EmailBody = ""
$EmailSubject = "MySql maintanence report for sis2s019"
$Username = "karen.harutyunyan"
$Password = "rfhkbnj2409"

$CopyDir = "C:\perf\log\"

$Message = New-Object Net.Mail.MailMessage($EmailFrom, $EmailTo, $EmailSubject, $EmailBody)
Get-Childitem $CopyDir | WHERE {-NOT $_.PSIsContainer} | foreach{
$Attachment = New-Object Net.Mail.Attachment($_.fullname)
$Message.Attachments.Add($Attachment)
}
$SMTPClient = New-Object Net.Mail.SmtpClient("mail.arm.synisys.com", 25) #Port can be changed 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$SMTPClient.Send($Message)