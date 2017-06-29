function CreateGroups{
    param($dfsroot,$foldername,$permission)

    $groupname = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_$permission"
    $abegroup = "RES_ABEDFS_Data-"+$dfsroot
    # SET RIGHT PATH
    new-adgroup -name $groupname -path 'OU=New Mikes Testing OU,OU=EMHS GPO Testing,DC=me,DC=emh,DC=org' -samAccountName $groupname -groupcategory 1 -groupscope 0 -description 'Members have Read/Write access to the $foldername folder within the $dfsroot DFS Namespace'
    Add-ADGroupMember $abegroup $groupname
    return $groupname
    
}
function CreateFolder{
    param($dfsroot,$foldername)
    $physpath = "\\nautilus\ShareData\$dfsroot\$foldername"
    if(test-path $physpath){
        write-host "$physpath does exist"
    } else {
        write-host "$physpath doesn't exist"
        new-item $physpath -type directory
    }
    return $physpath
}

function SetPermissions{
    param($physpath,$groupname,$permission)
        $acl = Get-Acl $physpath
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$groupname","$permission", "ContainerInherit, ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule)
        Set-Acl $physpath $acl
}

function AddToDFS{
    param($foldername,$physpath,$dfsroot)
    $dfspath = "\\me.emh.org\$dfsroot\$foldername"
    new-dfsnfolder -path $dfspath -TargetPath "$physpath"
    return $dfspath
}

function AddToABE{
    param($dfsroot,$foldername)
    
    $foldername = (Get-Culture).TextInfo.ToTitleCase("take me to funkytown")
    $abefile = "\\moe\c$\Program Files (x86)\EMHS\ABE-DFS\" + $dfsroot.ToUpper() + ".permissions"
    $rgroup = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_R"
    $rwgroup = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_RW"
    echo "[$foldername]" $rgroup $rwgroup >> $abefile

}

$dfsroot = "EMHS"
$foldername = "CIS Server Benchmark Baselines"
$foldername = (Get-Culture).TextInfo.ToTitleCase("$foldername")

$rgroup = CreateGroups $dfsroot $foldername "R"
$rwgroup = CreateGroups $dfsroot $foldername "RW"

$physpath = CreateFolder $dfsroot $foldername
SetPermissions $physpath $rgroup "Read"
SetPermissions $physpath $rwgroup "Modify"

$dfspath = AddToDFS $foldername $physpath $dfsroot

AddToABE $dfsroot $foldername
SetPermissions = 