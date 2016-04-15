#!/bin/bash

mode=$1   #userdebug eng user
path=$2   #/Data
name=$3   #NEW_S1.zip(no white space and the zip doesn't include any path)
repackname=$4   #NEW
folder=$5   #1021

backuppwd=`pwd`

#CCI_IMAGE.zip
cd "$backuppwd"/weekly/LINUX/android/"$mode"_SOMCv3

unzip CCI_IMAGE.zip
cd img
rm -rf Taoshan_S1BootConfig_MiscTA_121009_1033.ta
rm -rf boot_delivery.xml
rm -rf tz_*
rm -rf s1sbl2_*
rm -rf sbl1_*
rm -rf sbl2_*
rm -rf sbl3_*
rm -rf emmc_*

scp cme@10.113.41.212:"$path"/"$name" .
unzip "$name"
rm -rf "$name"
cd ..
rm -rf CCI_IMAGE.zip
zip -ry CCI_IMAGE.zip img/
rm -rf img

cd $backuppwd
#CCI_IMAGE.zip END

#S1_BOOT.zip
cd "$backuppwd"/weekly/LINUX/android/"$mode"_SOMCv3

unzip S1_BOOT.zip
cd img/boot/
rm -rf *
scp cme@10.113.41.212:"$path"/"$name" .
unzip "$name"
rm -rf "$name"
cd ../..
rm -rf S1_BOOT.zip
zip -ry S1_BOOT.zip img/
rm -rf img
 
cd $backuppwd
#S1_BOOT.zip END

#repack all zips
cd "$backuppwd"/weekly/LINUX/android/"$mode"_SOMCv3

zip -ry ../"$mode"_SOMCv3"$repackname".zip .
cd ..
cp "$mode"_SOMCv3"$repackname".zip  "/media/BU2_SMD/Internal Release/UT Image/SA77/WB"$folder"/"
#repack all zips END
