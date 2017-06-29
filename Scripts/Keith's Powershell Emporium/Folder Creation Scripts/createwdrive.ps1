##### Requires PowerShell 3.0 or higher. #####


function CreateGroups{
    param($dfsroot,$foldername,$permission,$dc,$subou)
    write-host "Creating $permission Group"
    $groupname = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_$permission"
    $abegroup = "RES_ABEDFS_Data-"+$dfsroot
    # SET RIGHT PATH
    if($subou -ne ""){$oupath = "OU=" + $subou + ",OU=Security Groups,DC=me,DC=emh,DC=org"}else{$oupath = "OU=Security Groups,DC=me,DC=emh,DC=org"}
    new-adgroup -name $groupname -path $oupath -samAccountName $groupname -groupcategory 1 -groupscope 0 -description "Members have Read/Write access to the $foldername folder within the $dfsroot DFS Namespace"
    Add-ADGroupMember $abegroup $groupname 
    return $groupname
    
}
function CreateFolder{
    param($dfsroot,$foldername,$physroot)
    write-host "Creating Folder"
    $physpath = "$physroot\$foldername"
    $newdirectory = $physpath
    if(test-path $physpath){
        write-host "$physpath already exists"
    } else {
        write-host "$physpath doesn't exist, creating now.."
        new-item $newdirectory -type directory
    }
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
    param($foldername,$physpath,$dfsroot,$physroot)
    write-host "Adding to DFS"
    $physpath = "$physroot\$foldername"
    if($dfsroot -eq "Public"){$dfsroot = "Shared Data"}
    $dfspath = "\\me.emh.org\$dfsroot\$foldername"
    
    new-dfsnfolder -path $dfspath -TargetPath $physpath
    return $dfspath
}

function AddToABE{
    param($dfsroot,$foldername)
    write-host "Adding to ABE"
    $foldername = (Get-Culture).TextInfo.ToTitleCase("$foldername")
    $abefile = "\\dfs2a\c$\Program Files (x86)\EMHS\ABE-DFS\" + $dfsroot.ToUpper() + ".permissions"
    $rgroup = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_R"
    $rwgroup = "RES_DFS-"+$dfsroot+"_"+($foldername -replace '\s','')+"_RW"
    $addtofile = "[$foldername]`n$rgroup`n$rwgroup`n"
    add-content $abefile "[$foldername]`r`n$rgroup`r`n$rwgroup"

}

$folders = import-csv c:\temp\folders.csv

foreach($folder in $folders){

$dfsroot = $folder.dfsroot
$foldername = $folder.name

switch($dfsroot){
    CADean{$physroot = "\\pope\CADeanData";$dc="rodin";$subou="CADean";break}
    Mercy{$physroot = "\\nautilus\ShareData\$dfsroot";$dc="ritter";$subou="Mercy";break}
    SVH{$physroot = "\\shu\SVHData";$dc="rabel";$subou="SVH";break}
    EMHC{$physroot = "\\nautilus\ShareData\$dfsroot";$dc="rabel";$subou="EMHC";break}
    NECA{$physroot = "\\nautilus\ShareData\$dfsroot";$dc="rabel";$subou="NECA";break}
    VNA{$physroot = "\\meri\vnadata$";$dc="ramsden";$subou="VNA";break}
    EMHS{$physroot = "\\BGRFSCL04R01\ShareData\$dfsroot";$dc="ritter";$subou="";break}
    EMMC{$physroot = "\\BGRFSCL05R01\ShareData\$dfsroot"; $dc ="ritter";$subou="";break}
    default{$physroot="\\nautilus\ShareData\$dfsroot";$dc="ritter";$subou="";break}
}

$foldername = (Get-Culture).TextInfo.ToTitleCase("$foldername")

$rgroup = CreateGroups $dfsroot $foldername "R" $dc $subou
$rwgroup = CreateGroups $dfsroot $foldername "RW" $dc $subou

start-sleep -s 30

$physpath = CreateFolder $dfsroot $foldername $physroot

start-sleep -s 10

SetPermissions $physpath $rgroup "Read"
SetPermissions $physpath $rwgroup "Modify"

$dfspath = AddToDFS $foldername $physpath $dfsroot $physroot
$dfspathname = $dfspath.path

AddToABE $dfsroot $foldername

write-host "DONE!"

}
