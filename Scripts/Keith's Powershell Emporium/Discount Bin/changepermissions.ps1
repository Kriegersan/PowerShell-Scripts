#Change ACLs on all directories listed in c:\temp\folders.txt

$username = "tempuser"

$openfile = "c:\temp\folders.txt"

foreach ($folder in (Get-Content $openfile))
{
$acl = Get-Acl $folder
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$username","FullControl", "ContainerInherit, ObjectInherit", "None", "Deny")
$acl.AddAccessRule($rule)
Set-Acl $folder $acl
Get-Acl $folder  | Format-List 
}