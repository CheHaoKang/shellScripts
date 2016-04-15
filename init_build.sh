#!/bin/bash

export cm_build_project=foo
export cm_config_ok=n
export cm_fetch_code_ok=n
export cm_branch_ok=n
export cm_build_ok=n
export cm_build_modem_ok=n
export cm_pack_ok=n
export cm_notify_ok=n

export cm_build_machine_core=$(grep -c ^processor /proc/cpuinfo)
export cm_root_dir=`pwd`
export cm_git_host_loc=10.113.0.56
export cm_cme_name=san_hsu
export cm_build_trunk=foo.1214
export cm_build_date=`date +%Y%m%d`
export cm_build_host_ip=`ifconfig eth0 | grep -i "inet addr" | awk '{print $2}' | awk 'BEGIN {FS=":"}{print $2}'`
export cm_build_branch=
export cm_build_new_branch=
export cm_build_label=
export cm_current_git_label=
export cm_previous_git_label=
export cm_build_label_append=
export password=
export cm_build_feature=
export cm_build_checkin_modem=n
export image_dir=
export bootpackage=m
export cm_remove_codebase=
export utImagePath=
export dev_build_branch=
export flexVersion=
export sign_feature=
export s1_version=
export modem_branch_name=
export matchtableName=
export checkin_modem_ok=
export cm_matchtablecheck_ok="none"
export LC_ALL='C'
#export LANG='C'
