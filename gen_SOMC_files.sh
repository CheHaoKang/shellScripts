#!/bin/bash

backuppwd=`pwd`
export sin_type=$1

#utImagePath="/media/BU2_SMD/Internal Release/UT Image/foo/_WB"$cm_build_label
#test -e "$utImagePath" || mkdir -p "$utImagePath"

#CCI_IMAGE.zip
rm -rf weekly/LINUX/android/out/target/product/foo/sin/
cp -r sin/ weekly/LINUX/android/out/target/product/foo/
cd weekly/LINUX/android/out/target/product/foo/sin/
./sin_all.sh $sin_type

###fota
cd $backuppwd/weekly/LINUX/android
cp vendor/cci/tools/sin/cert_data.dat .

#export BOARD_KERNEL_BOOTIMG=YES
#if [ "$sin_type" == "v3" ]; then
#    make fotakernelv3
#else
#    make fotakernelv2
#fi

if [ "$sin_type" == "v3" ]; then
    cp -r out/target/product/foo/sin/image_signed/* out/target/product/foo/
    mv out/target/product/foo/boot.sin out/target/product/foo/kernel.sin
    mv out/target/product/foo/ramdumper.sin out/target/product/foo/ramdump.sin
    mv out/target/product/foo/NON-HLOS.sin out/target/product/foo/modem.sin

    export PRODUCT_PARTITION_CONFIG=vendor/semc/system/fota-update-agent/fsconfig.xml
    export FOTA_TARGET_PRODUCT_NAME=taoshan
    scp cme@10.113.41.212:/Data/fsconfig/fsconfig.py out/host/linux-x86/bin/
    ./out/host/linux-x86/bin/fotazip.sh
    test -e /Data/fota/WB$cm_build_label || mkdir -p /Data/fota/WB$cm_build_label
    mv out/fota/*.zip /Data/fota/WB$cm_build_label
fi
###fota

cd $backuppwd/weekly/LINUX/android/out/target/product/foo/sin/

mkdir -p img

cp $backuppwd/weekly/LINUX/android/out/target/product/foo/fotakernel.sin img/fotakernel_S1-SW-TEST-B316-0001-MMC.sin
mv image_signed/cache.sin img/cache_S1-SW-TEST-B316-0001-MMC.sin
mv image_signed/ftma.sin img/ftma_S1-ETS-TEST-B316-0001-MMC.sin
#mv image_signed/kernel.sin img
mv image_signed/boot.sin img/kernel_S1-SW-TEST-B316-0001-MMC.sin
#mv image_signed/modem.sin img
mv image_signed/NON-HLOS.sin img/modem_S1-MODEMSW-TEST-B316-0001-MMC.sin
mv image_signed/rpm.sin img/rpm_S1-RPMFW-TEST-B316-0001-MMC.sin
mv image_signed/system.sin img/system_S1-SW-TEST-B316-0001-MMC.sin
mv image_signed/userdata.sin img/userdata_S1-SW-TEST-B316-0001-MMC.sin
mv image_signed/ramdumper.sin img/ramdumper_S1-SW-TEST-B316-0001-MMC.sin
mv image_signed/ltalabel.sin img/ltalabel_S1-CUST-TEST-B316-0001-MMC.sin  
scp cme@10.113.41.212:/Data/s1_boot/S1_BOOT"$sin_type"_"$s1_version".zip .
unzip S1_BOOT"$sin_type"_"$s1_version".zip -d img/
#mv *emmc_appsboot* *sbl* *tz* img/
rm -rf $backuppwd/weekly/LINUX/android/CCI_IMAGE.zip
zip -ry $backuppwd/weekly/LINUX/android/CCI_IMAGE.zip img

export type=`cat $backuppwd/weekly/LINUX/android/out/target/product/foo/system/build.prop | grep "ro.build.type" | sed -r 's/.*=(.*)/\1/g'`
echo $cm_build_label | egrep 9[0-9]\{2\}
if [ "$?" == "0" ]; then
    export factory="yes"
fi
if [ "$type" == "eng" ] && [ "$factory" == "yes" ]; then
    rm -rf $backuppwd/weekly/LINUX/android/out/target/product/foo/sin/
    cp -r $backuppwd/sin/ $backuppwd/weekly/LINUX/android/out/target/product/foo/
    cd $backuppwd/weekly/LINUX/android/out/target/product/foo/sin/

    #rm -rf $backuppwd/weekly/LINUX/android/out/target/product/foo/temp
    #mkdir -p $backuppwd/weekly/LINUX/android/out/target/product/foo/temp
    #mv $backuppwd/weekly/LINUX/android/out/target/product/foo/system.img $backuppwd/weekly/LINUX/android/out/target/product/foo/temp
    #mv $backuppwd/weekly/LINUX/android/out/target/product/foo/userdata.img $backuppwd/weekly/LINUX/android/out/target/product/foo/temp
    #mv $backuppwd/weekly/LINUX/android/out/target/product/foo/cache.img $backuppwd/weekly/LINUX/android/out/target/product/foo/temp

    #make_ext4fs -s  -l 671088640 -a system $backuppwd/weekly/LINUX/android/out/target/product/foo/system.img $backuppwd/weekly/LINUX/android/out/target/product/foo/system
    #make_ext4fs -s  -l 268435456 -a data $backuppwd/weekly/LINUX/android/out/target/product/foo/userdata.img $backuppwd/weekly/LINUX/android/out/target/product/foo/data
    #make_ext4fs -s  -l 67108864 -a cache $backuppwd/weekly/LINUX/android/out/target/product/foo/cache.img $backuppwd/weekly/LINUX/android/out/target/product/foo/cache

    ./sin_all.sh $sin_type

    mkdir -p img

    mv image_signed/cache.sin img
    mv image_signed/ftma.sin img
    mv image_signed/boot.sin img/kernel.sin
    #mv image_signed/kernel.sin img
    #mv image_signed/modem.sin img
    mv image_signed/NON-HLOS.sin img/modem.sin
    mv image_signed/rpm.sin img
    mv image_signed/system.sin img
    mv image_signed/userdata.sin img
    mv image_signed/persist.sin img
    mv image_signed/ftmd.sin img
    mv image_signed/ramdumper.sin img
    mv image_signed/ltalabel.sin img
    scp cme@10.113.41.212:/Data/s1_boot/S1_BOOT"$sin_type"_"$s1_version".zip .
    unzip S1_BOOT"$sin_type"_"$s1_version".zip -d img/

    rm -rf $backuppwd/weekly/LINUX/android/CCI_factory_only_SOMC_not_use_image$sin_type.zip
    zip -ry $backuppwd/weekly/LINUX/android/CCI_factory_only_SOMC_not_use_image$sin_type.zip img

    test -e "$utImagePath" || mkdir -p "$utImagePath"
    cp $backuppwd/weekly/LINUX/android/CCI_factory_only_SOMC_not_use_image$sin_type.zip img "$utImagePath"
fi

#tar --use=lbzip2 -cvf ../CCI_IMAGE.zip img/

#zip -r $backuppwd/weekly/LINUX/android/CCI_IMAGE.zip img
rm -rf img/
cd $backuppwd
#CCI_IMAGE.zip END



#TOOLS_IMAGETOOLS.zip
cd weekly/LINUX/android/out/host/linux-x86/bin
mkdir -p util/bin/
cp make_ext4fs util/bin/
cp minigzip util/bin/
cp mkbootfs util/bin/
cp mkbootimg util/bin/
cp mkuserimg.sh util/bin/
rm -rf $backuppwd/weekly/LINUX/android/TOOLS_IMAGETOOLS.zip
zip -ry $backuppwd/weekly/LINUX/android/TOOLS_IMAGETOOLS.zip util
rm -rf util/
cd $backuppwd
#TOOLS_IMAGETOOLS.zip END


#FSCONFIG.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC

mkdir -p util/data/
mkdir -p img
#cp $backuppwd/fsconfig.xml util/data/
scp cme@10.113.41.212:/Data/fsconfig/fsconfig$sin_type.xml util/data/fsconfig.xml
#scp cme@10.113.41.212:/Data/partition/partition.img util/data/
scp cme@10.113.41.212:/Data/partition/partition-image_S1-SW-TEST-B316-0001-MBR.sin img/
#cp $backuppwd/partition.img util/data/

cp ../device/cci/foo/BoardConfig.mk .
BOARD_USERDATAIMAGE_PARTITION_SIZE=""
BOARD_SYSTEMIMAGE_PARTITION_SIZE=""
BOARD_KERNELIMAGE_PARTITION_SIZE=""
BOARD_VENDORIMAGE_PARTITION_SIZE=""
BOARD_KERNEL_BASE=""
BOARD_KERNEL_CMDLINE=""
BOARD_KERNEL_PAGESIZE=""
BOARD_KERNEL_ADDR=""
BOARD_KERNEL_BOOTIMG=""
BOARD_KERNELIMG_SIZE=""
BOARD_RAMDISK_ADDR=""
BOARD_RAMDISK_OFFSET=""
BOARD_RPM_ADDR=""
TARGET_USERIMAGES_SPARSE_EXT_DISABLED=""
PRODUCT_UNAVAILABLE_PARTITIONS=""

lines=`wc -l BoardConfig.mk | sed 's/ .*//g'`

