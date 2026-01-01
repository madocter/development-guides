# Titan Slim & Titan Pocket – Lineage OS 20 Installation Guide

⚠️ Warning: This process will completely wipe your phone.

## Before start

- [x] Read basic concepts
- [x] Perform personal files backup
- [x] Perform ROM and IMEI backup.
- [x] To flash Slim or Pocket need Linux (debian or ubuntu) and if windows have WSL + Ubuntu. 

Make sure to have these actions done.

## Tricks
If the phone do not respond after use some tool such as: ADB, fastboot, MTKclient, SP flash tool, MTK droid tool, etc...

Hold power and volume up for 25 seconds it will restart.

If you see dead android just press power, then volume up and release, a menu will appear.

## Requirements

### Windows drivers
Windows needs drivers to operate with the phone.
[Windows MTK drivers](http://rumplestilzken.com:14005/Unihertz/StockResources?action=AttachFile&do=view&target=Driver_Auto_Installer_EXE_v5.1632.00.zip)

### Platform tools to operate with ADB and fastboot:
Download [Platform tools](https://developer.android.com/tools/releases/platform-tools)

**Windows installation**
```
Download: Android SDK Platform Tools
Install to: C:\adb\
Add to PATH:
  - System Properties → Environment Variables
  - Edit PATH → Add "C:\adb\"
Test: Open CMD, type "adb version"
```

**Linux installation**
```bash
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt-get update
sudo apt-get install android-tools-adb android-tools-fastboot
```

### Magisk version 25.2
Download [Magisk 25.2](https://github.com/topjohnwu/Magisk/releases/download/v25.2/Magisk-v25.2.apk)

### Stock rom
Download [Stock ROMS](http://rumplestilzken.com:14005/Unihertz/StockResources)

Important download appropriated rom according to ur model:

EEA: European phone.  
TEE: International rom

This is default factory room which is necessary.
- To create super partition in case of Pocket and Slim, later with **Mksuper**.
- To use `boot.img` and patch it with magisk (To set the generic boot with your phone parameters and enable Magisc).
- To back up your phone in case of brick with SP flash tools, MKTclient, and other tools. **Check backup and restore README**

We have available stock rom but is possible create one with [MTK droid tool](https://androidmtk.com/download-mtk-droid-tool)
But process is complicated.

### Gargoyle GSI image  
This is Lineage OS GSI binary to flash in to the phone but with additions and customizations for Uniherzt titan Pocket for Keyboard etc... example [Proccess without Gargoyle](https://catwithcode.moe/Blog/2023.05.24_Unihertz_Titan-Slim_GSI_Modding/Unihertz_Titan-Slim_GSI_Modding.html)

https://github.com/rumplestilzken/gargoyle_lineageos20/releases

Go to assets and download the according to your model.
- `gargoyle_pocket_vndklite_bvN_v1.5.img.xz`: Vanilla: without Google Apps AKA GAPPS.
- `gargoyle_pocket_vndklite_bgN_v1.5.img.xz`: Google: with GAPPS preinstalled.

Can install GAPPS alternative latter such as MicroG or Wackos mentioned in this guide.  
Can latter also unistall official GAPPS and install alternative too.

### Mksuper (only for Titan Pocket, Titan Slim, Tank, Tank Mini)  
Download this as a ZIP to later usage, also save the link to check Mksuper instructiosn.  
https://github.com/madocter/mksuper

**Mksuper requirements**  
Python 3.10.18  
Linux (Ubuntu / Debian recommended)  
On Windows: WSL + Ubuntu

## 1 Unlock Bootloader via Fastboot
Enable flashing on the device with ADB.

* Enable Developer Options (Phone)
  * Go to `Settings → System → About Phone`.
  * Tap `Build Number` 7 times to enable developer options. 
  * Enable `USB Debugging` & `OEM Unlock`
* Connect phone via USB cable to your PC with installed ADB tools. 
* Go to `platform-tools` directory and open a terminal there to invoke the **ADB** and **Fastboot** commands. (If installed platform-tools with Path can invoke from anywhere) 
  * `adb devices`           # Check device is detected 
  * `adb reboot bootloader` # Reboot into fastboot 
  * `fastboot devices`       # Verify device in fastboot 
  * `fastboot flashing unlock`
  * On phone: **confirm unlock** with **Volume UP**
* `fastboot getvar unlocked` # To confirm bootloader is unlocked 
* `fastboot reboot`

Your phone will reboot and be wiped.

Enable again USB debugging and OEM Unlock

## 2 Root Your Device

**Requirements**
- Bootloader must be unlocked.  
- stock ROM for your region.


### 2.1 Patch Boot Image with Magisk
* Enable `USB debugging` if not already done. 
* Extract `boot.img` from stock ROM previously downloaded (Sometimes can be `boot-verified.img` depending on the Stock bundle).
* Put the `boot.img` in some directory inside the phone, to patch it later with magisk:
  * ADB: `adb push stock-rom/boot.img /sdcard/downloads` (Note: `/sdcard/` is an alias that resolves to: `/storage/emulated/0/`)
  * Alternative: Just by USB transfer copy it manually.
* Install Magisk apk on the phone:
  * ADB: `adb install -r Magisk-v25.2.apk`
  * Alternatie: Copy the APK and execute from file explorer, make sure Install unknown apps is enabled on the phone.
    * `adb push Magisk-v25.2.apk /sdcard/downloads`
* In the phone, open Magisk app:
  * Install → select `boot.img` in the destination that you previously placed it.

***⚠️IMPORTANT*** For Pocket and Slim: Do not check `vbmeta patch` option.

- Copy **patched boot.img** back to your PC, probably something like: `magisk_patched-25200_8bAlU.img`:
  - `adb pull /storage/emulated/0/Downloads/magisk_patched-25200_8bAlU.img ./magisk-boot`
    - Alternative: Just by USB transfer copy it manually

* Flash patched boot image:
  * `adb reboot bootloader`
  * `fastboot flash boot <magisk-boot.img>`
  * `fastboot reboot`

* Verify Root:
  * adb shell # Open ADB console on the computer 
  * su
  * mount -o remount,rw /
  * touch /system/delete_me

If no errors, your device is successfully rooted.  
To exit adb shell disconnect your phone and reconnect it back.

## 3 Prepare Lineage OS Image for Flashing [ONLY Slim and Pocket]

***⚠️IMPORTANT*** These steps only necessary for Slim and Pocket versions.

This program must be executed in Linux machine


Extract mksuper zip or clone the repository.  
Check the repository readme as reference.

* Put stock ROM inside `mksuper` directory
  * Can be the ZIP file you downloaded from rumplestilzken stock resources. In this case the script will detect teh zip automatically when you run `extract.py`.
  * Can be stock ROM from other sources and or unzipped already in a directory example `stock-rom`. In this case we need specify the directory with `-stock option` latter when running `extract.py`.
* Put the Gargoyle img inside `mksuper` directory and extract if tar.gz, zip or .xz compressed file.
    * If the downloaded version is **bgN** set latter `-no-product` whe running `mksuper.py` script to avoid incorrect partition size error.
  * The img file will be detected automatically but can also specify filename with `-gsi` parameter when running mksuper.py.

**Note:** assuming you have requirements and had read mksuper readme.

* Open terminal inside mksuper directoy:
  * `python install-dependencies.py` # Download required dependencies.
  * `python extract.py -stock <path_to_extracted_stock_rom|stock_rom_zip_file>` # Extract partitions from stock ROM.
  * `python mksuper.py -gsi <gargoyle_lineage_os_image> [-dev pocket|slim] [-no-product for GApps (bgN)]`

The output image will be at `mksuper/super/super.new.img`  
Debug info: The lpmake command will be printed during execution — it's normal to see "Invalid sparse file format" warnings.



## 4 Flashing Lineage OS

###  Titan Slim or Titan Pocket  
Reboot to bootloader:

`adb reboot bootloader`

Flash partitions from stock ROM: **Take the files from STOCK ROM: [vbmeta.img, vbmeta_system.img, vbmeta_vendor.img]**

`fastboot flash --disable-verity --disable-verification vbmeta vbmeta.img`  
`fastboot flash --disable-verity --disable-verification vbmeta_system vbmeta_system.img`  
`fastboot flash --disable-verity --disable-verification vbmeta_vendor vbmeta_vendor.img`  
  
Flash super partition with Lineage OS  
`fastboot flash super mksuper/super/super.new.img`


Clear caches:

`fastboot erase cache`  
`fastboot erase userdata # Skip if not coming from stock ROM`  
`fastboot reboot`


###  Titan model
`adb reboot bootloader`  
`fastboot erase system`  
`fastboot erase cache`  
`fastboot erase userdata # Skip this step if you are not coming from stock rom`
(Not necessary clean user data)  
`fastboot flash system <gargoyle.img>`  
`fastboot reboot`

Your device should now boot into Lineage OS 20.

## 5 Post-Installation (Titan Slim / Pocket)

Recommended Settings

Headphone Jack Fix:
Settings → Phh Treble Settings → Misc Features → Use alternate way to detect headset → reboot.

Enable VoLTE:
Settings → Phh Treble Settings → IMS Features → Check Request IMS Network → install IMS APK → reboot.

Disable Navigation Bar (Optional):
Settings → Phh Treble Settings → Misc Features → Force navigation bar disabled → reboot.

## 6 Optional: Google Apps

Download Wacko's Magisk module for Google Apps. https://github.com/wacko1805/MagiskGapps follow instructions in the repository.

Install module:

Magisk → Modules → Install from storage → select wacko module → reboot.

If "Not Certified" error appears:

Register device at Google Certification site:

https://www.google.com/android/uncertified


Use your device ID obtained via:

Phone: Settings > System > Developer settings > enable debugging with root.

`adb root`
`adb shell 'sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name=\"android_id\";"'`

Copy device identification, paste it to the site in step 7e, check you are not a robot and hit Register button.

Wait few until you are able to log in to your Google account from the phone

Log in to Google account.

After factory resets, repeat certification steps if needed.

To sync contacts properly, enable contacts permissions in Google Play Services.

# References

* http://rumplestilzken.com:14005/AndroidDevelopment/gargoyleGSI
* https://github.com/rumplestilzken/gargoyle_lineageos20/releases
* http://rumplestilzken.com:14005/Unihertz/StockResources
* http://rumplestilzken.com:14005/AndroidDevelopment/Tools/SPFlashTool
* https://catwithcode.moe/Blog/2022.08.07_Unihertz_Titan_GSI_UFS/Unihertz_Titan_GSI_UFS.html
* http://rumplestilzken.com:14005/AndroidDevelopment/gargoyleGSI?action=AttachFile&do=view&target=TitanSlimLOS.pdf