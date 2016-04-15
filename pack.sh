#!/bin/bash

backuppwd=`pwd`

pack_start=`date +"%Y%m%d %T"`
#### set up the packing directory ####
pack_dir=$cm_release_dir'/'$cm_build_project
test -e $pack_dir || mkdir $pack_dir
if [ "$cm_build_type" == "weekly" ]; then
    pack_dir=$pack_dir'/'$cm_build_branch
    test -e $pack_dir || mkdir $pack_dir

    if [ "$cm_build_feature" == "" ]; then
        cm_build_feature="eng"
    fi
    if [ "$cm_build_feature" == "_debug" ]; then
        cm_build_feature="debug"
    fi
    if [ "$cm_build_feature" == "_user" ]; then
        cm_build_feature="user"
    fi
    pack_dir=$pack_dir'/'$cm_build_feature
else
    #### we keep 8 days' build only ####
    cd $pack_dir
    rm -rf `ls -td */ | awk 'NR>8 {print}'`
    pack_dir=$pack_dir'/'$cm_build_date
fi
test -e $pack_dir && rm -rf $pack_dir
mkdir $pack_dir

cd $cm_build_bin_dir

#### replace some image file with Eclair version ####
#mv appsboothd.mbn appsboothd_Froyo.mbn
#mv appsboot.mbn appsboot_Froyo.mbn
#mv recovery.img recovery_Froyo.img
#cp $cm_code_root_dir/ccienv/bin/appsboothd_Eclair_1Die.mbn appsboothd.mbn
#cp $cm_code_root_dir/ccienv/bin/appsboot_Eclair_1Die.mbn appsboot.mbn
#cp $cm_code_root_dir/ccienv/bin/recovery_Eclair_1Die.img recovery.img

echo "---pack image files---"
#### pack image files ####
#ImagesZip=$pack_dir'/'$cm_build_project'_'$cm_build_feature'.Android.'$cm_build_label'-bin.tgz'
#tar czvf $ImagesZip boot.img system.img userdata.img recovery.img flex*.img emmc_appsboot.mbn *.ext4
#tar czvf $ImagesZip boot.img recovery.img emmc_appsboot.mbn *.ext4
ImagesZip=$pack_dir'/'$cm_build_project'.Android.'$cm_build_label'_'$cm_build_feature'-bin.7z'
#JB no *.ext4 anymore
ls -l | grep "ext4"
if [ "$?" == "0" ]; then
    7zr a -y -mx=9 $ImagesZip boot.img recovery.img *.mbn *.ext4 *.bin
else
    7zr a -y -mx=9 $ImagesZip *.img *.mbn *.bin
fi
#END#
#7zr a -y -mx=9 $ImagesZip boot.img recovery.img emmc_appsboot.mbn *.ext4

#### generate hex files ####
image_dir=$pack_dir'/'images
mkdir $image_dir
cp appsboot* $image_dir
#JB no *.ext4 anymore
ls -l | grep "ext4"
if [ "$?" == "0" ]; then
    cp *.ext4 $image_dir
    cp boot.img $image_dir
    cp recovery.img $image_dir
else
    cp *.img $image_dir
fi
#END#
cp *.mbn $image_dir
cp *.MBN $image_dir
cp *.bin $image_dir
if [ -f SplashScreen_dell.raw ]; then
    cp SplashScreen* $image_dir