for line in $(seq 1 $lines) 
do
    line=`head -$line BoardConfig.mk | tail -1`

    isAnnotation=`echo $line | sed -r 's/^(#*).*$/\1/'`
    isNeeded=`echo $line | sed -r 's/(.*?) :=.*/\1/'`
    isNeeded2=`echo $line | sed -r 's/.*:= (.*)/\1/'`

    if [ "$isAnnotation" == "#" ]; then
        echo "nothing" > /dev/null
    elif [ "$isNeeded" == "BOARD_USERDATAIMAGE_PARTITION_SIZE" ] && [ "$BOARD_USERDATAIMAGE_PARTITION_SIZE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	export BOARD_USERDATAIMAGE_PARTITION_SIZE="$isNeeded2"
    elif [ "$isNeeded" == "BOARD_SYSTEMIMAGE_PARTITION_SIZE" ] && [ "$BOARD_SYSTEMIMAGE_PARTITION_SIZE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_SYSTEMIMAGE_PARTITION_SIZE=$isNeeded2
    elif [ "$isNeeded" == "BOARD_KERNELIMAGE_PARTITION_SIZE" ] && [ "$BOARD_KERNELIMAGE_PARTITION_SIZE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_KERNELIMAGE_PARTITION_SIZE=$isNeeded2
    elif [ "$isNeeded" == "BOARD_VENDORIMAGE_PARTITION_SIZE" ] && [ "$BOARD_VENDORIMAGE_PARTITION_SIZE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_VENDORIMAGE_PARTITION_SIZE=$isNeeded2
    elif [ "$isNeeded" == "BOARD_KERNEL_BASE" ] && [ "$BOARD_KERNEL_BASE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_KERNEL_BASE=$isNeeded2
    elif [ "$isNeeded" == "BOARD_KERNEL_CMDLINE" ] && [ "$BOARD_KERNEL_CMDLINE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_KERNEL_CMDLINE=$isNeeded2
    elif [ "$isNeeded" == "BOARD_KERNEL_PAGESIZE" ] && [ "$BOARD_KERNEL_PAGESIZE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_KERNEL_PAGESIZE=$isNeeded2
    elif [ "$isNeeded" == "BOARD_KERNEL_ADDR" ] && [ "$BOARD_KERNEL_ADDR" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_KERNEL_ADDR=$isNeeded2
    elif [ "$isNeeded" == "BOARD_KERNEL_BOOTIMG" ] && [ "$BOARD_KERNEL_BOOTIMG" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_KERNEL_BOOTIMG=$isNeeded2
    elif [ "$isNeeded" == "BOARD_KERNELIMG_SIZE" ] && [ "$BOARD_KERNELIMG_SIZE" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_KERNELIMG_SIZE=$isNeeded2
    elif [ "$isNeeded" == "BOARD_RAMDISK_ADDR" ] && [ "$BOARD_RAMDISK_ADDR" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_RAMDISK_ADDR=$isNeeded2
    elif [ "$isNeeded" == "BOARD_RAMDISK_OFFSET" ] && [ "$BOARD_RAMDISK_OFFSET" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_RAMDISK_OFFSET=$isNeeded2
    elif [ "$isNeeded" == "BOARD_RPM_ADDR" ] && [ "$BOARD_RPM_ADDR" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	BOARD_RPM_ADDR=$isNeeded2
    elif [ "$isNeeded" == "TARGET_USERIMAGES_SPARSE_EXT_DISABLED" ] && [ "$TARGET_USERIMAGES_SPARSE_EXT_DISABLED" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	TARGET_USERIMAGES_SPARSE_EXT_DISABLED=$isNeeded2
    elif [ "$isNeeded" == "PRODUCT_UNAVAILABLE_PARTITIONS" ] && [ "$PRODUCT_UNAVAILABLE_PARTITIONS" == "" ]; then
        #echo -e "$isNeeded = $isNeeded2" >> partition_data.cfg
	PRODUCT_UNAVAILABLE_PARTITIONS=$isNeeded2
    else
        echo "nothing" > /dev/null
    fi
done

    echo -e "[partition_data]" >> partition_data.cfg
    echo -e "BOARD_USERDATAIMAGE_PARTITION_SIZE = $BOARD_USERDATAIMAGE_PARTITION_SIZE" >> partition_data.cfg
    echo -e "BOARD_SYSTEMIMAGE_PARTITION_SIZE = $BOARD_SYSTEMIMAGE_PARTITION_SIZE" >> partition_data.cfg
    echo -e "BOARD_KERNELIMAGE_PARTITION_SIZE = $BOARD_KERNELIMAGE_PARTITION_SIZE" >> partition_data.cfg
    echo -e "BOARD_VENDORIMAGE_PARTITION_SIZE = $BOARD_VENDORIMAGE_PARTITION_SIZE" >> partition_data.cfg
    echo -e "BOARD_KERNEL_BASE = $BOARD_KERNEL_BASE" >> partition_data.cfg
    echo -e "BOARD_KERNEL_CMDLINE = $BOARD_KERNEL_CMDLINE" >> partition_data.cfg
    echo -e "BOARD_KERNEL_PAGESIZE = $BOARD_KERNEL_PAGESIZE" >> partition_data.cfg
    echo -e "BOARD_KERNEL_ADDR = $BOARD_KERNEL_ADDR" >> partition_data.cfg
    echo -e "BOARD_KERNEL_BOOTIMG = $BOARD_KERNEL_BOOTIMG" >> partition_data.cfg
    echo -e "BOARD_KERNELIMG_SIZE = $BOARD_KERNELIMG_SIZE" >> partition_data.cfg
    echo -e "BOARD_RAMDISK_ADDR = $BOARD_RAMDISK_ADDR" >> partition_data.cfg
    echo -e "BOARD_RAMDISK_OFFSET = $BOARD_RAMDISK_OFFSET" >> partition_data.cfg
    echo -e "BOARD_MKBOOTIMG_ARGS = --ramdisk_offset $BOARD_RAMDISK_OFFSET" >> partition_data.cfg
    echo -e "BOARD_RPM_ADDR = $BOARD_RPM_ADDR" >> partition_data.cfg
    echo -e "TARGET_USERIMAGES_SPARSE_EXT_DISABLED = $TARGET_USERIMAGES_SPARSE_EXT_DISABLED" >> partition_data.cfg
    echo -e "PRODUCT_UNAVAILABLE_PARTITIONS = $PRODUCT_UNAVAILABLE_PARTITIONS" >> partition_data.cfg

mv partition_data.cfg util/data/

rm -rf $backuppwd/weekly/LINUX/android/FSCONFIG.zip
zip -ry $backuppwd/weekly/LINUX/android/FSCONFIG.zip util img

cd $backuppwd
#FSCONFIG.zip END


#KERNEL.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC
cp ../out/target/product/foo/system/build.prop .

mkdir -p util/data/
rm -rf util/data/semc_kernel_time_stamp.prop
cat build.prop | while read line
do                                                                          
    #first=`echo $line | sed 's/(.*)=.*/\1/'`
    isAnnotation=`echo $line | sed -r 's/^(#*).*$/\1/'`
    isNeeded=`echo $line | sed -r 's/(.*)=.*/\1/'`

    if [ "$isAnnotation" == "#" ]; then
        echo "nothing" >/dev/null
    elif [ "$isNeeded" == "ro.build.date" ]; then
        echo -e "$line" >> util/data/semc_kernel_time_stamp.prop
    elif [ "$isNeeded" == "ro.build.date.utc" ]; then
        echo -e "$line" >> util/data/semc_kernel_time_stamp.prop
    elif [ "$isNeeded" == "ro.build.user" ]; then
        echo -e "$line" >> util/data/semc_kernel_time_stamp.prop
    elif [ "$isNeeded" == "ro.build.host" ]; then
        echo -e "$line" >> util/data/semc_kernel_time_stamp.prop
    fi
done

rm -rf img/
mkdir -p img/
cp -r ../out/target/product/foo/obj/KERNEL_OBJ/arch/arm/boot/zImage img/

mkdir -p imgdata/
cp -r ../out/target/product/foo/root/ imgdata/

rm -rf $backuppwd/weekly/LINUX/android/KERNEL.zip
zip -ry $backuppwd/weekly/LINUX/android/KERNEL.zip util img imgdata
#zip -j $backuppwd/weekly/LINUX/android/KERNEL.zip util/
cd $backuppwd
#KERNEL.zip END

#SYSTEM.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC
mkdir -p imgdata/
#mkdir -p alternatives/

cp -r ../out/target/product/foo/system imgdata/
rm -rf imgdata/system/etc/firmware/dxhdcp2.b00
rm -rf imgdata/system/etc/firmware/dxhdcp2.b01
rm -rf imgdata/system/etc/firmware/dxhdcp2.b02
rm -rf imgdata/system/etc/firmware/dxhdcp2.b03
rm -rf imgdata/system/etc/firmware/dxhdcp2.mdt
rm -rf imgdata/system/etc/firmware/tzlibasb.b00
rm -rf imgdata/system/etc/firmware/tzlibasb.b01
rm -rf imgdata/system/etc/firmware/tzlibasb.b02
rm -rf imgdata/system/etc/firmware/tzlibasb.b03
rm -rf imgdata/system/etc/firmware/tzlibasb.mdt
rm -rf imgdata/system/etc/firmware/tzsuntory.b00
rm -rf imgdata/system/etc/firmware/tzsuntory.b01
rm -rf imgdata/system/etc/firmware/tzsuntory.b02
rm -rf imgdata/system/etc/firmware/tzsuntory.b03
rm -rf imgdata/system/etc/firmware/tzsuntory.mdt
rm -rf imgdata/system/etc/firmware/vidc.b00
rm -rf imgdata/system/etc/firmware/vidc.b01
rm -rf imgdata/system/etc/firmware/vidc.b02
rm -rf imgdata/system/etc/firmware/vidc.b03
rm -rf imgdata/system/etc/firmware/vidc.mdt
rm -rf imgdata/system/etc/product/applications/SnpVUStore.apk
rm -rf imgdata/system/app/sneiaccountmanager.apk
rm -rf imgdata/system/app/SemcAlbum.apk
rm -rf imgdata/system/app/SemcMusic.apk
#rm -rf imgdata/system/vendor/overlay/SemcAlbum-Overlay-300.apk
#rm -rf imgdata/system/vendor/overlay/SemcMusic-Overlay-MUOFF-300.apk
rm -rf imgdata/system/vendor/overlay
rm -rf $backuppwd/weekly/LINUX/android/SYSTEM.zip

#SemcVideo.apk
#cp -r ../vendor/semc/prebuilt/alternatives/app-semcvideo/ alternatives/
#SemcVideo.apk END

#cp -r ../vendor/semc/prebuilt/alternatives/app-semcmetadatacleanup/ alternatives/
#cp -r ../vendor/semc/prebuilt/alternatives/app-semcmusicvisualizer/ alternatives/
#cp -r ../vendor/semc/prebuilt/alternatives/app-smallappmanagerservice/ alternatives/
#cp -r ../vendor/semc/prebuilt/alternatives/app-somcconnectivitycenter/ alternatives/
#cp -r ../vendor/semc/prebuilt/alternatives/app-somcmusicslideshow/ alternatives/

cp -r ../vendor/semc/prebuilt/alternatives/ .
rm -rf alternatives/app-snpvustore/
rm -rf alternatives/app-semcmusic/

zip -ry $backuppwd/weekly/LINUX/android/SYSTEM.zip imgdata alternatives
cd $backuppwd
#SYSTEM.zip END

#common_SOMCv3.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC

mkdir -p imgdata/system/etc/product/applications/
mkdir -p imgdata/system/app/
mkdir -p imgdata/system/vendor/overlay/
mkdir -p alternatives/
mkdir -p util/data/notice/system/app/

cp ../out/target/product/foo/system/etc/product/applications/SnpVUStore.apk imgdata/system/etc/product/applications/
cp ../out/target/product/foo/system/app/sneiaccountmanager.apk imgdata/system/app/

#SnpVUStore.apk
cp -r ../vendor/semc/prebuilt/alternatives/app-snpvustore/ alternatives/
#SnpVUStore.apk END

#SemcAlbum.apk
cp ../out/target/product/foo/system/app/SemcAlbum.apk imgdata/system/app/
cp -r ../out/target/product/foo/obj/NOTICE_FILES/src/system/app/SemcAlbum.apk.txt util/data/notice/system/app/
#SemcAlbum.apk END

#SemcMusic.apk
cp ../out/target/product/foo/system/app/SemcMusic.apk imgdata/system/app/
cp -r ../out/target/product/foo/obj/NOTICE_FILES/src/system/app/SemcMusic.apk.txt util/data/notice/system/app/
cp -r ../vendor/semc/prebuilt/alternatives/app-semcmusic/ alternatives/
#SemcMusic.apk END

cp ../out/target/product/foo/system/vendor/overlay/SemcAlbum-Overlay-300.apk imgdata/system/vendor/overlay/
cp ../out/target/product/foo/system/vendor/overlay/SemcMusic-Overlay-MUOFF-300.apk imgdata/system/vendor/overlay/

zip -ry $backuppwd/weekly/LINUX/android/common_SOMCv3.zip imgdata alternatives util

cd $backuppwd
#common_SOMCv3.zip END

#NOTICE_FILES.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC
mkdir -p util/data/notice/
cp -r ../out/target/product/foo/obj/NOTICE_FILES/src/* util/data/notice/

rm -rf util/data/notice/system/app/SemcAlbum.apk.txt
rm -rf util/data/notice/system/app/SemcMusic.apk.txt

rm -rf $backuppwd/weekly/LINUX/android/NOTICE_FILES.zip
zip -ry $backuppwd/weekly/LINUX/android/NOTICE_FILES.zip util
cd $backuppwd
#NOTICE_FILES.zip END

#matchtable.xml
cd weekly/LINUX/android/
#cp vendor/semc/build/jdm-specs/matchtable.xml .
cp vendor/semc/build/jdm-specs/matchtable.xml "$utImagePath"

#if [ "$somc_build_trunk" != "" ]; then
#    cd ~
#    rm -rf jdm-specs
#    git clone git://$cm_git_host_loc/platform/vendor/semc/build/jdm-specs.git
#    cd jdm-specs
#    git checkout $somc_build_trunk
#    cp matchtable.xml "$utImagePath"
#fi

cd $backuppwd
#matchtable.xml END


#S1_BOOT.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC
scp cme@10.113.41.212:/Data/s1_boot/S1_BOOT"$sin_type"_"$s1_version".zip .
mkdir -p img/boot
unzip S1_BOOT"$sin_type"_"$s1_version".zip -d img/boot/
#cp -r *emmc_appsboot* *sbl* *tz* img/boot/

#rm -rf S1_BOOT.zip
rm -rf $backuppwd/weekly/LINUX/android/S1_BOOT.zip
zip -ry $backuppwd/weekly/LINUX/android/S1_BOOT.zip img/boot/

cd $backuppwd
#S1_BOOT.zip END

#FOTA.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC

mkdir -p img/
mkdir -p util/bin/
#mkdir -p util/data/swbomparts/fw-fota-odin-user-release
mkdir -p imgdata/fotaroot/sbin/fotatools
mkdir -p imgdata/fotaroot/fota
#mkdir -p util/data/swbomparts/fota_debian_package/
mkdir -p util/data/

cp ../out/target/product/foo/fstab.fota imgdata/fotaroot/
cp ../out/target/product/foo/init.fota.rc util/data/
cp ../out/target/product/foo/redbend.zip util/data/
cp ../out/target/product/foo/script.txt util/data/
cp ../out/target/product/foo/source_filter.xml util/data/
cp ../out/target/product/foo/target_filter.xml util/data/
cp ../out/target/product/foo/fota_config.xml util/data/

cp ../out/target/product/foo/fotaramdisk/root/sbin/fota-ua img/
cp ../out/target/product/foo/fotaramdisk/root/sbin/fotatools/vold.fstab imgdata/fotaroot/sbin/fotatools/
cp ../out/target/product/foo/fotaramdisk/root/sbin/fota-tad imgdata/fotaroot/sbin/
cp ../out/target/product/foo/fotaramdisk/root/sbin/refreshfs imgdata/fotaroot/sbin/
cp ../out/target/product/foo/fotaramdisk/root/sbin/fotatools/toolbox imgdata/fotaroot/sbin/fotatools/
cp ../out/target/product/foo/fotaramdisk/root/fota/tzlibasb.* imgdata/fotaroot/fota/

cp ../vendor/semc/system/fota-update-agent/fotatypeconfig.py util/bin/
cp ../vendor/semc/system/fota-update-agent/fota_type_id.xml util/data/
#cp ../vendor/semc/system/fota-update-agent/swbomparts.xml util/data/swbomparts/fw-fota-odin-user-release/

cp ../out/target/product/foo/system/vendor/fota/*.png imgdata/fotaroot/fota/

cp ../out/host/linux-x86/bin/fs_get_stats util/bin/
cp ../out/host/linux-x86/bin/genrblist util/bin/
cp ../out/host/linux-x86/bin/ua_sony_inc_gen.py util/bin/


rm -rf $backuppwd/weekly/LINUX/android/FOTA.zip
zip -ry $backuppwd/weekly/LINUX/android/FOTA.zip img/ util/ imgdata/

cd $backuppwd
#FOTA.zip END


#MODEM.zip
echo "+++MODEM.zip+++"
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC

mkdir -p imgdata/separate

#test -e "$utImagePath"_old/amss_image_foo_"$cm_build_label".7z && cp "$utImagePath"_old/amss_image_foo_"$cm_build_label".7z .
#test -e "$utImagePath"/amss_image_foo_"$cm_build_label".7z && cp "$utImagePath"/amss_image_foo_"$cm_build_label".7z .
#test -e "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z && cp "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z .
test -e "/media/DB_foo_WB/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z && cp "/media/DB_foo_WB/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z .
#test -e "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z && cp "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z .
test -e "/media/DB_foo_WB/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z && cp "/media/DB_foo_WB/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z .
#cp "$utImagePath"/amss_image_foo_"$cm_build_label".7z .
7zr e amss_image_foo_"$cm_build_label".7z image_all/wcnss.mbn
7zr e amss_image_foo_"$cm_build_label".7z image_all/dsp1.mbn
7zr e amss_image_foo_"$cm_build_label".7z image_all/dsp2.mbn
7zr e amss_image_foo_"$cm_build_label".7z image_all/dsp3.mbn
rm -rf amss_image_foo_"$cm_build_label".7z

cp ../vendor/cci/tools/vidc.mbn .

rm -rf /Data/vidc
scp -r cme@10.113.41.212:/Data/vidc_ori /Data/vidc
rm -rf /Data/vidc/assemble/input/*
rm -rf /Data/vidc/assemble/output/*
cp -r ../vendor/semc/build/tz-images/* /Data/vidc/assemble/input/
cd /Data/vidc/assemble/
chmod 777 *
. ./build.sh
cd $backuppwd/weekly/LINUX/android/SOMC
cp -r /Data/vidc/assemble/output/* .
#scp cme@10.113.41.212:/Data/vidc/dxhdcp2.mbn .
#scp cme@10.113.41.212:/Data/vidc/sonytzapplibasb.mbn .
#scp cme@10.113.41.212:/Data/vidc/sonytzappsuntory.mbn .

mv * imgdata/separate/

rm -rf $backuppwd/weekly/LINUX/android/MODEM.zip
zip -ry $backuppwd/weekly/LINUX/android/MODEM.zip imgdata/

cd $backuppwd
echo "---MODEM.zip---"
#MODEM.zip END

#TOOLS_IMAGETOOLS_CCI.zip
cd weekly/LINUX/android/
rm -rf SOMC/
mkdir -p SOMC
cd SOMC

mkdir -p imgdata/

scp cme@10.113.41.212:/Data/imagetools/contents.xml imgdata/
scp cme@10.113.41.212:/Data/imagetools/fatadd.py imgdata/
scp cme@10.113.41.212:/Data/imagetools/fatgen.py imgdata/
scp cme@10.113.41.212:/Data/imagetools/meta_lib.py imgdata/
scp cme@10.113.41.212:/Data/imagetools/meta_log.py imgdata/
scp cme@10.113.41.212:/Data/imagetools/pil-splitter.py imgdata/
scp cme@10.113.41.212:/Data/imagetools/update_common_info.py imgdata/

rm -rf $backuppwd/weekly/LINUX/android/TOOLS_IMAGETOOLS_CCI.zip
zip -ry $backuppwd/weekly/LINUX/android/TOOLS_IMAGETOOLS_CCI.zip imgdata/

cd $backuppwd
#TOOLS_IMAGETOOLS_CCI.zip END


#CrimsonElf.zip
#if [ "A" == "B" ]; then
if [ ! -f "$utImagePath/CrimsonElf.zip" ]; then
    cd weekly/LINUX/android/
    rm -rf SOMC/
    mkdir -p SOMC
    cd SOMC

    #test -e "$utImagePath"_old/amss_image_foo_"$cm_build_label".7z && cp "$utImagePath"_old/amss_image_foo_"$cm_build_label".7z .
    #test -e "$utImagePath"/amss_image_foo_"$cm_build_label".7z && cp "$utImagePath"/amss_image_foo_"$cm_build_label".7z .
    #test -e "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z && cp "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z .
    test -e "/media/DB_foo_WB/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z && cp "/media/DB_foo_WB/WB"$cm_build_label/amss_image_foo_"$cm_build_label".7z .
    #test -e "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z && cp "/media/BU2_SMD/Internal Release/UT Image/foo/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z .
    test -e "/media/DB_foo_WB/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z && cp "/media/DB_foo_WB/WB"$cm_build_label"_old"/amss_image_foo_"$cm_build_label".7z .
    #cp "$utImagePath"/amss_image_foo_"$cm_build_label".7z .
    7zr e amss_image_foo_"$cm_build_label".7z image_all/wcnss.mbn
    7zr e amss_image_foo_"$cm_build_label".7z image_all/dsp1.mbn
    7zr e amss_image_foo_"$cm_build_label".7z image_all/dsp2.mbn
    7zr e amss_image_foo_"$cm_build_label".7z image_all/dsp3.mbn
    rm -rf amss_image_foo_"$cm_build_label".7z

    #scp cme@10.113.41.212:/Data/BuildFolder/autobuild/modem_foo/amss/cci_build/image_all/dsp1.mbn .
    #scp cme@10.113.41.212:/Data/BuildFolder/autobuild/modem_foo/amss/cci_build/image_all/dsp2.mbn .
    #scp cme@10.113.41.212:/Data/BuildFolder/autobuild/modem_foo/amss/cci_build/image_all/dsp3.mbn .
    #scp cme@10.113.41.212:/Data/BuildFolder/autobuild/modem_foo/amss/cci_build/image_all/wcnss.mbn .
    #scp cme@10.113.41.212:/Data/vidc/vidc.mbn .
    cp ../vendor/cci/tools/vidc.mbn .
    scp cme@10.113.41.212:/Data/vidc/dxhdcp2.mbn .
    scp cme@10.113.41.212:/Data/vidc/sonytzapplibasb.mbn .
    scp cme@10.113.41.212:/Data/vidc/sonytzappsuntory.mbn .

    rm -rf $backuppwd/weekly/LINUX/android/CrimsonElf.zip
    zip -ry $backuppwd/weekly/LINUX/android/CrimsonElf.zip .
    cp $backuppwd/weekly/LINUX/android/CrimsonElf.zip "$utImagePath"

    cd $backuppwd
fi
#fi
#CrimsonElf.zip END


#COPY ALL to SOMC
cd weekly/LINUX/android/
rm -rf SOMC/
rm -rf $type"_SOMC"$sin_type
mkdir -p $type"_SOMC"$sin_type
cd $type"_SOMC"$sin_type

mv ../CCI_IMAGE.zip .
mv ../TOOLS_IMAGETOOLS.zip .
mv ../FSCONFIG.zip .
mv ../KERNEL.zip .
mv ../SYSTEM.zip .
mv ../NOTICE_FILES.zip .
mv ../S1_BOOT.zip .
mv ../FOTA.zip .
mv ../MODEM.zip .
mv ../TOOLS_IMAGETOOLS_CCI.zip .
#mv ../matchtable.* .

#cd ..
#zip -r "$type"_SOMC.zip "$type"_SOMC
rm -rf ../"$type"_SOMC"$sin_type".zip
zip -y ../"$type"_SOMC"$sin_type".zip ./*
test -e "$utImagePath" || mkdir -p "$utImagePath"
cp ../"$type"_SOMC"$sin_type".zip "$utImagePath"

if [ ! -f "$utImagePath/common_SOMCv3.zip" ]; then
    cp ../common_SOMCv3.zip "$utImagePath"
fi

###copy to FTP
if [ "$sin_type" == "v3" ]; then
    ftp -n<<!
    open 10.113.72.28
    user svd svd@7890
    binary
    cd /
    mkdir "$cm_build_label"
    cd "$cm_build_label"
    lcd "$backuppwd/weekly/LINUX/android"
    prompt
    put "$type"_SOMC"$sin_type".zip "$type"_SOMC"$sin_type".zip
    close
    bye
!
fi
###

cd ..
rm -rf unsigned_imgs
mkdir -p unsigned_imgs
cp out/target/product/foo/cache.img unsigned_imgs
if [ "$type" == "eng" ]; then
    cp out/target/product/foo/ftma_Development.img unsigned_imgs/ftma.img
elif [ "$type" == "userdebug" ]; then
    cp out/target/product/foo/ftma_Debug.img unsigned_imgs/ftma.img
else
    cp out/target/product/foo/ftma_Shipping.img unsigned_imgs/ftma.img
fi
#cp out/target/product/foo/boot.img unsigned_imgs/kernel.img
###fota
cp $backuppwd/weekly/LINUX/android/out/target/product/foo/fotakernel.img unsigned_imgs
#mv $backuppwd/weekly/LINUX/android/out/target/product/foo/fotakernel.img $backuppwd/weekly/LINUX/android/out/target/product/foo/fotakernel_$sin_type.img
#mv $backuppwd/weekly/LINUX/android/out/target/product/foo/fotakernel.sin $backuppwd/weekly/LINUX/android/out/target/product/foo/fotakernel_$sin_type.sin
###fota
cp device/cci/foo/radio/NON-HLOS.bin unsigned_imgs/modem.bin
cp device/cci/foo/radio/rpm.mbn unsigned_imgs
#cp out/target/product/foo/system.img unsigned_imgs
cp out/target/product/foo/userdata.img unsigned_imgs
cp out/target/product/foo/ramdumper.bin unsigned_imgs
cp out/target/product/foo/ltalabel.img unsigned_imgs
cd unsigned_imgs
rm -rf ../"$type"_SOMC_UNSIGNED.zip
zip -y ../"$type"_SOMC_UNSIGNED.zip ./*
cp ../"$type"_SOMC_UNSIGNED.zip "$utImagePath"

cd $backuppwd
#COPY ALL to SOMC END


cd $backuppwd
