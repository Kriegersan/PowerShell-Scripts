<#
This is a collection of tools that are put under one script. Each Tool deals with an aspect of Lync users. 

Are first function is Enable-Users.

Enable-Users: 
This function takes a CSV file that is located in the c:\Temp\Users.csv <-- It has been hard coded in because of the variables. 

After taking in the CSV It runs a foreach loop over the items inside. The script takes the SamAccount Name from the csv file and converts the SAM Account Name into the Users
Full name as in their AD accounts. 

It then take the name and enables the first part of the User to access Lync. 

The Script then pauses for 25 seconds to allow the first part of the proccess to intergrate into the system. 

After sleeping the Script fires back up and finishes the rest of the Enabling process. Such as Setting up for Enterprise Voice to True 

and if Phonenumber and extension have been setup adding them to the profile. 

The script continues until all names in the the list have been enabled. 


Disable-Users: 
Again this function takes the same CSV file and disables all users that are on that list. 

Search-Users: 
This function works a bit differently inorder to make this script successful there needed to be away inorder to search for Users in the system. It runs an active-directory query 
searching for users throughout the system. It then dsi
#>





function Enable-Users{
Import-module Lync

$users = Import-Csv C:\Temp\Users.csv

foreach($user in $users){
    $samAccountName = $user.Name
    $phoneNumber= $user.Phone
    $extension = $user.ext





$userName = Get-csaduser -Filter {SamAccountName -like $samAccountName} | select -ExpandProperty name #Searching for Username based off of the SamAccount Name Given



"$userName" | Enable-CsUser -RegistrarPool lyncfepoolbgr.emhs.org -SipAddressType EmailAddress # Enabling Account
write-host " "
write-host " "
Write-host "Please wait . . . Enabling user $userName" 


start-sleep -s 25


Set-CsUser -Identity "$userName" -EnterpriseVoiceEnabled $true  #Setting Enterprise Voice to True 

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
write-host " "
write-host " "
}

}


function Disable-Users{

$users = import-csv C:\Temp\users.csv
foreach($user in $users){
    $samAccountName = $user.Name
    

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
   C:\Users\iskrn1da\Desktop\Enable-Users\Enable-Lync.ps1
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

 if ($mainMenu -eq 'y')

 {
   C:\Users\iskrn1da\Desktop\Enable-Users\Enable-Lync.ps1
 }
 else 
 {
  clear
 }

}

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