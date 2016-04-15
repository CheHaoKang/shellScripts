#!/bin/bash

backuppwd=`pwd`

cm_root_dir="/Data/BuildFolder/autobuild/2_foo"
fetch_type="weekly"
cm_git_host_loc="10.113.0.56"

export cm_merge_code_ok=n
export cm_code_root_dir=$cm_root_dir/$fetch_type/LINUX/android
export branch=
export mergeBranch=

read -p "main trunk name [ex: foo.1214_foo2] " branch
if [ "$branch" == "" ];then
      echo -e "\nbranch is empty ! \n"
      return
fi

read -p "merge branch name [ex: foo_0_0_026_B] " mergeBranch
if [ "$mergeBranch" == "" ];then
      echo -e "\nmergeBranch is empty ! \n"
      return
fi

echo ""
echo "========== Create Merge Folder (Android) Information =========="
if [ -d $cm_root_dir/$fetch_type/LINUX/android ]
then
        rm -rfv $cm_root_dir/$fetch_type/LINUX/android
        mkdir $cm_root_dir/$fetch_type/LINUX/android
        echo ""
        echo "  Remove old codebase..."
        cd $cm_root_dir/$fetch_type/LINUX
        echo ""
        echo "     Create android folder... "
else
        test -d $cm_root_dir/$fetch_type || mkdir $cm_root_dir/$fetch_type
        test -d $cm_root_dir/$fetch_type/LINUX || mkdir $cm_root_dir/$fetch_type/LINUX
        test -d $cm_root_dir/$fetch_type/LINUX/android || mkdir $cm_root_dir/$fetch_type/LINUX/android
        echo ""
        echo "  Create android Folder..."
fi

#Merge foo3ICS_FBTBWXX modem files to main trunk, avoid auto merge conflicts
if [ 'A' == 'B' ]; then
cd ~
rm -rf foo
git clone ssh://bruno_lin@$cm_git_host_loc/var/git_repo/device/cci/foo.git
cd foo
git checkout remotes/origin/$branch -b $branch
test -e modem/ && git checkout remotes/origin/$mergeBranch modem/* 
git checkout remotes/origin/$mergeBranch radio/*
git commit -a -m "Use modem images from $mergeBranch"
git push origin
cd ..
rm -rf foo
cd $backuppwd
fi
####

echo ""
echo "#############################################################################"
echo "========== Fetch codebase (Android) from "$cm_git_host_loc" =========="
echo ""
cd $cm_code_root_dir
export cm_fetch_start=`date +%c`

#cp $cm_root_dir/repo .
#./repo init -u git://$cm_git_host_loc/manifests.git -b $branch

#Get repo
#wget http://10.113.0.42/files/CM_BUILD_test/repo --no-proxy
#chmod 755 ./repo
cp $backuppwd/repo ./

#Use GIT cache server
./repo init -u git://$cm_git_host_loc/manifests.git -b $branch --reference='/media/Cache_dir/Cache_56/'

#Add some information for .git/config
cd .repo/manifests/
git config --add user.name "san_hsu"
git config --add user.email "san_hsu@compalcomm.com"
git config --add bugzilla.project "foo"
git config --add bugzilla.loginname "san_hsu@compalcomm.com"
git config --add bugzilla.password "1234567"
cd ../../
#

#./repo sync 2>&1
#Fetch 4 projects simultaneously
./repo sync -j1 2>&1

fetchResult=$?
if [ $fetchResult != 0 ]; then
    echo -e "\n===Fetch Code Error!===\n"
    return
elif [ $fetchResult == 0 ]; then
    echo -e "\n===Fetch Code Success!===\n"
fi


export cm_fetch_end=`date +%c`

echo ""
echo "#############################################################################"
echo "========== Fetch codebase (Android) Accomplishment =========="
echo ""
echo -e "Start  Time: "$cm_fetch_start
echo -e "Finish Time: "$cm_fetch_end
echo ""

############START-Decken Add#################
#Decken_Add_20120406
. './ccienv/foo_env'

#versionNum=$1
#Merge foo3ICS_FBTBWXX modem files to main trunk, avoid auto merge conflicts
#cd $cm_code_root_dir/device/cci/foo3
#git checkout korg/$mergeBranch modem/* 
#git checkout korg/$mergeBranch radio/*
#git commit -a -m "Use modem images from $mergeBranch"
#

cd $cm_code_root_dir

export cm_merge_start=`date +%c`
#check differences between older and newer codebase project lists
./repo forall -p -c 'git merge --no-ff korg/$mergeBranch;git gerrit heads/$branch' > mergecode.log 2>&1
export cm_merge_end=`date +%c`


echo "" | tee -a mergecode.log
echo "#############################################################################" | tee -a mergecode.log
echo "========== Merge code Accomplishment from FOUR BRANCHES at "$cm_git_host_loc" ==========" | tee -a mergecode.log
echo "" | tee -a mergecode.log
echo -e "Start  Merge Time: "$cm_merge_start | tee -a mergecode.log
echo -e "Finish Merge Time: "$cm_merge_end | tee -a mergecode.log
echo "" | tee -a mergecode.log
############END-Decken Add#################

###Conflict DETECT###
conflictTimes=`grep -ic "conflict" mergecode.log`
if [ "$conflictTimes" -ne 0 ]; then
    echo ""
    echo "===Conflict happens, please inform RD===" | tee -a mergecode.log
    echo ""
    
    zip -j "mergecode.zip" "mergecode.log"
    python $backuppwd/merge_notify_build.py weekly    
	
    return
fi
###

cm_merge_code_ok=y
zip -j "mergecode.zip" "mergecode.log"
python $backuppwd/merge_notify_build.py weekly    

cd $backuppwd
