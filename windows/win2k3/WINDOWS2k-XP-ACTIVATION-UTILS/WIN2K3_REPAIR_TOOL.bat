@echo off
setlocal enabledelayedexpansion
title WIN2003 PHOENIX RECOVERY - ULTIMATE EDITION
set LOGFILE=%SystemRoot%\PHOENIX_MASTER_LOG.txt
set BACKUP_DIR=%SystemRoot%\PHOENIX_BACKUP_%DATE:~-4%%DATE:~4,2%%DATE:~7,2%

echo ========================================================
echo    WINDOWS SERVER 2003 PHOENIX RECOVERY - ULTIMATE
echo ========================================================
echo [LOG START: %DATE% %TIME%] > %LOGFILE%
if not exist %BACKUP_DIR% mkdir %BACKUP_DIR%

:MENU
cls
echo ========================================================
echo  SCENARIOS (COMBINED ACTIONS)
echo ========================================================
echo 1. SIMPLE: Reset Grace Period + OOBETimer [Normal Activation Loop]
echo 2. EXTREME: HW Change + Activation Loop + Purge AntiWPA + Essential win Binaries restore [Clean WPA - HW database - Restore Critical WIN binaries - Fix activation]
echo 3. ACCOUNT LOCKED: Restore SAM/SECURITY [Login Error Fix] *User config/programs data lost PARTIAL LOST*
echo 4. BSOD FIX: Inject Generic IDE/SATA [Prevent blue screen 0x7B]
echo 5. NUCLEAR: Full Registry Restore + Full Windows Binaries Restore *Config lost USE AS LAST OPTION*
echo.
echo ========================================================
echo  INDIVIDUAL ATOMIC ACTIONS
echo ========================================================
echo 6. Rebuild WMI / WBEM Repository [Hardware changes]
echo 7. Empty WPA Hashes (SigningHash/Resigning) - KEEP KEYS [License grace period wipe]
echo 8. Purge Crack Hooks (AntiWPA, WGA, AppInit_DLLs) [Unstuck License service]
echo 9. Sync System32 with DLLCACHE (Massive System Files Restore) [Restore factory Win binaries] *WINDOWS DATA LOST USE AS LAST OPTION*
echo 10. Manual WPAEvents Creation + OOBETimer Reset [License FIX]
echo 11. Re-Register Licensing & Scripting DLLs [Fix White Screen]
echo 12. Sync System32 with DLLCACHE (Essential Win binaries) [Restore factory Win binaries]
echo 13. Full Registry Restore from REPAIR [Data Loss] *REGISTRY DATA LOST USE AS LAST OPTION*
echo 14. Sync System32 with DLLCACHE (Critical System Files Restore) [winlogon.exe, msgina.dll, licwmi.dll, licdll.dll, regwizc.dll, cryptsvc.dll, userinit.exe]

echo 15. Exit
echo ========================================================
set /p choice=Select Option (1-11):

if "%choice%"=="1" goto SCENARIO_SIMPLE
if "%choice%"=="2" goto SCENARIO_EXTREME
if "%choice%"=="3" goto SCENARIO_LOCKED
if "%choice%"=="4" goto SCENARIO_BSOD
if "%choice%"=="5" goto SCENARIO_NUCLEAR
if "%choice%"=="6" goto ACTION_WMI
if "%choice%"=="7" goto ACTION_WPA_HASH_EMPTY
if "%choice%"=="8" goto ACTION_PURGE
if "%choice%"=="9" goto ACTION_DLLCACHE_SYNC
if "%choice%"=="10" goto ACTION_WPA_MANUAL
if "%choice%"=="11" goto ACTION_REG_DLLS
if "%choice%"=="12" goto ACTION_DLL_SURGICAL
if "%choice%"=="13" goto ACTION_TOTAL_HIVE_RECOVERY
if "%choice%"=="14" goto ACTION_DLL_SURGICAL
if "%choice%"=="15" goto EXIT
goto MENU

:: --- SCENARIOS ---

