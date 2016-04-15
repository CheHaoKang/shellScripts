#!/bin/bash

backuppwd=`pwd`
cd $ANDROID_BUILD_TOP

region=$1

if [ "$region" == "" ]; then
  region=eMobile
fi

echo "Region is" $region

out_folder=$ANDROID_BUILD_TOP/out/dist
cd $out_folder

if test -e $out_folder/flex_root/foo3-target_files-signed_tmp.zip
then
  echo "Already have temp Signed Target-files"
else
  mkdir -p $out_folder/flex_root
  cp $out_folder/foo3-target_files-signed.zip $out_folder/flex_root/foo3-target_files-signed_tmp.zip
fi

cd $out_folder/flex_root
unzip foo3-target_files-signed_tmp.zip FLEX/flex_$region/cci.prop

TMP_prop_file="temp.prop.$$"

test -f FLEX/flex_$region/cci.prop && sed '/ro\.enter_dl_mode/s/=0/=1/' FLEX/flex_$region/cci.prop > $TMP_prop_file

test -f FLEX/flex_$region/cci.prop && mv -f $TMP_prop_file FLEX/flex_$region/cci.prop

echo "update cci.prop"
zip foo3-target_files-signed_tmp.zip ./FLEX/flex_$region/cci.prop

echo "Transfer to ext4 image"

mkdir -p Signed_Image

$ANDROID_BUILD_TOP/build/tools/releasetools/img_from_target_files -f $region foo3-target_files-signed_tmp.zip ./Signed_Image/$region-image.zip

echo "Unzip Root Flex"
cd Signed_Image
unzip $region-image.zip flex_$region.img.ext4

#### Copy files to $image_dir ####
if [ -f ./flex_$region.img.ext4 ]; then
    cp ./flex_$region.img.ext4 $image_dir'/flex_'$region'_rooted.img.ext4'
fi

cd $backuppwd

