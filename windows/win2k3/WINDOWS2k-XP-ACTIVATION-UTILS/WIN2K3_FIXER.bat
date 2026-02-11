@echo off
set SYSPATH=%SystemRoot%\system32
set LOGFILE=%SystemRoot%\fix_log.txt

echo === START REPAIR: %DATE% %TIME% === > %LOGFILE%
echo System path: %SystemRoot% >> %LOGFILE%

:: 1. Stop activation process
echo Killing activation proccess... >> %LOGFILE%
%SYSPATH%\taskkill.exe /F /IM wpabaln.exe /T >> %LOGFILE% 2>&1

:: 2. Regenerate WPAEvents
echo Import WPAEvents... >> %LOGFILE%
regedit.exe /s %SYSPATH%\wpafix.reg >> %LOGFILE% 2>&1
echo Registry status: %ERRORLEVEL% >> %LOGFILE%

:: 3. Reset Grace period
echo Reseting grace period ... >> %LOGFILE%
start /wait %SYSPATH%\rundll32.exe %SYSPATH%\syssetup,SetupOobeBnk >> %LOGFILE% 2>&1

:: 4. Re-register libraries
echo Registering DLLs... >> %LOGFILE%
for %%i in (licwmi.dll licdll.dll regwizc.dll jscript.dll vbscript.dll) do (
    echo Registering %%i... >> %LOGFILE%
    %SYSPATH%\regsvr32.exe /s %SYSPATH%\%%i >> %LOGFILE% 2>&1
)

:: 5. Clean WPA.DBL
echo Checking wpa.dbl... >> %LOGFILE%
if exist %SYSPATH%\wpa.dbl (
    ren %SYSPATH%\wpa.dbl wpa.dbl.old >> %LOGFILE% 2>&1
    echo File wpa.dbl renamed to .old >> %LOGFILE%
) else (
    echo wpa.dbl not found system will create new one. >> %LOGFILE%
)

:: 6. Remove ANTIWPA if exist
echo Checking antiwpa.dll... >> %LOGFILE%
if exist %SYSPATH%\antiwpa.dll (
    regsvr32.exe /u %SYSPATH%\antiwpa.dll >> %LOGFILE% 2>&1
    del %SYSPATH%\antiwpa.dll >> %LOGFILE% 2>&1
    echo Unregister AntiWPA >> %LOGFILE%
) else (
    echo Not antiWPA found. >> %LOGFILE%
)

echo === END PROCESS  === >> %LOGFILE%
