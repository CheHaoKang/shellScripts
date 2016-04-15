#!/bin/bash


export cm_batch_build_start=`date +"%Y/%m/%d %T"`
export cm_release_dir=/Data/BuildFolder/CME_Release
export cm_build_type=weekly

. ./init_build.sh
. ./config_build.sh
if [ "$cm_config_ok" == "n" ]; then
    return
fi
. ./fetch_code.sh

cd $cm_code_root_dir && . ./ccienv/env && cd $cm_root_dir
if [ "$cm_build_new_branch" == "y" ]; then
    . ./branch.sh
fi

