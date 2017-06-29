cls
$dfsroot = "EMHS"
$foldername = (Get-Culture).TextInfo.ToTitleCase("something awesome")
$dfspath = "\\emhsd22301\c$\testfolder\test1"
$physpath = "\\emhsd22301\c$\testfolder\"+$foldername
$username = "admin\RES_DFS-EMHS_EnterpriseInfrastructure-NetworkApplications_RW"
$groupname = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_RW"
if(test-path $dfspath){
write-host "$dfspath does exist"
} else {
write-host "$dfspath doesn't exist"}

if(test-path $physpath){
write-host "$physpath does exist"
} else {
write-host "$physpath doesn't exist"
new-item $physpath -type directory

$acl = Get-Acl $physpath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$username","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
Set-Acl $physpath $acl
#Get-Acl $physpath  | Format-List 


}

#new-qadgroup -name $groupname -parentcontainer 'OU=New Mikes Testing OU,OU=EMHS GPO Testing,DC=me,DC=emh,DC=org' -samAccountName $groupname -grouptype 'Security' -groupscop 'DomainLocal' -description 'Group for stuff'
write-host "I would make the group $groupname"