fi
cp $cm_code_root_dir/ccienv/image/*.mbn $image_dir
#cp $cm_code_root_dir/ccienv/bin/bin2hex $image_dir
#cp $cm_code_root_dir/ccienv/bin/genhex* $image_dir
cp $cm_code_root_dir/out/host/linux-x86/bin/adb $image_dir
cp $cm_code_root_dir/out/host/linux-x86/bin/fastboot $image_dir

### copy images to /media/BU2_SMD/Internal Release/UT Image/DA80_ICS/WBXXX
#utImagePath="/media/TB/"$cm_build_label
#utImagePath="/media/BU2_SMD/Internal Release/UT Image/SA77/WB"$cm_build_label
utImagePath="/media/DB_SA77_WB/WB"$cm_build_label
test -e "$utImagePath" || mkdir -p "$utImagePath"
cp "$ImagesZip" "$utImagePath"

#### Copy OTA files to $image_dir ####
cp $cm_code_root_dir'/out/dist/sa77-target_files-Android.'$cm_build_label'.zip' $image_dir
if [ -f $cm_code_root_dir'/out/dist/sa77-target_files-signed.zip' ]; then
    cp $cm_code_root_dir'/out/dist/sa77-target_files-signed.zip' $image_dir
fi
cp $cm_code_root_dir/out/dist/*.pkg $image_dir
cd $image_dir

#### Copy signed files to $image_dir ####
if [ -d $cm_code_root_dir/out/dist/Signed_Image ]; then
    cp $cm_code_root_dir/out/dist/Signed_Image/ $image_dir -R
fi

#if [ 'A' == 'B' ]; then # Don not generate HEX files in DA80
#. ./genhex_appsbl.sh $cm_build_project'_'$cm_build_feature'.Androidappsbl.'$cm_build_label'.hex' 
#. ./genhex_main.sh $cm_build_project'_'$cm_build_feature'.Android.'$cm_build_label'.hex'

#flex_dir=$cm_code_root_dir'/vendor/cci-flex'
#if [ -d $flex_dir ]; then
#    folder=`ls -l $flex_dir | grep ^d | awk '{print $NF}'`
#    for var in $folder
#    do
#        . ./genhex_flex.sh 'flex-'$var'.img' $cm_build_project'_'$cm_build_feature'_flex.'$cm_build_label'.'$var'.hex'
#    done
#    chmod 644 $cm_build_project'_'$cm_build_feature'_flex*'
#    chmod 644 flex*.img
#fi
#fi # Don not generate HEX files in DA80

echo "---pack source code---"
#### pack source code ####
cd $cm_code_root_dir'/..'
#Use tgz format
#CodeBaseZip=$pack_dir'/'$cm_build_project'.Android.'$cm_build_label'-codebase.tgz'
#tar czvf $CodeBaseZip --exclude=android/.repo/* --exclude=*.git --exclude=android/out android/
#Use lbzip2 tool
#CodeBaseZip=$pack_dir'/'$cm_build_project'.Android.'$cm_build_label'_'$cm_build_feature'-codebase.bz2'
CodeBaseZip=$pack_dir'/'$cm_build_project'.Android.'$cm_build_label'-codebase.bz2'
tar --use=lbzip2 -cvf $CodeBaseZip --exclude=android/.repo/* --exclude=*.git --exclude=android/out --exclude=android/vendor/cci/security/password.txt android/
### copy codebase to \\gsm_sw01\BU2-SMD\Internal Release\SW Source Code Release\DA80_ICS
#test -e "/media/BU2_SMD/Internal Release/SW Source Code Release/SA77/WB"$cm_build_label || mkdir -p "/media/BU2_SMD/Internal Release/SW Source Code Release/SA77/WB"$cm_build_label
test -e "/media/DB_SA77_CB/WB"$cm_build_label || mkdir -p "/media/DB_SA77_CB/WB"$cm_build_label
#echo "Copy codebase to SW Source Code Release"
#cp $CodeBaseZip "/media/BU2_SMD/Internal Release/SW Source Code Release/SA77/WB"$cm_build_label
cp $CodeBaseZip "/media/DB_SA77_CB/WB"$cm_build_label
#echo "END"
#cp "$CodeBaseZip" "$utImagePath"

#### pack debug information ####
#DebugInfoZip=$pack_dir'/'$cm_build_project'_'$cm_build_feature'.Android.'$cm_build_label'-debuginfo.tgz'
#tar czvf $DebugInfoZip --add-file=android/out/target/product/da80/obj/KERNEL_OBJ/System.map --add-file=android/out/target/product/da80/obj/KERNEL_OBJ/vmlinux --add-file=android/out/target/product/da80/obj/KERNEL_OBJ/.config
DebugInfoZip=$pack_dir'/'$cm_build_project'.Android.'$cm_build_label'_'$cm_build_feature'-debuginfo.7z'
7zr a -y -mx=9  $DebugInfoZip android/out/target/product/sa77/obj/KERNEL_OBJ/System.map android/out/target/product/sa77/obj/KERNEL_OBJ/vmlinux android/out/target/product/sa77/obj/KERNEL_OBJ/.config android/out/target/product/sa77/symbols

### copy debuginfo to /media/BU2_SMD/Internal Release/UT Image/DA80_ICS/WBXXX
cp "$DebugInfoZip" "$utImagePath"

#generate Hex File
#genhex DSR
#test -e $cm_code_root_dir/out/target/product/da80/genhex/DA80_android.img && mv $cm_code_root_dir/out/target/product/da80/genhex/DA80_android.img $cm_code_root_dir/out/target/product/da80/genhex/DA80ICS_$cm_build_label.img && tar -jcv -f $cm_code_root_dir/out/target/product/da80/genhex/DA80ICS_$cm_build_label.tar.bz2 $cm_code_root_dir/out/target/product/da80/genhex/DA80ICS_$cm_build_label.img && cp $cm_code_root_dir/out/target/product/da80/genhex/DA80ICS_$cm_build_label.tar.bz2 $image_dir
#

pack_end=`date +"%Y%m%d %T"`

echo ""
echo "===== Pack finish ( Android "$cm_build_branch" "$cm_build_project" ) ====="
echo ""
echo -e "Start  Time: "$pack_start
echo -e "Finish Time: "$pack_end
echo ""

cd $backuppwd
