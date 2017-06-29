$ob1 = "Kenobie"

"Begin Test"

Try 
{
  "Attempting to create new object $ob1"
  $a = New-Object $ob1
  "Members of the $ob1"
  "New object $ob1 created"
  $a | Get-Member
}

Catch [System.Exception]
{
  "Caught a System Exception"
}

Finally 
{
  "End Script.."
}