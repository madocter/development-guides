# How to Extract All Data from WhatsApp

Follow these steps to extract all your WhatsApp data, including messages, in a secure and comprehensive way.


## Steps

### Manual export:
There is no automatic export chat function for all chats in case you want to export your chats and media using whatsapp export function you will have to do it manually with all chats, if you have patience still a good option in case u want to check your whatsapp from other device without depend on Whatsapp software.


### Root phone:

If you had **root** your phone is easier just copy those directories:

`/data/data/com.whatsapp/files/key`
`/data/data/com.whatsapp/databases/msgstore.db`
`/data/data/com.whatsapp/databases/wa.db`

key is the cypher key for `msgstore`, `msgstore.db` are the database which contains all messages, and `wa.db` the names of the contacts.

As for media files of whatsapp is located here: `\Android\media\com.whatsapp\WhatsApp\Media`


### No root phone:

1. **Open WhatsApp** on an Android phone that contains all the messages you want to extract.
2. Go to **Backup Settings**:
    - Navigate to `Settings -> Chats -> Chat backup` (path may vary in future versions of WhatsApp).
3. **Manage End-to-End Encrypted Backup**:
    - If backup encryption is **disabled**, proceed to Step 4.
    - If encryption with a **password** is enabled, disable it and proceed to Step 4.
    - If encryption with a **64-digit encryption key** is enabled and you **don’t know the key**, disable it and proceed to Step 4.
    - If encryption with a **64-digit encryption key** is enabled and you **know the key**, proceed to Step 5.
4. **Enable Backup Encryption**:
    - Choose to use a **64-digit encryption key**.
    - After the key is generated, **take note of it**, as it will be needed later.
    - It will prompt you to perform a new backup click on yes.
5. **Perform backup**:
    - If it didn't prompt to perform a new backup do it manually.
    - It will start with the database first once it reach the 100% will start with files in background
    - As for the files is possible to cancel there is no need to back-up encrypted media.
    - The backup nowadays in theory is CLOUD only, but it will generate database files at the phone storage **locally**.
6. **Database files**:
    - They can be found in the following location:
    - `Android/media/com.whatsapp/WhatsApp/Databases ./Databases`
    - `Android/media/com.whatsapp/WhatsApp/Backups ./Backups` 
    - Now copy them connecting the phone to the computer, or with ADB: [COPY_FILES_TO_PHONE_MTP_ADB.md](COPY_FILES_TO_PHONE_MTP_ADB.md)
    - Example of ADB: (Note `/sdcard/` is an alias that resolves to: `/storage/emulated/0/` )
   ```bash
   adb pull /storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Databases ./Databases
   adb pull /storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Backups ./Backups
   ```


# Decrypt and view the database

## Steps

1. **Decrypt the Encrypted Files**:
    - Use the encrypted `.crypt15` files and the 64-digit encryption key with the tool [wa-crypt-tools](https://github.com/ElDavoo/wa-crypt-tools).
    - Example command:
      ```bash
      wadecrypt <64digitkey> msgstore.db.crypt15 msgstore.db
      ```
   - Without `wadecrypt` Command resolution via $PATH but with python invocation :
     ```bash
     cd \wa-crypt-tools-0.1.0\src\wa_crypt_tools\
     python .\wadecrypt.py <64digitkey> msgstore.db.crypt15 msgstore.db
     ```

2. **View the Decrypted Database**:
    - The decrypted `.db` files can be opened and viewed using any SQLite explorer: https://sqlitebrowser.org/dl/
    - Investigate the database design to navigate the decrypted results. The structure is straightforward, and table names are descriptive.
    - Use `Whatsappviewer` opensource tool https://github.com/madocter/whatsapp-viewer/releases
      - This can't see media files yet, such as: audio notes, stickers, images.
    - Use commercial solution tool: https://www.backuptrans.com/iphone-whatsapp-to-android-transfer.html
      - This solution is pretty good can open media files.
      - To import media to copy all your whatsapp media with MTP (copy files manually) or ADB command:
        - This is the media directory `\Android\media\com.whatsapp\WhatsApp\Media`
        - Place it in the same level that `msgstore.db` otherwise you will see : `Media directory not found do you want to import without media ?` which makes you unavailable to see media content.
      - To import the chat database: `File/Import Android Whatsapp Backup Data`. Then select your msgstore.db, or click on: `Local database/Import Android Whatsapp Backup Data`.
      - You can test with 20 messages for free, if convinces you is 29 USD lifetime license for 3 devices, otherwise use opensource with its limitations.
      - Other interesting function is to transfer whatsapp to another Android or IOS phone from the copy that you have in your computer.

# Import whatsapp backup from PC to Android

## Steps

### Commercial solution
You can use commercial solution backuptrans: https://www.backuptrans.com/iphone-whatsapp-to-android-transfer.html

* Open the software
* Plug the phone previously enabled usb debug option
* Click on the icon: `Transfer messages from Database to Android phone`.

### Root solution

If your phone is root you can in theory (not tested) just copy previous backup in the directories following previous model:

* Stop whatsapp process completely.
* Copy the files to the android storage, following this model and using previous backup:
`/data/data/com.whatsapp/files/key`
`/data/data/com.whatsapp/databases/msgstore.db`
`/data/data/com.whatsapp/databases/wa.db`
`/Android/media/com.whatsapp/WhatsApp/Media`


---

### Notes:
- Handle the 64-digit encryption key and decrypted data carefully to ensure your privacy and security.
- If you want to merge different whatsapp version might check: https://github.com/salozubz/WhatsApp-Db-Merger/tree/main
