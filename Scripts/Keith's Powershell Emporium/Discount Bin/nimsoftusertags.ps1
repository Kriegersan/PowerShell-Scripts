#Mass change of Nimsoft usertags

function FindPath {
    param($ServerName)
    if (test-path "\\$ServerName\c$\Program Files (x86)\"){
        $PFPath = "\\$ServerName\c$\Program Files (x86)" } else {
        $PFPath = "\\$ServerName\c$\Program Files"}
    
    if (test-path "$PFPath\Nimsoft\"){
        $Path = "$PFPath\Nimsoft\probes" } else {
        $Path = "$PFPath\Nimbus\probes" }
    return $Path
}

$csv = Import-Csv c:\temp\usertags.txt

foreach ($line in $csv)
{
$machine = $line.machine
$nimusertag1 = $line.usertag1
$nimusertag2 = $line.usertag2
$Path = FindPath($machine)
$filename = "$Path\robot\robot.cfg"
(gc $fileName) -replace "</controller>", "   os_user1 = $nimusertag1`n   os_user2 = $nimusertag2`n$&" | sc $fileName
c:\pstools\pskill \\$machine controller.exe
}