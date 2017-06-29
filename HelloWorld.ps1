Param 
(
[String[]]
$Name 
)

switch ($name)
{
    "Keith" {Write-Host "Hello Keith"}
    default {Write-Host "Hello World"}
}

