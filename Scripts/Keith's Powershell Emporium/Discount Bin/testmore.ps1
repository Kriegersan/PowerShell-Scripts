Function GetDBs{
$dbs = Get-MailboxDatabase -identity db01 -Status | Sort-Object DatabaseSize -Descending
foreach ($db in $dbs){
    $Properties = @{Name=$db.Name; DatabaseSize=$db.DatabaseSize; AvailableNewMailboxSpace=$db.AvailableNewMailboxSpace}
    $Newobject = New-Object PSObject -Property $Properties
    $info += $Newobject
    }
    return $info
}

$output = GetDBs | format-table | out-string