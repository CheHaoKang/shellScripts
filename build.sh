#!/bin/bash

backuppwd=`pwd`

#### here export variables for later usage maybe ####
DATE=`date +%Y%m%d`
cm_build_log=$DATE'-android.log'
cm_git_log=$DATE'-git.log'
export cm_build_log_zip=$DATE'-android-log.zip'
export cm_git_log_zip=$DATE'-git-log.zip'
export cm_checkin_log_zip=$DATE'-checkin-log.zip'

cd $cm_code_root_dir

rm -rf out
rm -f *-android.log *-git.log
rm -f *-android-log.zip *-git-log.zip
#rm -rf *.zip

echo '. ./ccienv/"$cm_build_project""$cm_build_feature"_env'
. './ccienv/'$cm_build_project''$cm_build_feature'_env'
#. './ccienv/da80'$cm_build_feature'_env'
export cm_build_bin_dir=$cm_code_root_dir/out/target/product/$TARGET_PRODUCT
##make -j4
setpaths

###Decken Add_build code timer###
export cm_build_start=`date +%c`

export BOARD_KERNEL_BOOTIMG="YES"
#make -j$cm_build_machine_core dist > $cm_build_log 2>&1
make -j$cm_build_machine_core > $cm_build_log 2>&1

if [ $? -ne 0 ];then
    echo "" | tee -a $cm_build_log
    echo " Build terminated "$cm_build_project": "$cm_build_branch" ..." | tee -a $cm_build_log
    echo "" | tee -a $cm_build_log
else
    echo "" | tee -a $cm_build_log
    echo " Build succeed "$cm_build_project": "$cm_build_branch" ..." | tee -a $cm_build_log
    echo -e "Start  Build Time: "$cm_build_start | tee -a $cm_build_log
    echo -e "Finish Build Time: "$cm_build_end | tee -a $cm_build_log
    echo "" | tee -a $cm_build_log
    ####  Here build flex.
#    if [ -d vendor/cci-flex ]; then
#        folder=`ls -l vendor/cci-flex | grep ^d | awk '{print $NF}'`
#        for var in $folder
#        do
#            if [ "$var" != "zh_TW" ];then
#                make -j$cm_build_machine_core TARGET_FLEX=$var flex.img
#                cp -r vendor/cci-flex/$var $cm_build_bin_dir
###                cp $cm_build_bin_dir'/framework-res-'$var'.apk' $cm_build_bin_dir'/'$var'/flex'
###                mv $cm_build_bin_dir'/'$var'/flex/framework-res-'$var'.apk' $cm_build_bin_dir'/'$var'/flex/framework-res.apk'
#            fi
#        done
#        make -j$cm_build_machine_core clean-flex.img
#        make -j$cm_build_machine_core TARGET_FLEX=zh_TW flex.img
#        unset TARGET_FLEX
#    else
#        echo "No build flex"
#    fi
    export cm_build_ok=y
fi

###Decken Add_build code timer###
export cm_build_end=`date +%c`

zip -j $cm_build_log_zip $cm_build_log
./repo forall -c git whatchanged --since="8 days ago" > $cm_git_log
zip -j $cm_git_log_zip $cm_git_log

###Extract Check-in Codes between Previous Branch and Now Branch
#export preVersion=$(($((`echo $cm_build_branch | sed -r 's/[A-Z]+[0-9]+[A-Z_0]+//g'`))-1))
export preVersion=`echo $cm_build_label | sed -r 's/\.F//g'`
preVersion=`echo $preVersion | sed -r 's/[0]*//g'`
preVersion=$(($((`echo $preVersion`))-1))
if [ $preVersion -lt 10 ]; then
    preVersion=00$preVersion
else
    preVersion=0$preVersion
fi

#need to check
./repo forall -p -c 'git log remotes/korg/SA77_0_0_$preVersion..$cm_build_branch | grep BugID' > Check-inSummary.txt
#./repo forall -p -c 'git log remotes/korg/WB.0.0.002..$cm_build_branch | grep BugID' > Check-inSummary.txt

zip -j $cm_checkin_log_zip "Check-inSummary.txt"
###


cd $backuppwd
