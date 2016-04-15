#!/bin/bash

####### here to change export variable of cm_build_feature ##########
export cm_config_ok=y

#read -p "Build MHL mode(for factory)? [y/n]" mhl_mode
#if [ "$mhl_mode" == "y" -o "$mhl_mode" == "Y" ]; then
#     cm_build_feature="$cm_build_feature"_mhl
#fi

#read -p "Build User mode? [y/n] " feature_user
#if [ "$feature_user" == "y" -o "$feature_user" == "Y" ]; then
#    cm_build_feature="$cm_build_feature"_user
#fi

read -p "Which mode to Build? [1.user 2.debug 3.eng] " feature_user
if [ "$feature_user" == "1" ]; then
    cm_build_feature="$cm_build_feature"_user
fi
if [ "$feature_user" == "2" ]; then
    cm_build_feature="$cm_build_feature"_debug
fi
if [ "$feature_user" == "3" ]; then
    cm_build_feature="$cm_build_feature"
fi

read -p "Live Sign or Test Sign? [1.live 2.test] " sign_feature
if [ "$sign_feature" == "1" ]; then
    sign_feature="live"
    echo "Choose Live Sign!!!"
fi
if [ "$sign_feature" == "2" ]; then
    sign_feature="test"
    echo "Choose Test Sign!!!"
fi

