#!/bin/bash

backuppwd=`pwd`
echo ""
echo "========== Branch Folder (Android) Information =========="

checkin_modem_ok="no"

cd ~
rm -rf foo
git clone ssh://bruno_lin@$cm_git_host_loc/var/git_repo/device/cci/foo.git
if [ "$?" != "0" ]; then
    echo -e "git clone /var/git_repo/device/cci/foo.git FAIL!!!"
    cd $backuppwd
    return
fi

cd foo
#git checkout remotes/origin/$cm_build_trunk -b $cm_build_trunk
git checkout remotes/origin/$cm_build_branch -b $cm_build_branch

#change to mv
cp ~/Modem_1489/NON-HLOS.bin ./radio/NON-HLOS.bin
cp ~/Modem_1489/rpm.mbn ./radio/rpm.mbn
cp ~/Modem_1489/sbl1.mbn ./radio/sbl1.mbn
cp ~/Modem_1489/sbl2.mbn ./radio/sbl2.mbn
cp ~/Modem_1489/sbl3.mbn ./radio/sbl3.mbn
cp ~/Modem_1489/tz.mbn ./radio/tz.mbn

#delete
#mv ~/Modem_1489/NON_HLOS.bin ./modem/NON_HLOS_B9.bin

test -e ./modem || mkdir -p ./modem
cp ~/Modem_1489/gpt_backup0.bin ./modem/
cp ~/Modem_1489/gpt_main0.bin ./modem/
cp ~/Modem_1489/patch0.xml ./modem/
cp ~/Modem_1489/rawprogram0.xml ./modem/

git add .
git commit -a -m "Replace NON-HLOS.bin for $cm_build_branch"
git push origin

checkin_modem_ok="yes"
cd $backuppwd
