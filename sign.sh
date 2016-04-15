#!/bin/bash

if [ "$cm_build_ok" != "y" ]; then
    return
fi

backuppwd=`pwd`

if [ "$password" != "" ]; then
    . $cm_code_root_dir'/build/tools/signkey.sh'
fi

cd $backuppwd

