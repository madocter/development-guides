# Complete Guide: Android Rooting, Custom ROMs & MediaTek Devices

## 🎯 CRITICAL CONCEPT - READ THIS FIRST

### Understanding the Android Ecosystem

Android devices have multiple layers of software and hardware that interact in specific ways. Understanding these layers is crucial before attempting any modifications:

```
Android Device Architecture:
┌─────────────────────────────────────────────────────┐
│ USER LAYER                                          │
│ ├─ Your apps and data                               │
│ └─ Google apps (if GMS certified)                   │
├─────────────────────────────────────────────────────┤
│ SYSTEM LAYER (ROM)                                  │
│ ├─ Android OS (AOSP, LineageOS, etc.)               │
│ ├─ System apps                                      │
│ └─ Framework                                        │
├─────────────────────────────────────────────────────┤
│ VENDOR LAYER                                        │
│ ├─ Hardware drivers                                 │
│ ├─ Camera/sensor libs                               │
│ └─ OEM customizations                               │
├─────────────────────────────────────────────────────┤
│ KERNEL & BOOT                                       │
│ ├─ Linux kernel                                     │
│ ├─ Boot process                                     │
│ └─ Magisk patches THIS layer for root               │
├─────────────────────────────────────────────────────┤
│ FIRMWARE & BOOTLOADER                               │
│ ├─ Bootloader (locked/unlocked)                     │
│ └─ Low-level hardware init                          │
├─────────────────────────────────────────────────────┤
│ PERSISTENT DATA (survives flashing)                 │
│ ├─ IMEI (nvram partition)                           │
│ ├─ WiFi/Radio calibration (nvdata)                  │
│ └─ Hardware identifiers                             │
└─────────────────────────────────────────────────────┘
```

---

## 📚 COMPREHENSIVE GLOSSARY

### Hardware Terms

**SoC (System on Chip)**
- The main processor combining CPU, GPU, modem, and other components
- Examples: Qualcomm Snapdragon, MediaTek Dimensity/Helio

**MediaTek (MTK) Chips**
- Cost-effective SoCs popular in budget and mid-range devices
- Known for: Good performance-per-dollar, extensive community tools
- Common series:
    - **Helio**: Mid-range (P-series, G-series)
    - **Dimensity**: High-end with 5G
    - **MT67xx**: Entry-level chips
- **Key advantage**: MTK has well-documented tools (SP Flash Tool, MTKClient)
- **Consideration**: Bootloader unlock policies vary by manufacturer

**EMMC vs UFS Storage**
- **EMMC** (Embedded MultiMediaCard):
    - Older technology (used 2020-2021)
    - Sequential read: ~250-400 MB/s
    - Found in budget devices
- **UFS** (Universal Flash Storage):
    - Modern standard (2021+)
    - Sequential read: >450 MB/s, often 800+ MB/s
    - UFS 2.1, 3.0, 3.1 versions
- **CRITICAL**: Flashing EMMC firmware on UFS device (or vice versa) = INSTANT BRICK

**How to check your storage type:**
1. Install Androbench from Play Store
2. Run sequential read test
3. If > 450 MB/s = UFS
4. If < 450 MB/s = EMMC

**Regional Variants**
- **EEA** (European Economic Area):
    - Stricter privacy/regulatory compliance
    - Different radio bands
    - May have different pre-installed apps
- **Global/International/NOEEA**:
    - Broader radio band support
    - May lack some regional features
- **CN** (China):
    - No Google services
    - Different system apps
    - Region-locked features
- **IMPORTANT**: Match firmware to your actual hardware variant

**OEM Unlocking**
- Developer option that enables bootloader unlock
- Must be enabled BEFORE unlocking bootloader
- Requires internet connection (Google verification)
- Some carriers/regions disable this option

**Bootloader States**
- **Locked**: Factory state, only official software allowed
- **Unlocked**: Custom software permitted, shows warning on boot
- **Relocked**: Returned to locked state (risky if custom software installed)

### ROM Types & Android Distributions

**Stock ROM (Factory Firmware)**
- Official firmware from device manufacturer
- Pre-installed when device ships
- Contains:
    - Android OS with OEM customizations
    - Vendor-specific apps and UI
    - All proprietary drivers
    - Digital signatures for verified boot
- **Purpose**: Your safety net for recovery
- **Sources**: Manufacturer websites, community archives
- **Example**: MIUI (Xiaomi), One UI (Samsung), OxygenOS (OnePlus)

