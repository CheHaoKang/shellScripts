#!/bin/bash

backuppwd=`pwd`
echo ""
echo "========== Branch Folder (Android) Information =========="

cd ~
rm -rf sa77
git clone ssh://bruno_lin@$cm_git_host_loc/var/git_repo/device/cci/sa77.git
cd sa77
#git checkout remotes/origin/$cm_build_trunk -b $cm_build_trunk
git checkout remotes/origin/$dev_build_branch -b $dev_build_branch

#change to mv
mv ~/Modem_1489/NON-HLOS.bin ./radio/NON-HLOS.bin
mv ~/Modem_1489/rpm.mbn ./radio/rpm.mbn
mv ~/Modem_1489/sbl1.mbn ./radio/sbl1.mbn
mv ~/Modem_1489/sbl2.mbn ./radio/sbl2.mbn
mv ~/Modem_1489/sbl3.mbn ./radio/sbl3.mbn
mv ~/Modem_1489/tz.mbn ./radio/tz.mbn

#delete
#mv ~/Modem_1489/NON_HLOS.bin ./modem/NON_HLOS_B9.bin

test -e ./modem || mkdir -p ./modem
mv ~/Modem_1489/gpt_backup0.bin ./modem/
mv ~/Modem_1489/gpt_main0.bin ./modem/
mv ~/Modem_1489/patch0.xml ./modem/
mv ~/Modem_1489/rawprogram0.xml ./modem/

git add .
git commit -a -m "Replace NON-HLOS.bin for $dev_build_branch"
git push origin
cd $backuppwd
