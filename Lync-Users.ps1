<#


#>

function Enable-Users{
Import-module Lync

$users = Import-Csv C:\Temp\Users.csv

foreach($user in $users){
    $samAccountName = $user.SAMAccountName
    $phoneNumber= $user.PhoneNumber
    $extension = $user.Extension





$userName = Get-csaduser -Filter {SamAccountName -like $samAccountName} | select -ExpandProperty name #Searching for Username based off of the SamAccount Name Given



"$userName" | Enable-CsUser -RegistrarPool lyncfepoolbgr.emhs.org -SipAddressType EmailAddress # Enabling Account
write-host " "
write-host " "
Write-host "Please wait . . . Enabling user $userName" 


Start-Sleep -s 25


Set-CsUser -Identity "$userName" -EnterpriseVoiceEnabled $true  #Setting Enterprise Voice to True and adding a P

if($phoneNumber.length -gt 1 ){
    
    if($extension.length -gt 1){
      Set-CsUser -Identity "$userName" -LineURI "tel:+$phoneNumber;ext=$extension"
      Write-Host "Done!"  
    }
    else{
      Set-csuser -Identity "$userName" -lineURI "tel:+$phoneNumber" 
      Write-Host "Done!"
    }
}
else{
Write-Host "Done!"
}
Write-Host " "
Write-Host " "
}

}


function Disable-Users{

$users = import-csv C:\Temp\users.csv
foreach($user in $users){
    $samAccountName = $user.SAMAccountName
    

$userName = Get-csaduser -f {SamAccountName -like $samAccountName} | select -ExpandProperty name

Write-Host "Please wait . . . Disabling user $userName"

Start-Sleep -s 5

disable-csuser -identity $userName 

Write-Host "Done!"

}
write-host " "
write-host " "

}



function Search-Users{
$lastName = read-host "Please enter in a Last Name" 
$fisrtName = read-host "Please enter in a First Name" 

If ($fisrtName -eq "" )
 { 
   $name = "$lastName, *" 
 }
 else
 {
    $name = "$lastName, $fisrtName"
 }


 get-csaduser -Filter {name -like $name} | select name, Samaccountname, company, department

 write-host " " 
 Write-host " "
 $broadSearch = read-host "Did you find what you were looking for? (y/n)" 
 Write-host " " 
 write-host " "
 if ($broadSearch -like 'y' )
 {
   menu
 }
 else
 {
    $reName = "$name *"
    get-csaduser -Filter {name -like $reName} | select name, samaccountname, company, department

 }


 write-host " " 
 write-host " " 

 $mainMenu = read-host "Would you like to go back to the main menu? (y/n)"

 write-host " "
 write-host " " 

 if ($mainMenu -like 'y')

 {
   menu
 }
 else 
 {
  clear
 }

}


function menu{
clear

[int]$xMenuChoiceA = 0
while ( $xMenuChoiceA -lt 1 -or $xMenuChoiceA -gt 4 ){
Write-host "1. Enable User"
Write-host "2. Disable User"
Write-host "3. Search User"
Write-host "4. Quit and exit"
[Int]$xMenuChoiceA = read-host "Please enter an option 1 to 4..." }
Switch( $xMenuChoiceA ){
  1{Enable-Users}
  2{Disable-Users}
  3{Search-Users}
  4{exit}
default{exit}
}
}

menu