:SCENARIO_SIMPLE
echo [SIMPLE] Resetting Grace Period...
call :ACTION_WPA_MANUAL
call :ACTION_GRACE_BNK
echo SIMPLE FIX COMPLETED. >> %LOGFILE%
pause
goto MENU

:SCENARIO_EXTREME
echo [EXTREME] Performing Deep Surgery...
call :ACTION_PURGE
call :ACTION_WPA_HASH_EMPTY
call :ACTION_WMI
call :ACTION_WPA_MANUAL
call :ACTION_GRACE_BNK
call :ACTION_REG_DLLS
call :ACTION_DLL_SURGICAL
echo EXTREME FIX COMPLETED. >> %LOGFILE%
pause
goto MENU

:SCENARIO_LOCKED
call :ACTION_ACC_UNLOCK
pause
goto MENU

:SCENARIO_BSOD
call :ACTION_BSOD
pause
goto MENU

:SCENARIO_NUCLEAR
call :ACTION_TOTAL_HIVE_RECOVERY
call :ACTION_DLLCACHE_SYNC
call :ACTION_WMI
pause
goto MENU

:: --- ATOMIC ACTIONS ---
:ACTION_TOTAL_HIVE_RECOVERY
echo [WARNING] THIS WILL REPLACE ALL CONFIG HIVES. DATA LOSS RISK.
set /p confirm=Type 'REPAIR' to confirm:
if /i "%confirm%"=="REPAIR" (
    xcopy %SystemRoot%\repair\* %SystemRoot%\system32\config\ /y /h >> %LOGFILE%
)
goto :EOF

:ACTION_BSOD
echo [0x7B FIX] Injecting IDE/SATA Services...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\atapi" /v Start /t REG_DWORD /d 0 /f >> %LOGFILE% 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\intelide" /v Start /t REG_DWORD /d 0 /f >> %LOGFILE% 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\pciide" /v Start /t REG_DWORD /d 0 /f >> %LOGFILE% 2>&1
echo Drivers Injected. Set BIOS to IDE/Legacy Mode. >> %LOGFILE%
goto :EOF

:ACTION_ACC_UNLOCK
echo [ACCOUNT FIX] Restoring SAM/SECURITY from REPAIR...
copy %SystemRoot%\system32\config\SAM %BACKUP_DIR%\SAM.bak >> %LOGFILE%
copy %SystemRoot%\system32\config\SECURITY %BACKUP_DIR%\SECURITY.bak >> %LOGFILE%
copy %SystemRoot%\repair\SAM %SystemRoot%\system32\config\SAM /y >> %LOGFILE%
copy %SystemRoot%\repair\SECURITY %SystemRoot%\system32\config\SECURITY /y >> %LOGFILE%
goto :EOF

:ACTION_WMI
echo [WMI] Rebuilding Repository for Hardware Reset... >> %LOGFILE%
net stop winmgmt /y >> %LOGFILE% 2>&1
:: Renaming Repository for clean reset
if exist %SystemRoot%\system32\wbem\repository (
    ren %SystemRoot%\system32\wbem\repository repository.old >> %LOGFILE% 2>&1
    rd /s /q %SystemRoot%\system32\wbem\repository.old >> %LOGFILE% 2>&1
)
cd /d %SystemRoot%\system32\wbem
for %%i in (*.dll) do regsvr32 /s %%i
for %%i in (*.mof *.mfl) do mofcomp %%i >> %LOGFILE% 2>&1
net start winmgmt >> %LOGFILE% 2>&1
goto :EOF

:ACTION_WPA_HASH_EMPTY
echo [WPA] Emptying Hashes (Keeping Keys)... >> %LOGFILE%
:: Clean Key-xxxx entries
for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\WPA" ^| findstr /i "Key-"') do (reg delete "%%a" /f >> %LOGFILE% 2>&1)
:: Emptying values without deleting the Key itself
reg delete "HKLM\SYSTEM\WPA\SigningHash" /va /f >> %LOGFILE% 2>&1
reg delete "HKLM\SYSTEM\WPA\ResigningHash" /va /f >> %LOGFILE% 2>&1
if exist %SystemRoot%\system32\wpa.dbl ren %SystemRoot%\system32\wpa.dbl wpa.dbl.old >> %LOGFILE% 2>&1
goto :EOF

