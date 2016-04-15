#!/bin/bash

export cm_batch_build_start=`date +"%Y/%m/%d %T"`
export cm_release_dir=/Data/BuildFolder/CME_Release
export cm_build_type=weekly

. ./init_build.sh
. ./config_build.sh
if [ "$cm_config_ok" == "n" ]; then
    return
fi

###temp mod###
#if [ 'A' == 'B' ]; then

###back up codebase
test -e /Data/out_back_up || mkdir -p /Data/out_back_up
rm -rf /Data/out_back_up/android
mv weekly/LINUX/android /Data/out_back_up
rm -rf /Data/out_back_up/android/*SOMC*
###END back up codebase

###temp mod###
#if [ 'A' == 'B' ]; then
cd /Data/BuildFolder/autobuild/modem_sa77/
. ./WBmodemscript.sh "$cm_build_label" "$modem_branch_name" > modem_sa77.log 2>&1
cd /Data/BuildFolder/autobuild/2_sa77


###DETECT modem build status###
rm -f "/Data/BuildFolder/autobuild/2_sa77/MODEMBUILD_FAIL"
export MODEM=`echo $cm_build_label | sed 's/\.F//g'`
if [ ! -e "/Data/BuildFolder/CME_Release/sa77/modem/"$MODEM"_WB" ]; then
    echo "===modem build FAIL===" | tee -a MODEMBUILD_FAIL
    cm_build_modem_ok=n
    python modem_notify_build.py weekly
    return
else
    echo "===modem build SUCCESS==="
    cm_build_modem_ok=y
    python modem_notify_build.py weekly
fi

###temp mod
#fi


. ./fetch_code.sh
if [ "$cm_fetch_code_ok" == "n" ]; then
    python fetchcode_notify_build.py weekly
    return
else
    python fetchcode_notify_build.py weekly
fi 

#20120924 mark
cd $cm_code_root_dir && . ./ccienv/env && cd $cm_root_dir
if [ "$cm_build_new_branch" == "y" ]; then
    . ./branch.sh
fi
#end
###temp mod
#fi

#20120924 mark
if [ "$cm_build_new_branch" == "y" ]; then
    . ./checkin_flex_j68.sh
    . ./checkin_matchtable.sh
    #. ./checkin_flex_dev.sh

    if [ "$cm_build_checkin_modem" == "y" ]; then
        if [ ! -f ~/Modem_1489/NON-HLOS.bin ]; then
            echo -e "\nNON-HLOS.bin not exists!\n"
            return
        fi
        if [ ! -f ~/Modem_1489/sbl1.mbn ]; then
            echo -e "\nsbl1.mbn not exists!\n"
            return
        fi
        if [ ! -f ~/Modem_1489/sbl2.mbn ]; then
            echo -e "\nsbl2.mbn not exists!\n"
            return
        fi
        if [ ! -f ~/Modem_1489/sbl3.mbn ]; then
            echo -e "\nsbl3.mbn not exists!\n"
            return
        fi
        if [ ! -f ~/Modem_1489/tz.mbn ]; then
            echo -e "\ntz.mbn not exists!\n"
            return
        fi
        if [ ! -f ~/Modem_1489/rpm.mbn ]; then
            echo -e "\nrpm.mbn not exists!\n"
            return
        fi

        . ./checkin_modem_j68.sh
        if [ "$checkin_modem_ok" == "no" ]; then
            echo -e "\ncheckin modem FAIL!!!\n"
            return
        fi
        #. ./checkin_modem_dev.sh
    fi

    . ./sync_flex_modem.sh
fi

#fi
#temp mod end#

#. ./fetch_code.sh
#if [ "$cm_fetch_code_ok" == "n" ]; then
#    return
#fi

#cd $cm_code_root_dir && ./repo sync cci/flex/common && ./repo sync device/cci/sa77 && cd $cm_root_dir
#if [ "$cm_build_new_branch" == "y" ]; then
#    . ./branch.sh
#fi

#fi

#. ./sync_flex_modem.sh
#. ./label_append.sh

. ./export_vars.sh

. ./build.sh
if [ "$cm_build_ok" == "y" ]; then
#    . ./sign.sh
#    . ./gen_SOMC_files.sh

#    . ./gen_SOMC_files.sh v3

    #. ./fota_zip.sh    

    . ./pack.sh

    . ./genhex.sh

#    . ./gen_SOMC_files.sh

    . ./gen_SOMC_files.sh v3 > weekly/LINUX/android/"$cm_build_label"_gen_SOMC.log 2>&1
    . ./matchtable_check.sh
fi


export cm_batch_build_end=`date +"%Y/%m/%d %T"`
python notify_build.py weekly

#Generate OTA package and rooted flex after sending notification mail
#if [ "$cm_build_ok" == "y" ]; then
    # Generate additional rooted flex
#    cm_branch_check=`echo $cm_build_trunk | sed 's/\.[0-9]*$//g'`
#    if [ "$cm_branch_check" == "da80" ];then
#        echo "Generate rooted flex for eMobile"
#        . ./gen_flex_rooted.sh eMobile
#    elif [ "$cm_branch_check" == "SBM" ];then
#        echo "Generate rooted flex for SBM"
#        . ./gen_flex_rooted.sh SBM
#    fi
#    . ./pack_ota.sh
#fi
