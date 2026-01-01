# Backup tools installation and procedures
How to make full or selective backup / restore, backup IMEI, and install the tools to perform the procedures.

## Requirements

* Some tools Linux os or Windows with WSL + Ubuntu.
* Python 3.8
* Pyenv to switch between different python versions.

Check all this in environment section.

### MTKClient Setup
Download and check readme at repository: https://github.com/bkerler/mtkclien

Usually works only fine under **Linux distributions**

```bash
# Install Python 3.8+
# Install Git

git clone https://github.com/bkerler/mtkclient
cd mtkclient
python -m pip install -r requirements.txt
python mtk_gui.py
```

### For Linux

```bash
# Debian/Ubuntu
sudo apt update
sudo apt install adb fastboot python-pip git

# Arch
sudo pacman -S android-tools python-pip git

# Install MTKClient
git clone https://github.com/bkerler/mtkclient
cd mtkclient
pip install -r requirements.txt
python mtk_gui.py
```

---

- **COMPLETE BACKUP (All Partitions)**:
  ```bash
  # This creates a full backup of EVERY partition
  python mtk rl dumps
  
  # Result: Creates folder "dumps" with files:
  # - boot.bin
  # - system.bin
  # - vendor.bin
  # - nvram.bin (YOUR IMEI!)
  # - nvdata.bin (calibration)
  # - persist.bin
  # - userdata.bin
  # - [all other partitions]
  
  # IMPORTANT: This can take 30-60 minutes depending on storage size
  # USB must stay connected during entire process
  ```

- **SELECTIVE BACKUP (Critical Partitions Only)**:
  ```bash
  # Backup IMEI (MOST CRITICAL)
  python mtk r nvram nvram_backup.bin
  
  # Backup calibration data
  python mtk r nvdata nvdata_backup.bin
  
  # Backup boot partition (for Magisk patching)
  python mtk r boot boot_backup.img
  
  # Backup persist (device configs)
  python mtk r persist persist_backup.bin
  
  # Backup proinfo (device info)
  python mtk r proinfo proinfo_backup.bin
  ```

- **RESTORE OPERATIONS**:
  ```bash
  # Restore IMEI (most common emergency)
  python mtk w nvram nvram_backup.bin
  
  # Restore calibration
  python mtk w nvdata nvdata_backup.bin
  
  # Restore boot partition
  python mtk w boot boot_backup.img
  
  # Restore specific partition
  python mtk w [partition_name] [backup_file.bin]
  
  # CRITICAL WARNING: 
  # - Double-check partition name before writing
  # - Writing wrong file to wrong partition = BRICK
  # - Always verify backup file exists and is correct size
  ```

- **RESTORE COMPLETE DEVICE (Full Restore)**:
  ```bash
  # WARNING: This will completely overwrite your device
  # Only use if you have a complete backup from 'rl dumps'
  
  python mtk wl dumps
  
  # This reads all .bin files from "dumps" folder and writes them back
  # Process takes 30-60 minutes
  # DO NOT disconnect USB during this process
  # Device will reboot automatically when done
  ```

- **VERIFICATION (After Backup)**:
  ```bash
  # List all partitions and their info
  python mtk printgpt
  
  # Check specific partition details
  python mtk r nvram nvram_test.bin
  # Then compare size: should be 524288 bytes (512KB) for most devices
  
  # Verify IMEI is in backup
  strings nvram_backup.bin | grep -E "[0-9]{15}"
  # (On Windows use: findstr /R "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" nvram_backup.bin)
  ```

###  MTK Droid Tools setup
Download from here https://androidmtk.com/download-mtk-droid-tool#google_vignette
Warning have much advertisemeent in the software and the website.

- Older Windows tool for MTK devices
- Features:
  - Create scatter files
  - Read/write partitions
  - IMEI repair
  - Root/unroot
- **Note**: Less reliable than MTKClient on modern devices
- **Backup with MTK Droid Tools**:
  ```
  1. Open MTK Droid Tools
  2. Connect device (it should auto-detect)
  3. Go to "Root, Backup, Recovery" tab
  4. Click "Backup" button
  5. Select partitions to backup
  6. Choose save location
  7. Click "Start"
  ```
- **Restore with MTK Droid Tools**:
  ```
  1. Open MTK Droid Tools
  2. Go to "Root, Backup, Recovery" tab
  3. Click "Restore" button
  4. Select backup files
  5. Click "Start"
  ```

- **Backup Specific partition**:
  ```
  1. Load scatter file
  2. Select "Write Memory"
  3. Choose nvram backup
  4. Flash
  ```

## 🛡️ IMEI & Critical Data Backup (MTK Devices)

### Why Backup is CRITICAL

**Your IMEI is stored in nvram partition:**
- If corrupted: No cellular network
- If lost: Illegal to change in most countries
- Cannot get IMEI back without backup
- Insurance/warranty requires original IMEI

### Method  Engineer Mode (Some Devices)

```
Dial: *#*#3646633#*#* or *#*#4636#*#* or #06#
Navigate to: Connectivity → CDS Information
Note: IMEI 1 and IMEI 2
Take screenshot
```


**Store backups safely:**
- Copy to multiple locations
- Cloud storage (encrypted)
- External USB drive
- Print IMEI on paper
