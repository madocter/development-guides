# Windows 2k3 license activation and unlock guide

This is the ultimate Post-Mortem & Disaster Recovery Guide for Windows Server 2003 activation / signing loops.

It covers the "Extreme Case" where AntiWPA patches, hardware changes, and registry locks prevent a normal boot.

**NOTE:** This was tested on my personal computer there is not warranty will work for everyone feel free to try at your own risk , make WINDOWS backup first.

## Resources
Keys:https://gist.github.com/thepwrtank18/4456b1a4676a26c6ef25b8e8b70e26d7

Windows2k3 Enterprise R2 x64 working key: VYTMJ-8K9XR-FK63H-6VBXX-8TJJ6

Hirens boot 15.2: https://www.hirensbootcd.org/hbcd-v152/

Rufus: https://rufus.ie/es/

Windows 2k3 Repair tool: [WIN2K3_REPAIR_TOOL.bat](WINDOWS2k-XP-ACTIVATION-UTILS%2FWIN2K3_REPAIR_TOOL.bat)

*Note* Use carefully previously make full WINDOWS folder backup

Registry models to check: [REGISTRY-MODELS](WINDOWS2k-XP-ACTIVATION-UTILS%2FREGISTRY-MODELS)


## Concepts
Some key concepts to understand better the guide.

### Hives
Hives where windows stores registry configuration:

`%SystemRoot%\System32\Config`

* SAM	    User accounts and passwords
* SYSTEM	System config and drivers
* SOFTWARE	Profile, Windows config, and programs.
* SECURITY	Security policies
* DEFAULT	Default config for new users

`%SystemDrive%\Document and settings\user`
* NTUSER.DAT User configuration.


### Hirens boot 15.2 recovery for win and unix system

With it can access disk, edit registry offline, unlock users and passwords with mini WinXP and command line tools such as chntpw.

### Windows recovery and repair

With original installation CD or ISO image on USB device can load windows setup

To access to `windows recovery menu` where you can write commands and access recovery options 

Perform `windows re-installation` Windows install will detect existing OS will offer the repair option.

### Windows activation

Windows handles the activation with registry keys and control files 

***WPA subsystem and components***

WPA (Windows Product Activation): Based on file `windows\system32\wpa.dbl` and registry keys `WPAEvents` , `WPA`. Compares current hardware with stored hardware sign hash.
WMI (WinMgmt): This builds the hardware database.

If we rename `wpa.dbl` we reset the activation status and windows will create new file next logon attempt.

***WPA Registry keys:***

`[HKLM\SYSTEM\WPA]` Hive: System

* `SigningHash / ResigningHash`: Hardware hash. If windows tries to validate license and the stored hash doesn't match with current launches error "can´t determine license status". 
  * Usage: If removed the bin values not the keys kernel will generate new ones.
* `Key-xxxxxxxx`: Activation session identifiers. 
  * Usage: If grace period expires the ID remain here, removing increases SetupOobeBnk success.
* `PnP`: Plug and Play database.
  * Usage: Remove some entries if computer stuck loading drivers...

`[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WPAEvents]` Hive: Software

* `OOBETimer` : Set timer for next license check
* `LastWPAEventLogged` : Last time WPA event


***AntiWPA***
Old windows fix for License and Activation it can cause login loop in case of hardware change so important remove it in that case

At Win2k3 registry key is stored at: `[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AntiWPA]`

Library inside `system32\antiwpa.dll`

In case of issues remove registry and unload the dll from command line: `regsvr32.exe /u %SystemRoot%\system32\antiwpa.dll`


### Windows emergency recovery resources

***Folder REPAIR (windows\repair)***
Contains factory Hives (registry) values (SAM, SOFTWARE, SYSTEM).

Usage: If user is blocked or registry corrupted, replace the ones from `windows\repair` at `system32\config`
Note: Might lost installed programs and configurations but system will boot.

***DLL Cache (windows\system32\dllcache)***

Hidden folder with backups of critical libraries and binaries Example: (licwmi.dll, winlogon.exe).

## Procedures

### Safe mode classic

On OS select screen or while OS is loading press F8 to safe mode options which usually allows login on the system to unlock the system.

### CMD.exe on startup

If logon is locked you can perform registry trick to launch windows cmd on login screen

Use Hirens boot or any offline registry editor find `Setup` key `HKEY_LOCAL_MACHINE\SYSTEM\Setup` (Win2k3 location) and change as follows:

