# Delete-PublicFolderItems.ps1
# This script requires PowerShell 2.0 and .NET Framework 3.5. 
# 
# Before you use this script,
# MAKE SURE THAT YOU READ THROUGH IT COMPLETELY
# MAKE SURE TO MODIFY THE $item.Subject.Contains VALUE
# MAKE SURE THAT YOU TEST IT IN A TEST ENVIRONMENT AND THAT YOU HAVE A BACKUP
#
# Syntax: 
# 
# .\Delete-PublicFolderItems <email address for autodiscover> <path to folder> <recurse> 
# 
# Examples: 
# 
# .\Delete-PublicFolderItems administrator@contoso.com \TopLevelFolder\Subfolder $false 
# This example runs against one specific folder and does not recurse. 
# 
# .\Delete-PublicFolderItems administrator@contoso.com "" $true 
# This example recursively runs against every folder in the PF hierarchy.
#
# The e-mail address you specify should typically be the email address of the administrator account 
# that you have used to log on as. Otherwise, you may receive Autodiscover errors.
 
param([string]$autoDiscoverEmail, [string]$folderPath, [bool]$recurse)
 
# Remember to install the EWS managed API from the following location: 
# http://www.microsoft.com/downloads/en/details.aspx?displaylang=en&FamilyID=c3342fb3-fbcc-4127-becf-872c746840e1 
# 
# Then point the following command to the location of the DLL:
 
Import-Module -Name "C:\Program Files\Microsoft\Exchange\Web Services\1.0\Microsoft.Exchange.WebServices.dll"
 
# If the $readOnly variable is set to $true, the script runs in READ-ONLY mode. The script reports on the items that would be deleted.
# However, the script does not delete any items. 
# 
# If the $readOnly variable is set to $false, the script will DELETE ITEMS OUT OF THE PUBLIC FOLDERS. 
# Make sure you test this first and that you have a backup of the public folder(s).
 
$readOnly = $true
 
# Use AutoDiscover to get the ExchangeService object
 
$exchService = new-object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2010_SP1) 
if ($exchService -eq $null) 
{ 
    "Could not instantiate ExchangeService object." 
    return 
} 
$exchService.UseDefaultCredentials = $true 
$exchService.AutodiscoverUrl($autoDiscoverEmail) 
if ($exchService.Url -eq $null) 
{ 
    return 
}
 
# Bind to the public folders
 
$pfs = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($exchService, [Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::PublicFoldersRoot) 
if ($pfs -eq $null) 
{ 
    return 
}
 
# Define the function that will be called to process the folders.
 
function DoFolder([Microsoft.Exchange.WebServices.Data.Folder]$folder, [string]$path) 
{ 
    ("Scanning folder: " + $path) 
    
     try 
     { 
        # Scan the items in this folder 
        $offset = 0; 
        $view = new-object Microsoft.Exchange.WebServices.Data.ItemView(100, $offset) 
        while (($results = $folder.FindItems($view)).Items.Count -gt 0) 
        { 
            foreach ($item in $results) 
            { 
                ############################################################ 
                # This is the most important part. This is where the script
                # determines whether to delete the item or not. 
                # 
                # By default the script will delete any item that contains 
                # the phrase "Here you have" in the subject. If this is not 
                # what you want, you must edit the criteria. 
                if ($item.Subject.Contains("Here you have")) 
                { 
                    if ($readOnly) 
                    { 
                        ("    Would have deleted item: " + $item.Subject) 
                    } 
                    else 
                    { 
                        ("    Deleting item: " + $item.Subject) 
                        $item.Delete([Microsoft.Exchange.WebServices.Data.DeleteMode]::HardDelete) 
                    } 
                } 
                # 
                ############################################################ 
            } 

            $offset += $results.Items.Count 
            $view = new-object Microsoft.Exchange.WebServices.Data.ItemView(100, $offset) 
        }
 
        if ($recurse) 
        { 
            # Recursively do subfolders 
            $folderView = new-object Microsoft.Exchange.WebServices.Data.FolderView(2147483647) 
            $subfolders = $folder.FindFolders($folderView)    
            foreach ($subfolder in $subfolders) 
            { 
                try 
                { 
                    DoFolder $subfolder ($path + "\" + $subfolder.DisplayName) 
                } 
                catch { "Error processing folder: " + $subfolder.DisplayName } 
            } 
        } 
     } 
     catch 
     { 
         throw 
     } 
}
 
# Call DoFolder on the top folder. 
# If $recurse is true, it will recursively call itself.
 
if ($folderPath.Length -lt 1) 
{ 
    DoFolder $pfs "" 
} 
else 
{ 
    $folderPathTrim = $folderPath.Trim("\") 
    $folderPathSplit = $folderPathTrim.Split("\") 
    $tinyView = new-object Microsoft.Exchange.WebServices.Data.FolderView(2) 
    $displayNameProperty = [Microsoft.Exchange.WebServices.Data.FolderSchema]::DisplayName 
    $thisFolder = $pfs 
    for ($x = 0; $x -lt $folderPathSplit.Length; $x++) 
    { 
        $filter = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+IsEqualTo($displayNameProperty, $folderPathSplit[$x]) 
        $results = $thisFolder.FindFolders($filter, $tinyView) 
        if ($results.TotalCount -gt 1) 
        { 
            "Ambiguous folder name." 
            return 
        } 
        elseif ($results.TotalCount -lt 1) 
        { 
            "Folder not found." 
            return 
        } 
        $thisFolder = $results.Folders[0] 
    } 
    
    DoFolder $thisFolder $folderPath 
}
 
# When we return here, we're done!
 
"Done!"