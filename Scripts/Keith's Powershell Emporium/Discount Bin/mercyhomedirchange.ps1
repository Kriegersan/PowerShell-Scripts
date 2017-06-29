#Recursively get all the users in the Mercy OU.
$users = Get-ADUser -Filter * -SearchBase "OU=Mercy,OU=Employee Accounts,OU=Accounts-User,DC=me,DC=emh,DC=org"

#Create the placeholder report file and clearing it if it already exists.
echo "Username,Current Home Directory, New Home Directory" > c:\temp\mercyusershomedir.csv

foreach($user in $users){
    $username = $user.samaccountname
    if($oldhomedir = (get-aduser $user -properties homedirectory).homedirectory){
        #Skip over users that have "." as the home directory.
        if ($oldhomedir -eq "."){continue}

        #If you want to reverse the change swap the "mp-fileserver0" and "meri" on the next line.
        $homedir = $oldhomedir.replace("mp-fileserver0","meri")
        
        #Uncomment the next line to actually make the change.
        #set-aduser $user -HomeDirectory $homedir
        
        #Create a CSV report of the changes that will be made.
        echo "$username,$oldhomedir,$homedir" >> c:\temp\mercyusershomedir.csv
    }
}