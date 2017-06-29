# Secure Becon Folder Creation Wizard thingy of doom! Use at your own Risk! # 



$foldername = Read-host "Enter Folder Name"

$physPath = "\\CAMIRI\Fileshare$\$foldername"
$shhhh = "\\CAMPOS\Fileshare$\$foldername"


function CreateGroups{
    param($foldername,$permission)
    write-host "Creating $permission Group"
    $groupname = "RES_bhfileshare"+"_"+($foldername -replace '\s','')+"_$permission"
    $abegroup = "RES_ABEDFS_Data-EMHS-BeaconHealthLLC"
    # SET RIGHT PATH 
    $oupath = "OU=Beacon Health,OU=Security Groups,DC=me,DC=emh,DC=org"
    new-adgroup -name $groupname -path $oupath -samAccountName $groupname -groupcategory 1 -groupscope 0 -description "Members have Read/Write access to the $foldername folder within the $dfsroot DFS Namespace"
    Add-ADGroupMember $abegroup $groupname 
    return $groupname
}


function SetPermissions{
    param($physpath,$groupname,$permission)
    write-host "Setting Permissions"
        $acl = Get-Acl $physpath
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($groupname,$permission, "ContainerInherit, ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule)
        $acl.setowner([System.Security.Principal.NTAccount]'BUILTIN\Administrators')
        (Get-Item $physpath).SetAccessControl($acl)
}


function AddToDFS{
    param($foldername,$physpath)
    write-host "Adding to DFS"
    $dfspath = "\\me.emh.org\EMHS\Beacon Health LLC\$foldername"
    
    new-dfsnfolder -path $dfspath -TargetPath $physpath
    return $dfspath
}


#Main Program

New-Item -Path $physpath -ItemType Directory 

$rgroup = CreateGroups $foldername "R"
$rwgroup = CreateGroups $foldername "RW"

start-sleep -s 30


SetPermissions $physpath $rgroup "Read"
SetPermissions $physpath $rwgroup "Modify"

start-sleep -s 5

AddToDFS $foldername $physpath


Write-Host "Done!"