**AOSP (Android Open Source Project)**
- Pure Android as Google releases it
- Minimal apps, no Google services by default
- Foundation for all custom ROMs
- Very lightweight and fast
- Used by: Google Pixels (stock), custom ROM developers

**LineageOS**
- **Most popular custom ROM worldwide**
- Based on AOSP with improvements:
    - Privacy features (Privacy Guard)
    - Customization options
    - Extended device support
    - Regular security updates
    - No Google apps (must install separately)
- **Why LineageOS matters**:
    - Breathes life into old/unsupported devices
    - Removes manufacturer bloatware
    - Community-driven, open source
    - Often more stable than stock on older devices
    - Supports 200+ devices officially
- **Versions**: LineageOS 20 (Android 13), 21 (Android 14)

**Other Popular Custom ROMs**
- **Pixel Experience**: AOSP with Pixel features
- **Paranoid Android**: Performance + features
- **Resurrection Remix**: Maximum customization
- **Evolution X**: Feature-rich, stable
- **crDroid**: Based on LineageOS with extra features

**GSI (Generic System Image)**
- **What is it**: Universal Android image that works on Treble-compatible devices
- **How it works**:
  ```
  Traditional ROM: [System + Vendor] = Device-specific
  
  GSI with Treble: [Generic System] + [Device Vendor]
                                          ↑
                                   Already on device
  ```
- **Requirements**:
    - Device must support Project Treble (Android 9+)
    - ARM64 architecture (most modern devices)
    - A/B or A-only partition scheme
- **Advantages**:
    - One ROM file works on many devices
    - Faster updates
    - Easy to test different ROMs
- **Disadvantages**:
    - May have device-specific bugs
    - Camera/fingerprint may not work perfectly
    - Less optimized than device-specific builds
- **Popular GSIs**:
    - Phh-Treble AOSP
    - LineageOS GSI
    - AOSP 13/14 GSI builds

**Project Treble**
- Google's initiative (Android 8.0+) to modularize Android
- Separates vendor implementation from Android framework
- Makes GSIs possible
- Check support: `adb shell getprop ro.treble.enabled`

### Magisk & Root Ecosystem

**Root Access**
- Superuser (administrator) permissions on Android
- Allows:
    - Modifying system files
    - Installing powerful apps (Titanium Backup, AdAway)
    - Custom kernels and mods
    - Full control over device
- **Risks**: Security vulnerabilities if misused, warranty void

**Magisk**
- Modern "systemless" root solution
- **How it works**: Modifies boot partition, leaves system untouched
- **Key features**:
    - Root access without modifying /system
    - Hide root from apps (DenyList)
    - Module system for modifications
    - SafetyNet/Play Integrity bypass
- **Current status**: Officially discontinued (last version: 27.0)
- **Community fork**: Magisk Delta continues development

**Magisk Modules**
- Plug-and-play system modifications
- Examples:
    - **LSPosed**: Xposed framework for modern Android
    - **Shamiko**: Advanced root hiding
    - **Universal SafetyNet Fix**: Pass integrity checks
    - **Busybox**: Unix tools on Android
    - **Viper4Android**: Audio enhancement

**Zygisk**
- Magisk feature running at Zygote process level
- Zygote = parent process of all Android apps
- Enables deeper integration for modules
- Required for: LSPosed, some root hiding methods

**DenyList (formerly MagiskHide)**
- Hides root from specific apps
- Apps to hide from:
    - Banking apps (most critical)
    - Google Pay/Wallet
    - Netflix (HD playback)
    - Pokémon GO, banking apps
    - Work profile apps

#### Patching boot partition to enable Magisk

**THE MAGISK PROCESS EXPLAINED:**

