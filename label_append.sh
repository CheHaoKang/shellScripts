#!/bin/bash

backuppwd=`pwd`

build_feature=`echo $cm_build_feature | sed -r 's/_//g'`

if [ "$build_feature" == "" ]; then
    build_feature="eng"
fi

cd "$cm_code_root_dir"/vendor/cci/flex/common
test -f Android_Flex_prop.csv && sed -i \
        -e '/ro\.build\.display\.id/s/0\.0\.[0-9]\{3\}[\.BF]*/0\.0\.'$cm_build_label'\.'$build_feature'/g' \
        Android_Flex_prop.csv

cd $backuppwd
