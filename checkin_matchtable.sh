#!/bin/bash

backuppwd=`pwd`
echo ""
echo "========== Check-in Matchtable (Android) Information =========="

#read -p "Version Number[ex: 004] " version
#if [ "$versionNumber" == "" ];then
#   echo -e "\nVersion Number EMPTY !\n"
#   return
#fi

version=$cm_build_label

cd ~
rm -rf jdm-specs 
git clone ssh://bruno_lin@$cm_git_host_loc/var/git_repo/platform/vendor/semc/build/jdm-specs.git
if [ "$?" != "0" ]; then
    echo -e "git clone /var/git_repo/platform/vendor/semc/build/jdm-specs.git FAIL!!!"
    cd $backuppwd
    return
fi

cd jdm-specs
#git checkout $cm_build_trunk
git checkout $cm_build_branch

if [ ! -e matchtable.xml ]; then
    echo -e "No matchtable.xml\n"
    cd $backuppwd
    return
fi

if [ "$sign_feature" == "live" ]; then
    cp matchtable_live.xml matchtable.xml
else
    cp matchtable_test.xml matchtable.xml
fi

git add .
git commit -a -m "$version   $sign_feature sign, so copy matchtable_$sign_feature.xml into matchtable.xml"
git push origin

###
cd ..
rm -rf jdm-specs
cd $backuppwd
