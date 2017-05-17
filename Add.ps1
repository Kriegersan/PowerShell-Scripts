function Add{
param($a, $b)

$c = $a + $b
 return $c


}

function Power{
  param($a)

  $c = $a*$a

  return $c
}


for($x = 0; $x -lt 21; $x++){

    for(;Add $x 1 -lt 22;){
        Write-host "* `n"
    } 
}
