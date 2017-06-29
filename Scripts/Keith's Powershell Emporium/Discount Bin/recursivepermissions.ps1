function SetPermissions{
    param($physpath,$groupname,$permission)
        $acl = Get-Acl $physpath
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($groupname,$permission, "ContainerInherit, ObjectInherit", "None", "Allow")
        $rule
        $acl.AddAccessRule($rule)
        #$acl.setowner([System.Security.Principal.NTAccount]'BUILTIN\Administrators')
        (Get-Item $physpath).SetAccessControl($acl)
}

function AddToABE{
    param($dfsroot,$foldername)
    $foldername = (Get-Culture).TextInfo.ToTitleCase("$foldername")
    $abefile = "\\dfs2a\c$\Program Files (x86)\EMHS\ABE-DFS\" + $dfsroot.ToUpper() + ".permissions"
    $rgroup = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_R"
    $rwgroup = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_RW"
    $addtofile = "[$foldername]`n$rgroup`n$rwgroup`n"
    add-content $abefile "[$foldername]`r`n$rgroup`r`n$rwgroup"

}

$rwgroup = "RES_DFS-Public_Projects_RW"

$folders = Get-ChildItem "W:\Shared Data\Projects"
foreach ($folder in $folders){
$foldername = $folder.Name
$physpath = "w:\Shared Data\Projects\$foldername"
echo $physpath
#SetPermissions $physpath $rgroup "Read"
SetPermissions $physpath $rwgroup "Modify"
#AddToABE $dfsroot $foldername
}