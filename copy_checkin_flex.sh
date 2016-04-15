#!/bin/bash

backuppwd=`pwd`
echo ""
echo "========== Check-in Flex (Android) Information =========="

#read -p "Version Number[ex: 004] " version
#if [ "$versionNumber" == "" ];then
#   echo -e "\nVersion Number EMPTY !\n"
#   return
#fi

version=$cm_build_label

cd ~/temp
rm -rf common 
git clone ssh://bruno_lin@$cm_git_host_loc/var/git_repo/cci/flex/common.git
cd common
git checkout $cm_build_trunk

#SMP
test -f Android_Flex_prop.csv && sed -i \
	-e '/ro\.cci\.flex_version/s/FF_SMP_WB\.0\.0\.[0-9]\{3\}/FF_SMP_WB\.0\.0\.'$version'/' \
       	-e '/ro\.version/s/WB\.0\.0\.[0-9]\{3\}/WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.client/s/WB\.0\.0\.[0-9]\{3\}/WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.display\.id/s/[0-9]\{3\}-Sample/'$version'-Sample/' \
       	-e '/ro\.build\.version\.incremental/s/Android\.WB\.0\.0\.[0-9]\{3\}/Android\.WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.oem\.version/s/Android\.WB\.0\.0\.[0-9]\{3\}/Android\.WB\.0\.0\.'$version'/g' \
       	Android_Flex_prop.csv
###

#DEV
test -f Android_Flex_prop.csv && sed -i \
	-e '/ro\.cci\.flex_version/s/FF_DEV_WB\.0\.0\.[0-9]\{3\}/FF_DEV_WB\.0\.0\.'$version'/' \
       	-e '/ro\.version/s/WB\.0\.0\.[0-9]\{3\}/WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.client/s/WB\.0\.0\.[0-9]\{3\}/WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.display\.id/s/[0-9]\{3\}-Development/'$version'-Development/' \
       	-e '/ro\.build\.version\.incremental/s/Android\.WB\.0\.0\.[0-9]\{3\}/Android\.WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.oem\.version/s/Android\.WB\.0\.0\.[0-9]\{3\}/Android\.WB\.0\.0\.'$version'/g' \
       	Android_Flex_prop.csv
###

#SHP
test -f Android_Flex_prop.csv && sed -i \
	-e '/ro\.cci\.flex_version/s/FF_SHP_WB\.0\.0\.[0-9]\{3\}/FF_SHP_WB\.0\.0\.'$version'/' \
       	-e '/ro\.version/s/WB\.0\.0\.[0-9]\{3\}/WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.client/s/WB\.0\.0\.[0-9]\{3\}/WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.display\.id/s/[0-9]\{3\}-Shipping/'$version'-Shipping/' \
       	-e '/ro\.build\.version\.incremental/s/Android\.WB\.0\.0\.[0-9]\{3\}/Android\.WB\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.oem\.version/s/Android\.WB\.0\.0\.[0-9]\{3\}/Android\.WB\.0\.0\.'$version'/g' \
       	Android_Flex_prop.csv
###
#Factory
#test -f Android_Flex_prop.csv && sed -i \
#	-e '/ro\.cci\.flex_version/s/FF_foo3_Factory_[0-9]\{3\}/FF_foo3_Factory_'$version'/' \
#       	-e '/ro\.version/s/foo3_ICS_[0-9]\{3\}/foo3_ICS_'$version'/g' \
#       	-e '/ro\.build\.version\.client/s/foo3_ICS_[0-9]\{3\}/foo3_ICS_'$version'/g' \
#       	-e '/ro\.build\.display\.id/s/[0-9]\{3\}-MLC-Factory/'$version'-MLC-Factory/' \
#       	-e '/ro\.build\.version\.incremental/s/Android\.foo3_ICS_[0-9]\{3\}/Android.foo3_ICS_'$version'/g' \
#       	Android_Flex_prop.csv
###

git commit -a -m "Modify weekly build Flex $version"
git push origin

###
cd ..
rm -rf common
cd $backuppwd
