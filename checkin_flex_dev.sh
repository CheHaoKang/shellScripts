#!/bin/bash

backuppwd=`pwd`
echo ""
echo "========== Check-in Flex (Android) Information =========="

#read -p "Version Number[ex: 004] " version
#if [ "$versionNumber" == "" ];then
#   echo -e "\nVersion Number EMPTY !\n"
#   return
#fi

version=`echo $cm_build_label | sed 's/\.F//g'`
version=$version".B"

export dev_build_branch=`echo $cm_build_branch | sed 's/_F//g'`
dev_build_branch=$dev_build_branch"_B"

cd ~/temp
rm -rf common 
git clone ssh://bruno_lin@$cm_git_host_loc/var/git_repo/cci/flex/common.git
cd common
#git checkout $cm_build_trunk
git checkout $dev_build_branch

if [ ! -e Android_Flex_prop.csv ]; then
    echo -e "No Flex File\n"
    cd $backuppwd
    return
fi

#SMP
test -f Android_Flex_prop.csv && sed -i \
	-e '/ro\.cci\.flex_version/s/FF_SMP_SA77\.0\.0\.[0-9]\{3\}[\.BF]*/FF_SMP_SA77\.0\.0\.'$version'/' \
       	-e '/ro\.version/s/SA77\.0\.0\.[0-9]\{3\}[\.BF]*/SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.client/s/SA77\.0\.0\.[0-9]\{3\}[\.BF]*/SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.incremental/s/Android\.SA77\.0\.0\.[0-9]\{3\}[\.BF]*/Android\.SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.oem\.version/s/Android\.SA77\.0\.0\.[0-9]\{3\}[\.BF]*/Android\.SA77\.0\.0\.'$version'/g' \
       	Android_Flex_prop.csv
        #-e '/ro\.build\.display\.id/s/2\.7\.J\.0\.[0-9]\{3\}[\.BF]*/2\.7\.J\.0\.'$version'/g' \
###

#DEV
test -f Android_Flex_prop.csv && sed -i \
	-e '/ro\.cci\.flex_version/s/FF_DEV_SA77\.0\.0\.[0-9]\{3\}[\.BF]*/FF_DEV_SA77\.0\.0\.'$version'/' \
       	-e '/ro\.version/s/SA77\.0\.0\.[0-9]\{3\}[\.BF]*/SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.client/s/SA77\.0\.0\.[0-9]\{3\}[\.BF]*/SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.incremental/s/Android\.SA77\.0\.0\.[0-9]\{3\}[\.BF]*/Android\.SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.oem\.version/s/Android\.SA77\.0\.0\.[0-9]\{3\}[\.BF]*/Android\.SA77\.0\.0\.'$version'/g' \
       	Android_Flex_prop.csv
        #-e '/ro\.build\.display\.id/s/2\.7\.J\.0\.[0-9]\{3\}[\.BF]*/2\.7\.J\.0\.'$version'/g' \
###

#SHP
test -f Android_Flex_prop.csv && sed -i \
	-e '/ro\.cci\.flex_version/s/FF_SHP_SA77\.0\.0\.[0-9]\{3\}[\.BF]*/FF_SHP_SA77\.0\.0\.'$version'/' \
       	-e '/ro\.version/s/SA77\.0\.0\.[0-9]\{3\}[\.BF]*/SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.client/s/SA77\.0\.0\.[0-9]\{3\}[\.BF]*/SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.version\.incremental/s/Android\.SA77\.0\.0\.[0-9]\{3\}[\.BF]*/Android\.SA77\.0\.0\.'$version'/g' \
       	-e '/ro\.build\.oem\.version/s/Android\.SA77\.0\.0\.[0-9]\{3\}[\.BF]*/Android\.SA77\.0\.0\.'$version'/g' \
       	Android_Flex_prop.csv
        #-e '/ro\.build\.display\.id/s/2\.7\.J\.0\.[0-9]\{3\}[\.BF]*/2\.7\.J\.0\.'$version'/g' \
###

#SMP
#test -f Android_Flex_prop.csv && sed -i \
#        -e '/ro\.cci\.flex_version/s/FF_SMP_'$previousBranch'/FF_SMP_'$currentBranch'/' \
#        -e '/ro\.version/s/'$previousBranch'/'$currentBranch'/g' \
#        -e '/ro\.build\.version\.client/s/'$previousBranch'/'$currentBranch'/g' \
#        -e '/ro\.build\.display\.id/s/[0-9]\{3\}-Sample/'$version'-Sample/' \
#        -e '/ro\.build\.version\.incremental/s/Android\.'$previousBranch'/Android\.'$currentBranch'/g' \
#        -e '/ro\.build\.oem\.version/s/Android\.'$previousBranch'/Android\.'$currentBranch'/g' \
#        Android_Flex_prop.csv
#END#

#DEV
#test -f Android_Flex_prop.csv && sed -i \
#        -e '/ro\.cci\.flex_version/s/FF_DEV_'$previousBranch'/FF_DEV_'$currentBranch'/' \
#        -e '/ro\.version/s/'$previousBranch'/'$currentBranch'/g' \
#        -e '/ro\.build\.version\.client/s/'$previousBranch'/'$currentBranch'/g' \
#        -e '/ro\.build\.display\.id/s/[0-9]\{3\}-Development/'$version'-Development/' \
#        -e '/ro\.build\.version\.incremental/s/Android\.'$previousBranch'/Android\.'$currentBranch'/g' \
#        -e '/ro\.build\.oem\.version/s/Android\.'$previousBranch'/Android\.'$currentBranch'/g' \
#        Android_Flex_prop.csv
#END#

#SHP
#test -f Android_Flex_prop.csv && sed -i \
#        -e '/ro\.cci\.flex_version/s/FF_SHP_'$previousBranch'/FF_SHP_'$currentBranch'/' \
#        -e '/ro\.version/s/'$previousBranch'/'$currentBranch'/g' \
#        -e '/ro\.build\.version\.client/s/'$previousBranch'/'$currentBranch'/g' \
#        -e '/ro\.build\.display\.id/s/[0-9]\{3\}-Shipping/'$version'-Shipping/' \
#        -e '/ro\.build\.version\.incremental/s/Android\.'$previousBranch'/Android\.'$currentBranch'/g' \
#        -e '/ro\.build\.oem\.version/s/Android\.'$previousBranch'/Android\.'$currentBranch'/g' \
#        Android_Flex_prop.csv
#END#


git commit -a -m "Modify weekly build Flex $version"
git push origin

###
cd ..
rm -rf common
cd $backuppwd