``[HKEY_LOCAL_MACHINE\SYSTEM\Setup]
"SetupType"=dword:00000001
"SystemSetupInProgress"=dword:00000001
"CmdLine"="cmd.exe"``

Make sure restore opening `regedit.exe` after finish if you want login normally.

``[HKEY_LOCAL_MACHINE\SYSTEM\Setup]
"SetupType"=dword:00000000
"SystemSetupInProgress"=dword:00000000
"CmdLine"="setup -newsetup"``

From there can open `explorer.exe` to open desktop.

### Bootable media

Make bootable USB with *RUFUS* (Legacy MBR mode if UEFI and secure boot not available for old Windows) or burn CD with *imgburn*, usually BIOS shall support bootable USB unless is very old.

Use Windows installation disc and recovery tools if you can sign at all in your current system.

Press F8 , F10 during BIOS startup to select boot device or change boot device order at BIOS settings (I know this is know already by everybody)

### Edit registry offline.

Download *Hirens boot 15.2* (at least I use this version for Win2k3 and XP)

* Select **mini win xp**
  * From there click on START menu you will see HR menu with many programs.
  * Open *registry editor for PE* You have to load HIVES located at `YOUR-UNIT\WINDOWS\system32\config` and then select the USERDATA files at `Documment and settings\YOUR-USER` you can add more than one.
  * When finish click on close to unload the HIVES.

* Any other WINDOWS computer 
  * Use regedit.exe and click at HKEY_LOCAL_MACHINE at OWN registry of the HOST computer, then load HIVE of the other Windows installation
  * File / Load hive
  * `Windows\system32\HIVE-YOU-WANT` Usually software or system files.
  * Then just name the HIVE with a temporary name such as WIN2K_SOFTWARE and edit the registry from there.
  * Make sure unload the hive when finish to save the changes.

*NOTE* : you can change permissions of each KEY if necessary, and even change ownership from advanced permissions' menu.
However, sometimes is impossible to remove a KEY or update settings since it was created and blocked from some tool such as AntiWPA or just corrupted.
In this case use `Registry editor from command line` which explained below, or `Restore Windows registry settings` from `WINDOWS\repair` folder. 

### Registry editor command line 

From Hirens boot menu use *chntpw* 

* Boot Hiren's -> Select Offline NT Password Changer. 
* Select your Disk/Partition 
* Path to Hives: Usually WINDOWS/system32/config.
* Now you might see predefined options such as [1] [2] Password change, just ignore predefined options and write the HIVE you want to load, example: `software`
* Enter Editor: Choose option [9] (Registry Editor).

From here you can navigate with: `cd` and see the keys with `dir`, add , modify keys, write `?` to see all commands.

Make sure to with `q` and unload and save the changes


### Restore Windows registry settings

`windows\repair` at `system32\config`

If user is blocked or registry corrupted, replace the ones from `windows\repair` at `system32\config`

For instance restore `SAM` and `SECURITY` in case windows drop error on signing : windows couldn't sign this account.


### Restore Windows libraries, executables binaries

Check hidden folder: `windows\system32\dllcache` 

Replace necessary files from here in to proper location

If some patches (NoWPA, AntiWPA) replaced original files, can restore them for factory reset

Usually: licwmi.dll or winlogon.exe are modified by patches.

To detect modified resources check for date size in comparison with the ones presents at dllcache, also look for occurrences of backup, example search for: *.bak or *.old 

If not investigate the applied or present patches README to see which files are affected.

### Repair WMI and reset WPA status
In case the system is very damaged and can´t extend grace period with OOBE command.

**Fix broken WMI and reset activation receipts procedure:**

