param(
$Server
)

$Svr = get-adcomputer -name $Server #get Ad computer Object


$Svr | move-adobject -TargetPath "OU=Servers, DC=me,DC=emh,DC=org"


write-host "$Server has been moved to the Servers OU in AD WOOT! "