```
STEP-BY-STEP MAGISK ROOT PROCESS:

┌─────────────────────────────────────────────────────┐
│ 1. Download GENERIC boot.img from internet          │
│    ├─ Contains: Base Android kernel                 │
│    ├─ Does NOT contain: Your IMEI, calibrations     │
│    └─ Identical for all devices of same model       │
└─────────────────────────────────────────────────────┘
                      ↓ Copy to your device
┌─────────────────────────────────────────────────────┐
│ 2. Magisk PATCHES boot.img ON YOUR DEVICE           │
│    ├─ Reads YOUR hardware configuration             │
│    ├─ Injects root code adapted to YOUR system      │
│    ├─ Configures YOUR device's SELinux              │
│    └─ Generates: magisk_patched.img ← NOW UNIQUE    │
└─────────────────────────────────────────────────────┘
                      ↓ Flash the patched version
┌─────────────────────────────────────────────────────┐
│ 3. Patched boot installed = ROOT WORKING            │
│    └─ This is why: NEVER share your patched boot    │
│       (it's device-specific)                        │
└─────────────────────────────────────────────────────┘

YOUR IMEI IS SAFE because:
┌──────────────────────────────────────────────────┐
│ Device partitions:                               │
│ ├─ nvram      ← YOUR IMEI HERE (NOT touched)     │
│ ├─ nvdata     ← Calibrations (NOT touched)       │
│ ├─ boot       ← ONLY this is modified ✓          │
│ ├─ system     ← System apps (replaced with ROM)  │
│ └─ userdata   ← Your data (wiped on unlock)      │
└──────────────────────────────────────────────────┘
```

It's SAFE to use downloaded boot.img → Magisk customizes it on your device → Your IMEI is never touched.

**HOWEVER**: Making a complete IMEI backup is HIGHLY RECOMMENDED as a safety precaution.


### Security & Integrity Checks

**SafetyNet (Deprecated)**
- Old Google integrity check system
- Three levels:
    - **basicIntegrity**: Device runs legitimate Android
    - **ctsProfileMatch**: Device meets compatibility standards
- **Status**: Replaced by Play Integrity API in 2023

**Play Integrity API**
- New verification system with three verdict levels:

  **MEETS_BASIC_INTEGRITY**
    - Device runs Android-compatible OS
    - Basic app functionality works
    - Easiest to pass with Magisk

  **MEETS_DEVICE_INTEGRITY**
    - Device uses Google-approved software
    - No unauthorized modifications
    - Harder with unlocked bootloader
    - Required by: Most banking apps, Google Wallet

  **MEETS_STRONG_INTEGRITY**
    - Hardware-backed attestation
    - Locked bootloader required
    - Nearly impossible with root/custom ROM
    - Required by: Some high-security banking apps

**How to check your status**:
1. Install "Play Integrity API Checker" from Play Store
2. Run check
3. Use modules like "Play Integrity Fix" if needed

### Flashing Tools

**ADB (Android Debug Bridge)**
- Command-line tool for device communication
- Common commands:
  ```bash
  adb devices              # List connected devices
  adb reboot bootloader    # Reboot to fastboot
  adb push file /sdcard/   # Copy file to device
  adb shell                # Access device terminal
  adb logcat               # View system logs
  ```

**Fastboot**
- Protocol for flashing partitions in bootloader mode
- Common commands:
  ```bash
  fastboot devices           # Check connection
  fastboot flash boot boot.img   # Flash boot partition
  fastboot oem unlock        # Unlock bootloader
  fastboot reboot            # Reboot device
  ```

**SP Flash Tool (MediaTek Devices)**
- Official MTK flashing software
- **Capabilities**:
    - Flash complete stock firmware
    - Flash individual partitions
    - Format device
    - Memory test
- **CRITICAL for MTK**: Essential for unbricking
- **Download-Agent**: Required file for communication
- **Scatter file**: Partition map (addresses, sizes, files)

**MTKClient (Python-based)**
- **Most powerful MTK tool**
- **Features**:
    - Read/write partitions without unlock
    - Backup IMEI and critical data
    - Unlock bootloader
    - Flash firmware
    - Exploits MTK bootrom

**MTK Droid Tools**
- Older Windows tool for MTK devices
- Features:
    - Create scatter files
    - Read/write partitions
    - IMEI repair
    - Root/unroot
- **Note**: Less reliable than MTKClient on modern devices

**QPST/QFIL (Qualcomm)**
- Qualcomm's flashing software
- Used for Snapdragon devices
- Requires EDL (Emergency Download) mode

### Partition Structure

**Traditional Partition Layout**
```
├── boot        (kernel, ramdisk)
├── system      (Android OS)
├── vendor      (hardware drivers)
├── userdata    (user apps/data)
├── cache       (temporary files)
├── recovery    (recovery OS)
├── persist     (calibration data)
├── modem       (radio firmware)
├── nvram       (IMEI, MAC address)
└── misc        (bootloader settings)
```

**Modern Dynamic Partitions (Android 10+)**
```
super partition contains:
  ├── system
  ├── vendor
  ├── product
  └── (resizable on-the-fly)
```

