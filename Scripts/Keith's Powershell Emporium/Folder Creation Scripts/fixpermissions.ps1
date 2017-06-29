function RemoveInheritance($path) {
    $isProtected = $true
    $preserveInheritance = $true
    write-host "Get ACL"
    $DirectorySecurity = Get-ACL $path
    $DirectorySecurity.SetAccessRuleProtection($isProtected, $preserveInheritance)
    write-host "Set ACL"
    Set-ACL $path -AclObject $DirectorySecurity
    $directorysecurity
}

function RemovePermissions($path) {
    $acl = Get-Acl $path
    
    $acl.Access | %{
     $acl
    $acl.RemoveAccessRule($_)
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
        }
    (Get-Item $path).SetAccessControl($acl)
}

function AddUserPermissions($path,$username){
    $acl = Get-Acl $path
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($username,"FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    $acl.setowner([System.Security.Principal.NTAccount]$username)
    (Get-Item $path).SetAccessControl($acl)
}

#(get-aduser mptas2 -Properties homedirectory).homedirectory.replace("mp-fileserver","meri")

$users = Get-ADUser -filter {homedirectory -like "*meri*"} -SearchBase "OU=Mercy,OU=Employee Accounts,OU=Accounts-User,DC=me,DC=emh,DC=org"  -Properties homedirectory

#$users = get-aduser MPMNW2 -Properties homedirectory
if (($users.homedirectory) -like "*meri*"){
foreach ($user in $users){
    $path = $user.homedirectory
    $username = $user.SamAccountName
    $path
    write-host "Removing Inheritance"
    removeinheritance $path
    write-host "Removing Permissions"
    RemovePermissions $Path
    write-host "Adding User Permissions"
    AddUserPermissions $path $username
    echo "$username,$path" >> c:\temp\fixmercy.csv

}
}