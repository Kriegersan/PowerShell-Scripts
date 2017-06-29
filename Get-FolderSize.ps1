Function Get-FolderSize

{

 BEGIN{$fso = New-Object -comobject Scripting.FileSystemObject}

 PROCESS{

    $path = $input.fullname

    $folder = $fso.GetFolder($path)

    $size = $folder.size

    [PSCustomObject]@{'Name' = $path;'Size' = ($size / 1gb) } } }