**Critical Partitions (DO NOT TOUCH)**
- **nvram/nvdata**: Contains IMEI - if corrupted = no network
- **persist**: Device calibration data
- **proinfo**: Persistent device info

**boot.img Contents**
```
boot.img contains:
├── kernel          (Linux kernel)
├── ramdisk         (initial filesystem)
├── dtb             (device tree)
└── boot parameters (cmdline)

Magisk modifies:
└── ramdisk ← Injects su binary and scripts here
```

**vbmeta.img (Verified Boot Metadata)**
- Contains cryptographic signatures
- Verifies system integrity
- **Must be disabled** for custom ROMs
- Disable with: `fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img`

**super.img / super.new.img**
- Large partition containing multiple sub-partitions
- Created with `mksuper` tool during ROM build
- Can be hundreds of MB to several GB
- Must match device's super partition size

---

## ⚠️ CRITICAL WARNINGS

### Before You Start

**1. Complete Data Backup**
- Bootloader unlock = factory reset (guaranteed)
- Export:
    - Photos/videos to PC or cloud
    - Contacts (Google/VCF export)
    - App data (if possible)
    - WhatsApp chats (Settings → Chats → Backup)

**2. Identify Your EXACT Device Model**
- Go to: Settings → About Phone
- Note down:
    - Build number
    - Android version
    - Model number
    - Regional variant
- Run Androbench storage test
- **Confirm EMMC vs UFS**

**3. Never Mix Firmware Types**
- EMMC firmware on UFS = HARD BRICK
- Wrong regional variant = potential issues
- Always triple-check downloads

**4. Battery Charge**
- Minimum 80% before starting
- Power loss during flash = brick
- Keep charger connected

**5. Magisk Version Compatibility**
- **Unihertz Titan Pocket**: Magisk 25.2 ONLY
- **Reason**: v27+ removed "Patch vbmeta" option
- Check device-specific forums for requirements

**6. Bootloader Unlock = Warranty Void**
- Check local laws (EU has right-to-repair protections)
- OEM warranty will be voided
- Some apps will detect unlocked bootloader

### Safety Checklist

✅ Full backup completed  
✅ Stock ROM downloaded and verified  
✅ MTKClient backup created (if MTK device)  
✅ Correct firmware for device variant confirmed  
✅ Battery >80%  
✅ USB cable is high quality (data transfer confirmed)  
✅ ADB/Fastboot drivers installed  
✅ Emergency recovery plan prepared

---

## 📖 Understanding the Process

### Why Root Your Device?

**Advantages:**
- Remove bloatware permanently
- Full system backups (Titanium Backup)
- Ad blocking system-wide (AdAway)
- Custom kernels for battery/performance
- Advanced automation (Tasker with root)
- File system access for development
- Modify system fonts, boot animation
- Install Xposed/LSPosed modules

**Disadvantages:**
- Security risk if malicious app gets root
- Banking/payment apps may not work
- OTA updates usually break
- Warranty void
- Some DRM content unavailable
- Learning curve for safe usage

### Why Install Custom ROM?

**Benefits:**
- Latest Android version on old devices
- Better battery life (usually)
- Remove OEM bloat completely
- Privacy improvements (LineageOS Privacy Guard)
- More customization options
- Active community support
- Regular security patches (LineageOS)

**Considerations:**
- Camera quality may decrease
- Some hardware features may not work
- Stability varies by ROM/device
- Initial setup time
- Learning curve

---


## 🚀 Understanding Different Flashing Scenarios

### Scenario 1: Stock ROM to Rooted Stock

**Goal**: Keep stock ROM but gain root  
**Process**:
1. Unlock bootloader
2. Download stock boot.img
3. Patch with Magisk
4. Flash patched boot
5. Install Magisk Manager

**Pros**: Maximum stability, all features work  
**Cons**: Still have bloatware, limited customization

### Scenario 2: Stock ROM to Custom ROM (LineageOS)

**Goal**: Replace everything with custom ROM  
**Process**:
1. Unlock bootloader
2. Flash custom recovery (TWRP)
3. Wipe data/cache/system
4. Flash LineageOS ZIP
5. Flash GApps (optional)
6. Flash Magisk (optional)

**Pros**: Clean system, privacy, updates  
**Cons**: Setup time, potential bugs

### Scenario 3: GSI Installation

