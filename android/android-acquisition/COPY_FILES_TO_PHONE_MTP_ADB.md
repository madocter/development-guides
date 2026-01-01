# ADB
Android development bridge.

### Steps

1. **Download ADB**:
   - Download the Android Debug Bridge (ADB) tool from its [official website](https://developer.android.com/studio/releases/platform-tools) on your PC.
   - Is available for Windows and Linux.
2. **Enable USB Debugging**:
   - On your Android phone, enable USB debugging in the Developer Options.
   - Note: Each phone may require different steps to enable USB debugging; refer to your device’s documentation or search online for specific instructions.
   - Connect the phone to your PC via USB.

Example usage to copy whatsapp databases:

```bash
adb pull /storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Databases ./Databases
adb pull /storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Backups ./Backups
```

Using ADB to copy is the best option but in Windows might lead to error because of long or non-supported Windows file names, example: `.statuses/092380192380-2343434.jpge`.

Example os usage to do a stream in to a zip file to avoid file names errors:

```bash
adb pull /sdcard/ backup-target
adb shell "cd /sdcard && tar -cf - Android" | tar -xf - -C ~/Documents/PHONE
```

**Note:** `/sdcard/` is an alias that resolves to: `/storage/emulated/0/`

I would use ADB to copy whatsapp and DCIM the pictures of the phone which in total can be like 80GB in thousand of different files which is really hard to make it work with MTP, FTP.

# MTP
Multimedia transfer protocol, is used to bind phone to pc using usb cable.

Using Windows explorer will take long time calculating before copy start, and then it will probably stop after sometime giving some error, windows also is very problematic with certain long names even after applying patches.

# FTP
This protocol is bad designed for transferring multiple files it will timeout eventually and stuck because of multiple reasons timeout, regadless of FTP client setup, computer sleep or hibernate, phone disconnet.

After 2 or 3 attempts shall be possible make complete backup. 

Recommended software:
Phone: CX file exporer and enable FTP access, and do not run in to other task otherwise might disconnect clients.
PC: Filezilla.

# Phone software

There are some tools such as: airdroid to help to back up files, contacts, calls, etc...

# Computer software

* MTKClient can easily with graphic interface completely backup all ROM partitions from MTK devices including **user-data** partition which contains all data.
      * Usually works well with Ubuntu, never work at all in Windows regardlesss of drivers tweaks etc... in my case.
* SP Flash Tool with scatter file can restore stock (factory) ROM in to your phone in case of brick.




