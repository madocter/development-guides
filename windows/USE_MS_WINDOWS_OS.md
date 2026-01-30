# windows
Today need windows that is compatible with latest software such as docker, LM studio, and so on.

I do not want automatic updates giving me headcache, stupid garbage that come with windows, create a MS365 account etc.

Use 

*  Windows 10 Enterprise LTSC 2021 (64-Bit)  

This is the version for industrial usage and long term support, licenses are cheap too.

https://massgrave.dev/windows_ltsc_links

### Activate
Activation might be challenging:

https://github.com/n8tbyte/win10-enterprise-ltsc-activation

The method 2 is working make sure disable rael time protection, use Firefox to be able to download the file o transfer to the pc directly, set exception to the folder at windows defender.

To copy the files at system32 need to rename the directories  
    csvlk-pack
    EnterpriseS

Adding for instance a _ or any character then copy directories from the repository and copy original windows files but without replace, this is little hack to avoid permission issue.


Here can find interesting stuff for activation.
https://massgrave.dev/


### Disable updates 

services.msc

Locate windwos update stop , disable, but anyway will be enabled automatically again do this temporary.

Use group policies

gpedit.msc

Computer management
 → Administrative templates
 → Windwos components
 → Windows Update
 
 Here disable all features which might force updates, or prevent you from setup updates.
 
 For instance "Download but do not isntall" 
 
 Customize to prevent MS updating ur computer without your permission.
 
 ### Prevent sleep
 
 Screen lock settings
 
 Setup for never sign out
 
 powercfg.cpl
 
 Setup for never hibernate
 
 In case u need server.