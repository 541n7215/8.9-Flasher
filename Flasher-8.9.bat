@echo off
title Flasher
color A
echo +=================================================================+
echo +                              Flasher	                          +
echo +                          By Anonymous.123                       +
echo +=================================================================+
echo.
echo.
echo This batch file is only intended to flash the 2nd Bootloader and TWRP recovery  to the Kindle Fire HD 8.9"(2012) which has a front facing camera.
echo I am not responsible if your device gets bricked due to using this tool.
echo Hit Enter ONLY if you want to continue.
@pause > nul
:CHOICE
cls
echo Alright Then...
echo.
echo.
echo 1:Verify Device(recommended)
echo 2:Backup(recommended)
echo 3:Flash 2nd Bootloader and TWRP(must)
echo 4:Restore Backup(only if you've done option 2)
echo 5:Reboot into recovery
echo.
set /p choice=Type your choice and hit enter:
if %choice% == 1 goto :VERIFY
if %choice% == 2 goto :BACKUP
if %choice% == 3 goto :FLASH
if %choice% == 4 goto :RESTORE
if %choice% == 5 goto :REBOOT
goto CHOICE
:VERIFY
cls
echo You can verify which device you have by fastboot. So let's do it.
:FASTBOOT
cls
echo I repeat,this is only for advanced users!Please exit if you don't know what fastboot means!
@pause > nul
echo At first,disconnect your Kindle from the PC.
pause
echo Then,turn it off
pause
echo When the "waiting for device" sign comes on,connect it via USB
pause
echo Ready?
pause
files\fastboot -i 0x1949 getvar product
echo OK,now your kindle should be in Fastboot mode and the above command should return something like Jem-XXX-XX. Note it down.
pause
echo Let's get it out of Fastboot.
files\fastboot -i 0x1949 reboot
set /p fast=Did it return somthing like Jem-XXX-XX?(y/n)
if %fast%== n exit
goto PASS
:PASS
echo Very good!Now you can contunue.
goto CHOICE
:BACKUP
cls
echo Now we will backup the system,boot and recovery partitions.
echo Connect your Kindle to the PC with Android Debugging enabled.
echo Ready?
pause
files\adb kill-server
files\adb start-server
files\adb wait-for-device
files\adb shell su -c "dd if=/dev/block/mmcblk0boot0 of=/sdcard/boot0block.img"
echo Backing up boot...
files\adb shell su -c "dd if=/dev/block/platform/omap/omap_hsmmc.1/by-name/boot of=/sdcard/stock-boot.img"
echo Backing up recovery...
files\adb shell su -c "dd if=/dev/block/platform/omap/omap_hsmmc.1/by-name/recovery of=/sdcard/stock-recovery.img"
echo Backing up system(this will take some time)...
files\adb shell su -c "dd if=/dev/block/platform/omap/omap_hsmmc.1/by-name/system of=/sdcard/stock-system.img"
mkdir C:\BackupFiles
echo Now we will pull those files to your PC.
files\adb pull /sdcard/boot0block.img C:\BackupFiles
echo Pulling boot...
files\adb pull /sdcard/stock-boot.img C:\BackupFiles
echo Pulling recovery...
files\adb pull /sdcard/stock-recovery.img C:\BackupFiles
echo Pulling system(this will take some time)...
files\adb pull /sdcard/stock-system.img C:\BackupFiles
echo All done!Now you should find a folder in your C Drive named BackupFiles.If you mess things up,flash those in fastboot to go completely stock.
pause
goto CHOICE
:FLASH
cls
color 4
echo Warning!Please close this Window if you don't know what You're doing!
echo Hit enter ONLY if you want to continue!
@pause > nul
echo Are you sure?
pause
color A
cls
echo OK then...
echo Connect your device with Android Debugging Enabled.
pause
echo Unlock it.
pause 
echo At first,let's install the stack override.
files\adb push files\stack /sdcard/
files\adb shell su -c "dd if=/sdcard/stack of=/dev/block/platform/omap/omap_hsmmc.1/by-name/system bs=6519488 seek=1"
pause
cls
echo Now let's disable the auto recovery update script.
files\adb shell su -c "mount -o remount,rw ext4 /system"
files\adb shell su -c "mv /system/etc/install-recovery.sh /system/etc/install-recovery.sh.bak"
files\adb shell su -c "mount -o remount,ro ext4 /system"
echo The easy part is done!
pause
cls
echo Now for the hard part.
echo Disconnect your device.
echo Turn it off.
echo When the "waiting for device" sign comes on,plug it in and it should boot into fastboot.
echo Ready?
pause
cls
files\fastboot -i 0x1949 reboot-bootloader
echo Now your Device should be in fastboot mode.
echo At first,let's downgrade the bootloader to 8.1.4 so that it can be modded.
files\fastboot -i 0x1949 flash bootloader files\8.1.4-boot.bin
echo Now let's flash the 2nd Bootloader/freedom boot.
files\fastboot -i 0x1949 flash boot files\freedom-boot-8.4.6.img
echo Finally,let's flash the famous TWRP Recovery.
files\fastboot -i 0x1949 flash recovery files\twrp-2.6.3.1-recovery.img
echo All done!Now let's get the device out of Fastboot.
files\fastboot -i 0x1949 reboot
cls
echo Everything is complete!Thanks for using my tool!
echo Now you can reboot into recovery(optional) by using option 4 of this tool.
echo Regards,
echo Anonymous.123
pause
goto CHOICE
:RESTORE
echo Continue ONLY if you have performed step 2 and have a folder in your C Drive named BackupFiles!
pause
echo.
echo Ok Then...
pause
cls
echo Unplug your Kindle
@pause > nul
echo Then turn it off.
@pause > nul
echo When the "wait for device" sign comes on,plug it in.
@pause > nul
echo Ready?
files\adb kill-server
files\adb start-server
files\adb wait-for-device
echo Let's get your device into Fastboot...
files\fastboot -i 0x1949 reboot-bootloader
echo Restoring Bootloader...
files\fastboot -i 0x1949 flash bootloader C:\BackupFiles\stock-boot.img
echo Restoring Recovery...
files\fastboot -i 0x1949 flash recovery C:\BackupFiles\stock-recovery.img
echo Restoring System(this will take some time)...
files\fastboot -i 0x1949 flash system C:\BackupFiles\stock-system.img
echo All done! Now let's get it out of Fastboot.
files\fastboot -i 0x1949 reboot
echo Done!
goto CHOICE
:REBOOT
cls
echo Connect your device with Android Debugging enabled and unlock it. Then,hit enter.
@pause > nul
echo Ready?
pause
files\adb kill-server
files\adb start-server
files\adb wait-for-device
files\adb reboot recovery
goto CHOICE