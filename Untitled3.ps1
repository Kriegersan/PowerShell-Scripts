 @echo off

SET SORC="\\leonard\c$\iskrn1da\Desktop\"
SET DEST="\\EMHSL35272\c$\Scripts"
SET LOG="Z:\THE LOG FILE.log"

ROBOCOPY %SORC% %DEST% /MIR /SEC /R:1 /W:1 /NP /LOG:%LOG%
@if errorlevel 16 echo ***ERROR *** & goto END
@if errorlevel 8 echo **FAILED COPY ** & goto END
@if errorlevel 4 echo *MISMATCHES * & goto END
@if errorlevel 2 echo EXTRA FILES & goto END
@if errorlevel 1 echo --Copy Successful-- & goto END
@if errorlevel 0 echo --Copy Successful-- & goto END
goto END

:END

pause