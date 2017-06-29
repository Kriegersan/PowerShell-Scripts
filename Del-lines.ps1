$path = "C:\Test\test.txt"
function deleteLine
{
  $line = (get-content -Path $path | measure-object)
  $content = get-content -path $path 

  for($i = 1; $i -le $line.count; $i ++ )
  {
    $content -replace [regex]::Escape($content[$i - 1]) | set-content -path $path 
  }

}