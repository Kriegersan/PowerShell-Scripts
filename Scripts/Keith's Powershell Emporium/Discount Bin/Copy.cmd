 @echo off

SET SORC="\\shu\svhdata\Administration\SVH Organizational Charts\*"
SET DEST="\\shu\svhdata\SVH Organizational Charts\*"
SET LOG="C:\temp\Robo.log"

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