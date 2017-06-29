# Install SEP and SCCM Client on Servers ... Wooot?

write-host "Installing stuff.. Hang tight"

& "\\me.emh.org\IT\Applications Mainstream\Symantec\SEP\12.1.6\SEPSetup.EXE" /q


& "\\me.emh.org\IT\Applications Specialized\SCCM Client\SCCM_Client Setup.EXE" /q


Write-host "Done!"
