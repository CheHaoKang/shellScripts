#!/bin/bash

backuppwd=`pwd`

fetch_type=$cm_build_type

export cm_code_root_dir=$cm_root_dir/$fetch_type/LINUX/android

echo ""
echo "========== Create Build Folder (Android) Information =========="
if [ -d $cm_root_dir/$fetch_type/LINUX/android ]
then
	#Decken#Remove codebase or not###
	if [ "$cm_remove_codebase" == "y" -o "$cm_remove_codebase" == "Y" -o "$cm_remove_codebase" == "yes" -o "$cm_remove_codebase" == "" ]
	then
		rm -rfv $cm_root_dir/$fetch_type/LINUX/android
		mkdir $cm_root_dir/$fetch_type/LINUX/android
        	echo ""
		echo "	Remove old codebase..."
		cd $cm_root_dir/$fetch_type/LINUX
        	echo ""
	        echo "     Create android folder... "
	else
                echo ""
                echo "  Reserve codebase..."
                echo ""
	fi
	#Decken###
else
	test -d $cm_root_dir/$fetch_type || mkdir $cm_root_dir/$fetch_type
        test -d $cm_root_dir/$fetch_type/LINUX || mkdir $cm_root_dir/$fetch_type/LINUX
        test -d $cm_root_dir/$fetch_type/LINUX/android || mkdir $cm_root_dir/$fetch_type/LINUX/android
	echo ""
	echo "	Create android Folder..."
fi

if [ "$cm_build_new_branch" == "y" -o "$cm_build_new_branch" == "yes" ]; then
   branch=$cm_build_trunk
else
   branch=$cm_build_branch
fi

echo ""
echo "#############################################################################"
echo "========== Fetch codebase (Android) from "$cm_git_host_loc" =========="
echo ""
cd $cm_code_root_dir
export cm_fetch_start=`date +%c`

#Get repo
#wget http://10.113.0.42/files/CM_BUILD_test/repo --no-proxy
#chmod 755 ./repo

cp $backuppwd/repo ./
 
#Decken#Remove codebase or not###
if [ "$cm_remove_codebase" == "y" -o "$cm_remove_codebase" == "Y" -o "$cm_remove_codebase" == "yes" -o "$cm_remove_codebase" == "" ]; then
	#cp $cm_root_dir/repo .
	#./repo init -u git://$cm_git_host_loc/manifests.git -b $branch

	#Use GIT cache server
	./repo init -u git://$cm_git_host_loc/manifests.git -b $branch --reference='/media/Cache_dir/Cache_56/'
	#./repo init -u git://$cm_git_host_loc/manifests.git -b $branch
fi
#Decken###

./repo sync -j1 2>&1

export fetchResult=$?
if [ $fetchResult != 0 ]; then
    echo -e "\n===Fetch Code Error!===\n"
    cd $backuppwd
    return
elif [ $fetchResult == 0 ]; then
    echo -e "\n===Fetch Code Success!===\n"
fi

export cm_fetch_end=`date +%c`

echo ""
echo "#############################################################################"
echo "========== Fetch codebase (Android) Accomplishment from "$cm_git_host_loc" =========="
echo ""
echo -e "Start  Time: "$cm_fetch_start
echo -e "Finish Time: "$cm_fetch_end
echo ""



export cm_fetch_code_ok=y
cd $backuppwd