:ACTION_PURGE
echo [PURGE] Removing AntiWPA & Crack Hooks... >> %LOGFILE%
taskkill /F /IM wgatray.exe /T >> %LOGFILE% 2>&1
set PURGE_LIST=antiwpa.dll wgalogon.dll wgatray.exe legitcheckcontrol.dll
for %%f in (%PURGE_LIST%) do (
    if exist %SystemRoot%\system32\%%f del /f /q %SystemRoot%\system32\%%f >> %LOGFILE% 2>&1
)
:: Clear AppInit_DLLs hook
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /t REG_SZ /d "" /f >> %LOGFILE% 2>&1
sc delete antiwpa >> %LOGFILE% 2>&1
goto :EOF

:ACTION_DLLCACHE_SYNC
echo [MASSIVE] Syncing all DLLCACHE and Auto-Registering... >> %LOGFILE%
xcopy %SystemRoot%\system32\dllcache\* %SystemRoot%\system32\ /y /h >> %LOGFILE%
echo [REGISTRATION] Registering all DLLs in System32 (This may take time)... >> %LOGFILE%
cd /d %SystemRoot%\system32
for %%i in (*.dll) do %SystemRoot%\system32\regsvr32.exe /s %SystemRoot%\system32\%%i >> %LOGFILE% 2>&1
goto :EOF

:ACTION_WPA_MANUAL
echo [REGISTRY] Manually Creating WPAEvents + OOBETimer... >> %LOGFILE%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WPAEvents" /f >> %LOGFILE% 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WPAEvents" /v OOBETimer /t REG_BINARY /d ffd571d68b6a8d6fd53393fd /f >> %LOGFILE% 2>&1
goto :EOF

:ACTION_GRACE_BNK
echo [RESET] Executing Grace Period Command... >> %LOGFILE%
start /wait rundll32.exe syssetup,SetupOobeBnk
goto :EOF

:ACTION_REG_DLLS
echo [REG_DLLS] Registering Licensing & Scripting components... >> %LOGFILE%
for %%i in (licwmi.dll licdll.dll regwizc.dll jscript.dll vbscript.dll msxml3.dll oobefp.dll) do (
    echo Registering %%i... >> %LOGFILE%
    %SystemRoot%\system32\regsvr32.exe /s %SystemRoot%\system32\%%i >> %LOGFILE% 2>&1
)
goto :EOF

:ACTION_DLL_SURGICAL
echo [SURGICAL] Restoring and Registering critical licensing binaries... >> %LOGFILE%

:: List critical binaries to restore
set CRITICAL_FILES=winlogon.exe msgina.dll licwmi.dll licdll.dll regwizc.dll cryptsvc.dll userinit.exe oobefp.dll

for %%f in (%CRITICAL_FILES%) do (
    if exist %SystemRoot%\system32\dllcache\%%f (
        echo Restoring %%f... >> %LOGFILE%
        copy %SystemRoot%\system32\dllcache\%%f %SystemRoot%\system32\%%f /y >> %LOGFILE% 2>&1
    ) else (
        echo Warning: %%f not found in dllcache. >> %LOGFILE%
    )
)

echo [REGISTRATION] Re-registering all licensing and UI components... >> %LOGFILE%
for %%i in (licwmi.dll licdll.dll regwizc.dll cryptsvc.dll oobefp.dll jscript.dll vbscript.dll msxml3.dll) do (
    if exist %SystemRoot%\system32\%%i (
        echo Registering %%i... >> %LOGFILE%
        %SystemRoot%\system32\regsvr32.exe /s %SystemRoot%\system32\%%i >> %LOGFILE% 2>&1
    )
)

echo Surgical Restore and Registration finished. >> %LOGFILE%
goto :EOF

:EOF
echo Done. Check Log.
goto :EOF

:EXIT
start notepad %LOGFILE%
exit
