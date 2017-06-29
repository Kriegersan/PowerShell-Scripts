function CreateGroups{
    param($foldername,$permission)
    write-host "Creating $permission Group"
    $groupname = "RES_FTP_file.emh.org_"+($foldername -replace '\s','')+"_$permission"
    if ($permission -eq 'R')
    {
    $abegroup = "RES_FTP_file.emh.org"
    }
    else
    {
      $abegroup = "RES_FTP_file.emh.org_"+($foldername -replace '\s','')+"_R"
    }
    # SET RIGHT PATH
    $oupath = "OU=File Transfer,OU=Security Groups,DC=me,DC=emh,DC=org"
    new-adgroup -name $groupname -path $oupath -samAccountName $groupname -groupcategory Security -groupscope domainlocal -description "Members have Read/Write access to the $foldername folder within the file.emh.org"
    Add-ADGroupMember $abegroup $groupname
    return $groupname

}



write-host "Welcome to the SFTP Group Creator THingy Windows AD Group creation"
write-host " "
$fname = Read-host "Please Enter the Folder name"

$rgroup = CreateGroups $fname "R"
$rwgroup = CreateGroups $fname "RW"

write-host "$rgroup and $rwgroup has been created!! Now you can run the createsftp script on file.emh.org...Good luck!"
