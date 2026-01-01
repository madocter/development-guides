# Restore Stock ROM on Uniherzt Devices (Titan Slim / Titan Pocket) Using SP Flash Tool

**Purpose:** Uninstall Lineage OS / GSI and restore the original stock firmware.  
**Tools Required:** SP Flash Tool, Stock ROM, USB drivers for MediaTek devices.

---

## 1. Prerequisites

1. **Backup all personal data**  
   Restoring stock ROM will **completely erase your device**.

2. **Download Required Files**
   - SP Flash Tool: [SPFlashTool Download](http://rumplestilzken.com:14005/AndroidDevelopment/Tools/SPFlashTool)
   - Stock ROM for your device: [Stock Resources](http://rumplestilzken.com:14005/Unihertz/StockResources)
   - MediaTek USB drivers (if using Windows)

3. **Charge your device**  
   Ensure the battery is at least **50%** to prevent interruptions.

---

## 2. Install Drivers

- **Windows**: Use MediaTek USB driver installer from Stock Resources
- **Linux/macOS**: Drivers are usually not needed; ensure `sudo` access to USB

---

## 3. Prepare SP Flash Tool

1. Extract SP Flash Tool to a convenient folder on your PC.
2. Extract the Stock ROM to a folder, you should see files like:
   preloader.bin
   boot.img
   system.img
   vendor.img
   vbmeta.img


3. Open `SP Flash Tool` executable.

---

## 4. Load Scatter File

1. In SP Flash Tool, click **"Choose"** next to **Scatter-loading File**.
2. Navigate to the Stock ROM folder and select the scatter file:  
   `MTxxxx_Android_scatter.txt` (MTxxxx = your device’s chipset)
3. SP Flash Tool will load all partitions automatically.

---

## 5. Select Download Mode

1. Select **"Download Only"** to flash Stock ROM without erasing user data (optional).
2. For a full clean restore, select **"Firmware Upgrade"** (recommended after Lineage OS).
> Note: **Firmware Upgrade** will erase everything including `/data`.

---

## 6. Connect Device

1. Power off your device completely.
2. Connect it to PC via USB cable.
3. SP Flash Tool should detect the device automatically when you click **Download**.

---

## 7. Flash Stock ROM

1. Click **Download** in SP Flash Tool.
2. Wait until the progress bar turns **green** and shows **Download OK**.
3. Do **not disconnect the device** until the process finishes.
4. After completion, disconnect USB and power on your phone.

---

## 8. First Boot

- The first boot may take several minutes.
- If the device does not boot, repeat **Firmware Upgrade** in SP Flash Tool.
- Once booted, device should be fully restored to Stock ROM.

---

## 9. Optional: Restore Backup

- If you made a backup before flashing Lineage OS, restore your data after booting into Stock ROM.

---

## Notes & Warnings

- Always use the **correct Stock ROM** for your exact device model (Slim or Pocket). Flashing the wrong ROM can **brick your device**.
- Make sure the USB cable is **stable and functional**.
- SP Flash Tool **cannot be interrupted** during flashing; doing so may require advanced unbricking techniques.
- This guide applies only to **MediaTek-based Uniherzt devices** like Titan Slim / Pocket.


## Problems with SP flash tools in Linux

`sudo nano /etc/udev/rules.d/53-android.rules`

Add These Lines and save:  
`SUBSYSTEM=="usb", SYSFS{idVendor}=="0e8d", MODE="0666"`  
`SUBSYSTEM=="usb", ATTR{idVendor}="0e8d", ATTR{idProduct}="20ff",`

`sudo nano /etc/udev/rules.d/53-MTKinc.rules`

Add These lines and save:  
`SUBSYSTEM=="usb", SYSFS{idVendor}=="0e8d", MODE="0666"`  
`SUBSYSTEM=="usb", ATTR{idVendor}="0e8d", ATTR{idProduct}="20ff", SYMLINK+="android_adb"`  
`KERNEL=="ttyACM*", MODE="0666"`  

`sudo chmod a+rx /etc/udev/rules.d/53-android.rules`  
`sudo chmod a+rx /etc/udev/rules.d/53-MTKinc.rules`  
`sudo udevadm control -R --reload-rules`  
`sudo udevadm trigger`  

If it still doesn't work, reboot.

# References

* http://rumplestilzken.com:14005/AndroidDevelopment/Tools/SPFlashTool