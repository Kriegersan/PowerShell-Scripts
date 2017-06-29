$vms = $(get-content c:\temp\compnames.txt)
foreach ($vm in $vms){
if(!(Gwmi Win32_Computersystem -Comp "$vm").UserName){
write-host "I would be rebooting $vm"
} else {
write-host "I would not reboot $vm because of" (Gwmi Win32_Computersystem -Comp "$vm").UserName
}
}