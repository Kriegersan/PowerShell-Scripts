$groups = Get-DistributionGroup -filter {alias -like "* *"} 
foreach ($group in $groups) 
{
$group.alias.tostring() >> groups.txt
}