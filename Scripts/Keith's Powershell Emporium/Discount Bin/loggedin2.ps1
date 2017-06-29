$computers = $(get-content c:\temp\compnames.txt)
foreach ($computer in $computers){
    if(!(Gwmi Win32_Computersystem -Comp "$computer").UserName){
        $username = "None"
    } else {
        $username = (Gwmi Win32_Computersystem -Comp "$computer").UserName
    }
    "$computer,$username" >> c:\temp\output.txt
}