**Goal**: Universal Android on Treble device  
**Process**:
1. Verify Treble support
2. Unlock bootloader
3. Flash GSI system.img with fastboot
4. May need custom vendor
5. Boot and configure

**Pros**: Easy to try different ROMs  
**Cons**: Device-specific features may not work

### Scenario 4: Emergency Unbrick (MTK)

**Goal**: Recover hard-bricked device  
**Process**:
1. Download stock ROM + scatter
2. Install SP Flash Tool
3. Load scatter file
4. Format + Download
5. Power off device
6. Connect USB while holding Volume Up
7. Wait for flash completion

**When needed**:
- Bootloop after bad flash
- Can't access fastboot/recovery
- Corrupted partitions

---

## 📝 Best Practices

**1. Always Verify Downloads**
- Check MD5/SHA256 hashes
- Download from official sources only
- Compare file sizes with stated sizes

**2. Read Before Flashing**
- Device-specific forum threads
- Known issues/bugs
- Compatibility requirements

**3. Flash Incrementally**
- Test boot after each major step
- Don't flash everything at once
- Easier to identify problems

**4. Keep Stock ROM Archive**
- Download immediately after purchase
- Store safely offline
- Verify hash periodically

**5. Document Your Process**
- Screenshot settings before unlock
- Note working configurations
- Save successful commands

**6. Community Resources**
- XDA Developers forums
- Reddit: /r/LineageOS, /r/Magisk, /r/Android
- Telegram groups for specific devices
- Device-specific Discord servers

---

## 🔍 Troubleshooting Common Issues

**Bootloop After Root**
- Cause: Incompatible Magisk version
- Fix: Flash stock boot.img via fastboot, start over

**SafetyNet/Play Integrity Failing**
- Solution: Install Universal SafetyNet Fix module
- Check: MagiskHide/DenyList enabled
- Consider: Shamiko module for better hiding

**Device Not Detected in Fastboot**
- Fix: Install proper drivers (15 seconds rule for MTK)
- Try: Different USB port/cable
- Enable: USB debugging AND OEM unlock

**Custom ROM Boot Issues**
- Check: Did you wipe cache/data?
- Verify: Downloaded correct variant
- Try: Re-flash vendor/firmware

**Camera Quality Degraded**
- Reason: Missing proprietary libs
- Solution: Install ANXCamera/GCam mod
- Alternative: Flash stock camera app

**IMEI: Null or Invalid**
- CRITICAL: Restore nvram backup immediately
- Prevention: Always backup nvram first
- Note: Can't generate valid IMEI legally

---

## 📚 Additional Resources

**Official Documentation**
- LineageOS Wiki: wiki.lineageos.org
- Magisk Documentation: topjohnwu.github.io/Magisk/
- Android Developer: developer.android.com

**Community Forums**
- XDA Developers: xdaforums.com
- Reddit: r/LineageOS, r/Magisk
- Telegram: Search device name + "dev"

**Tools**
- MTKClient: github.com/bkerler/mtkclient
- SP Flash Tool: spflashtools.com
- Platform Tools: developer.android.com/tools

**ROM Repositories**
- LineageOS: download.lineageos.org
- Phh-Treble GSI: github.com/phhusson/treble_experimentations
- PixelExperience: download.pixelexperience.org

---

## ⚖️ Legal & Ethical Considerations

**Legal to Modify**
- Unlocking bootloader: Legal in most countries
- Installing custom ROM: Legal everywhere
- Rooting: Legal (yours to modify)

**Illegal/Unethical**
- Changing IMEI: Illegal in most jurisdictions
- Bypassing paid apps: Piracy
- Removing DRM for distribution: Copyright violation
- Stalkerware/spying apps: Often illegal

**Warranty Impact**
- USA: Magnuson-Moss Act may protect you
- EU: Right to repair laws provide some protection
- Check local laws before proceeding

**Remember**: With great power comes great responsibility. Root access can harm your device if misused. Always research before modifying system files.

---

## 🎓 Conclusion

This guide provides the foundation for understanding Android modification. Every device has unique quirks—always consult device-specific guides on XDA or LineageOS wiki before proceeding.

**Key Takeaways:**
- Backups are non-negotiable
- Verify everything before flashing
- Storage type matters (EMMC vs UFS)
- GSI ≠ Custom ROM ≠ Stock ROM
- MTKClient is essential for MediaTek devices
- Community is your best resource

**Ready to proceed?** Start with backups, then move methodically through each step. Good luck!