#!/bin/bash

backuppwd=`pwd`

cd $cm_code_root_dir

./repo init -u git://10.113.0.56/manifests.git -b "$cm_build_branch" --reference='/media/Cache_dir/Cache_56/'
./repo sync -d

export fetchResult=$?
if [ $fetchResult != 0 ]; then
    echo -e "\n===Sync Code Error!===\n"
    return
elif [ $fetchResult == 0 ]; then
    echo -e "\n===Sync Code Success!===\n"
fi
#./repo sync cci/flex/common
#./repo sync device/cci/sa77

cd $backuppwd