From Safe mode or CMD trick [CMD.exe](#CMD.exe on startup)

Step 1: Fix WMI (The Hardware Translator)
If the Motherboard changed, WMI is likely broken (Error 3534).
batch

:: Restore the WBEM environment
net stop winmgmt /y
`rd /s /q %SystemRoot%\system32\wbem\repository`
`cd /d %SystemRoot%\system32\wbem`

:: Re-register all WMI components
`for %i in (*.dll) do regsvr32 /s %i`
`for %i in (*.mof *.mfl) do mofcomp %i`
`net start winmgmt`

Step 2: Clear Hardware Hashes
Windows is comparing the old motherboard signature. Clear it.

:: 1. Remove previous activation receipts (Key-xxxx)
:: Do not remove WPA key but the key-xxxx values.
for /f "tokens=*" %a in ('reg query "HKLM\SYSTEM\WPA" ^| findstr /i "Key-"') do reg delete "%a" /f

:: 2. Empty (SigningHash)
:: Do not delete key but bin value to force refresh
``
reg delete "HKLM\SYSTEM\WPA\SigningHash" /va /f
reg delete "HKLM\SYSTEM\WPA\ResigningHash" /va /f
``

:: Delete existing activation "receipts"
`reg delete "HKLM\SYSTEM\WPA" /f`

:: (Optional Exception) Rename old license file if still looping
`ren %SystemRoot%\system32\wpa.dbl wpa.dbl.old`

Now try again [License fix](#Windows Activation)

### Recovery console

This is included in original Windows installation disk if not can download on internet recovery console for Win2k3 or XP

* `Fixboot / Fixmbr` for boot problems.
* `Repair` (R Key): Re-install file system maintaining data. Most effective repair method if registry not damaged.

### Windows re-installation

The most effective measure if hardware change is big such as Intel / AMD or different chipset.

What does it actually do? It reinstalls the HAL (Hardware Abstraction Layer) and the kernel (ntoskrnl.exe) specific to the new architecture, but keeps your programs and data.

Procedure:
* Boot from the Windows 2003 CD. 
* Do not select the first "R" (console). Press ENTER. 
* Accept the agreement (F8). 
* When it detects your Windows installation, press the second "R" (Repair Selected Installation).

Result: The system is "refreshed" with the factory files, removing any patches (such as AntiWPA) and configuring the basic drivers for the new motherboard.

### Full windows clean up after hardware changes

Clean hardware inventory WMI:
Windows 2003 stores the hardware inventory in a database. If the motherboard changes, the IDs conflict.

Stop WMI and rename repository folder:

``
net stop winmgmt /y
ren %SystemRoot%\system32\wbem\repository repository.old
``

Re-register drivers infrastructure/WMI:

``
cd /d %SystemRoot%\system32\wbem
for %i in (*.dll) do regsvr32 /s %i
for %i in (*.mof *.mfl) do mofcomp %i
net start winmgmt
``

Force Plug and Play Re-detection:
Delete the old device enumerators in the registry so that Windows searches for new ones:

Delete values in `HKLM\SYSTEM\WPA` (such as the signature hashes mentioned).

Commands to Clean Hashes and Activation

Run this to "reset" the hardware's identity in the registry:

:: 1. Delete receipts for previous activation attempts (Key-xxxx)
:: We do not delete the WPA key, only the subkeys from failed attempts
for /f "tokens=*" %a in ('reg query "HKLM\SYSTEM\WPA" ^| findstr /i "Key-"') do reg delete "%a" /f

:: 2. Empty the Signing Hashes
:: We don't delete the key, only the binary content to force recalculation
``
reg delete "HKLM\SYSTEM\WPA\SigningHash" /va /f
reg delete "HKLM\SYSTEM\WPA\ResigningHash" /va /f
``

:: 3. DO NOT DELETE PnP (Only if necessary, but it's best to let Windows handle it)
:: In case you want to delete: `reg delete "HKLM\SYSTEM\WPA\PnP" /va /f`

In case we can access with CMD.exe trick or SAFE mode:
Uninstall old drivers (especially IDE/SATA) from Device Manager, hiding any "non-present devices".


###  "7B" (Inaccessible Boot Device)
If the server displays an instant blue screen (0x0000007B) after replacing the motherboard, it's because the disk controller driver (SATA/AHCI) is different.
Solution: Before moving the disk, change the disk mode in the new motherboard's BIOS to "IDE Mode" or "Legacy." Windows 2003 does not have native AHCI drivers.

### Blue screen 0x7B fix 

If you have access to SAFE mode from there open control panel / device manager / remove unknown and hard-disk drivers, install proper drivers from there. Install then appropriate SATA drivers.

Usually you will not have access to the OS.

So need download appropriated SATA drivers and install them offline.

**Motherboard SATA controllers**

The new motherboard in my case is Asus SABERTOOTH Z77 it have 2 sata controllers: ASMEDIA and IRS (Intel rapid storage)

Drivers:
* Asmedia: asahxp.sys
* Intel Rapid Storage: iaStor.sys

Motherboard:
2 White SATA connectors Asmedia 6gps ports
4 Black SATA connectors IRS 3gps ports
2 Brow STA connectors IRS 6gps ports

So it really matter where you connect your WIN2k3 or XP SP3 (Other SP for Windows XP shall not work)
For me work on IRS 3gps without any driver installation.

**BIOS SATA MODE**

I used `IDE` mode since got BSO with ACHI or RAID mode.

**Install drivers offline**

Using another Windows OS or Winxp little from Hirens boot.

* Download drivers, locate appropriate directory usually files/x64/x86 then you will see (IF your OS is x64 check if syswow64 is present in WINDOWS)
  * Caf
  * Sys
  * Inf
    * You can check information of the driver opening this file.
* Place SYS file inside system32/drivers in my case: iaStor.sys 
* Register driver editing SYSTEM hive offline.
* Load SYSTEM hive of the faulty Windows with regedit.exe.
* Check controlASet in use: `HKLM\SYSTEM\Select check current` 
  * On every new hardware it might create a new CurrentControlSet 01,02,03. Example: 01 is first one , 02 last know working, 03 current.
* Edit the currentControlset:
  * HKLM\SYSTEM\CurrentControlSet01\Services\  (Assuming current control set is 01)
  * Add new Key in my case: iaStor
  * Follow any other drive structure as model.
  * Example:
    ```
    [HKEY_LOCAL_MACHINE\SYSTEMWIN2K3OFFLINE\ControlSet003\Services\iaStor]
    "Type"=dword:00000001
    "Start"=dword:00000000
    "ErrorControl"=dword:00000001
    "Group"="SCSI miniport"
    "ImagePath"="system32\DRIVERS\iaStor.sys"
    ```
* Make sure windwos load the new driver edit ServiceGroupOrder:
* `HKLM\OFFLINE\ControlSet001\Control\ServiceGroupOrder`  edit the entry `List` and add the new driver group: `SCSI miniport`
* Unload hive and try.


**Enable default SATA drivers offline**
This can solve the issue enabling default ata kernel drivers:

``
reg add "HKLM\SYSTEM\CurrentControlSet01\Services\atapi" /v Start /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet01\Services\intelide" /v Start /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet01\Services\pciide" /v Start /t REG_DWORD /d 0 /f
``

Set `Start` value as `0`

If nothing works time to perform a Windows reinstallation:  [reinstall windows](#Windows re-installation)

Use exactly same installation version as the installed OS.

Make sure to load SATA or RAID drivers of the new motherboard with USB or making an unattended installation to avoid blue screen again.


## Use cases

Common issues can find in old Win2k3 systems after long time or hardware change.


### Windows couldn't load the profile

Sometimes association between user SID and SAM is broken which prevent from signing.

In this case connect using Secure mode if not possible use Hirens boot to check registry and perform repair.

Windows NT/2003 stores profile status at:

`[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\<SID>]`

ProfileImagePath	Your profile path usually `Document and settings\Administrator.SA-XXXXX` or `Administrator`
RefCount	        Amount of times profile is loaded must be 1 or 0
State	            Profile status 0 (normal)

If state is not 0 means there is a problem with the profile like corrupted `USERDATA.dat`.

Repair:

* Go to: `windows\repair` 
* Copy SAM and SECURITY 
* Place in to `system32\config` *Important:* Make backup of system32/config first.

You shall be able to connect again.

### Windows Activation 
After hardware changes the OEM license is broken and win2k3 enterprise must be activated, the problem is that activation servers obviously are down.

This prevents from signing on in to the computer know as activation loop.

In case you have clean registry not Antiwpa patches recovery is easy.

* Access the computer from safe mode pressing F8 during Windows boot or Windows boot menu.
* Start / RUN and write the following command: `rundll32 syssetup,SetupOobeBnk` this restart grace period which allows you to enter for 30 days in to the computer.
* Open regedit.exe and edit this key with this binary value:
  * `[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WPAEvents]`
  * `OOBETimer`: ff,d5,71,d6,8b,6a,8d,6f,d5,33,93,fd
  * Right click on WPAEvents key / Permissions, at System put DENY on all to prevent windows from changing the Activation timer again.

This should prevent activation issues.
Restart and be able to init windows correctly.

**NOTE: Not working Safe mode** In case windows can´t init on safe mode use Hirens boot offline registry editor to enable CMD.exe to perform the command and registry edition: [CMD.exe](#CMD.exe on startup)

**NOTE: Disable LicenseService** At least on my case License service is disabled:

`[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Services\LicenseService]`
`[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\LicenseService]`

"Start"=dword:00000004

04 means `START DISABLED`

**NOTE: Grace period already used remove registry keys**:  In case grace period already activated windows knows about it with the following registry:

`[HKLM\SYSTEM\WPA]` Hive: System

* `SigningHash / ResigningHash`: Remove the values (Not the keys, leave as empty bin) * This might not be necessary *
* `Key-xxxxxxxx` Is safe to remove this keys to prevent windows knowing previous attempts

Do this in case reset didn't work, and repeat the process again.

**NOTE: WPAEvents key is blocked**  
Usually because of registry corruption or antiWPA patches can't edit or remove WPAEvents key 
even if trying change ownership or permissions will lead to access denied error.

Use offline CLI registry editor of Hirens boot: [Offline CLI registry editor](#Registry editor command line)

Load `software` HIVE

This is the key we need remove:  `[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WPAEvents]`

Navigate to Current version with `cd` command

`cd Microsoft\Windows NT\CurrentVersion`

`rdel WPAEvents` (This recursively deletes the key and all sub-entries, bypassing Windows security).

`dellav WPAEvents` and remove all keys inside WPAEvents recursively check commands writing `?`

`dk WPAEvents` Deletes the key (For success all elements inside the key must be removed)

Save: `q` to quit, then y to write hives to disk (CRITICAL).

Recreate WPAEvents from Hirens boot miniWin XP registry editor

``[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WPAEvents]
"OOBETimer"=hex:ff,d5,71,d6,8b,6a,8d,6f,d5,33,93,fd
"LastWPAEventLogged"=hex:ea,07,01,00,06,00,1f,00,00,00,0f,00,35,00,71,02``

:: LOCK THE REGISTRY (The "Master Fix")
:: Go to Regedit -> WPAEvents -> Permissions -> SYSTEM -> DENY "Set Value"

This is how it should look remember those are binary keys.


**NOTE: uninstall AntiWPA**
Remove AntiWPA library or another you have which prevents Windows License from operating correctly.

For unload dll from registry need access the system with CMD trick:  [CMD.exe](#CMD.exe on startup)

* from there remove **antiwpa** or any other WPA killer:
  * regsvr32.exe /u %SystemRoot%\system32\antiwpa.dll >> %LOGFILE% 2>&1 
* Files: Delete antiwpa.dll from system32.

### Windows Activation with antiWPA or corrupt WPA

In this case AntiWPA , WPAfix and other libraries were installed then hardware changes breaks the harmony and prevents the license activation from working but also the AntiWPA fix leading in to a bizarre loop.

On system startup Windows prompt for activation when try to do, it says "already activated" and return again to login screen.

Circumstances:

* AntiWPA fix, one or more fixes where added.
* WPAEvents blocked.
* Login loop / License already activated / Login screen.
* Safe boot not working.
* Activation fix doesn't work: [Windows activation fix](#Windows Activation )

When try to remove or edit WPAEvents key it fails and doesn't let change ownership nor permissions leading to access denied error. 

This prevents License service to operate so can't extend using the Grace period trick.

Ideal solution: Follow all NOTES from [Windows activation fix](#Windows Activation )

If not works need use more extreme measures check: [Repair WMI and reset WPA status](#Repair WMI and reset WPA status) 

If still not working try to use your original `wpa.dbl` file: `wpa.dbl.old`.

If still not working try these steps:

Steps that I did: [Check this guide as refference]

* Remove AntiWPA from registry.
* Execute this BAT SCRIPT: [WIN2K3_FIXER.bat](WINDOWS2k-XP-ACTIVATION-UTILS%2FWIN2K3_FIXER.bat)
* Remove key WPAEvents since it was blocked
* Setup OOBEtimer with correct bin value.
* Remove key-xxxxx entries at SYSTEM/WPA registry.
* Enable CMD.exe trick
* Run OOBE command to reset grace period.
* Run explorer.exe
* Run again OOBE command to reset grace period from RUN not cmd.exe
* Open regedit.exe 
* Edit HKEY LOCAL MACHINE / system / controlset01 / services / LicenseService / START : 4  (DISABLED)
* Do the same for controlset02
* Remove the CMD.exe trick, in Registry editor  HKEY LOCAL MACHINE / SYSTEM / Setup / cmdline : setup -newsetup
* WPAEvents / permissions set SYSTEM deny.
* You shall be able to enter.


