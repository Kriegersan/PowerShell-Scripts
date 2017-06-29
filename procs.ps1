echo "These are top 10 processes VM for virtual memory and PM for physical memory all are listed in Mb"

echo " "
echo "" 

 Get-Process | sort -Property vm,pm -Descending | select -Property Name,Id,@{n='VM'; e={$_.vm/1mb}},@{n='PM'; e={$_.PM/1mb}} -First 10




pause