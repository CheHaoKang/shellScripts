backuppwd=`pwd`

#generate Hex File

export type=`cat $backuppwd/weekly/LINUX/android/out/target/product/foo/system/build.prop | grep "ro.build.type" | sed -r 's/.*=(.*)/\1/g'`
if [ "$type" == "eng" ]; then
    genhex Development
elif [ "$type" == "userdebug" ]; then 
    genhex Debug
else
    genhex Shipping
fi

#fversion=`echo $cm_build_branch | sed 's/.*_//g'`
export cm_version=`echo $cm_build_branch | sed -r 's/_/\./g'`

if [ -f $cm_build_bin_dir"/genhex/foo_android.img" ]; then
    #mv $cm_build_bin_dir"/genhex/foo_android.img" $cm_build_bin_dir"/genhex/foo_"$cm_build_feature"_"$cm_build_label".img"
    #image_dir=/Data/BuildFolder/CME_Release/foo/foo_0_0_009/eng/images
    #cm_build_bin_dir=/Data/BuildFolder/autobuild/foo/weekly/LINUX/android/out/target/product/foo
    mv $cm_build_bin_dir"/genhex/foo_android.img" $cm_build_bin_dir"/genhex/"$cm_version"_"$cm_build_feature".img"
    7zr a -y -mx=9 $image_dir"/"$cm_version"_"$cm_build_feature".7z" $cm_build_bin_dir"/genhex/"$cm_version"_"$cm_build_feature".img"
#cp $cm_code_root_dir/out/target/product/foo3/genhex/foo3ICS_$cm_build_label.tar.bz2 $image_dir
    ### copy hex file to /media/BU2_SMD/Internal Release/UT Image/foo3_ICS/WBXXX
    #test -e $utImagePath"/DMTool Hex File download" || mkdir -p $utImagePath"/DMTool Hex File download"
    test -e "$utImagePath" || mkdir -p "$utImagePath"
    cp $image_dir"/"$cm_version"_"$cm_build_feature".7z" "$utImagePath"

    #copy hex file to ftp
#    ftp -n<<!
#    open 10.113.72.28
#    user svd svd@7890
#    binary
#    cd /TPE_Sync/foo/Integration\ Test
#    mkdir "$cm_build_label"
#    cd "$cm_build_label"
#    lcd "$image_dir"
#    prompt
#    put "$cm_version"_"$cm_build_feature".7z "$cm_version"_"$cm_build_feature".7z
#    close
#    bye
#!
###
fi
#
cd $cm_root_dir
