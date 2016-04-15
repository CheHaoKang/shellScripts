#!/bin/bash

backuppwd=`pwd`
echo ""
echo "========== Branch Folder (Android) Information =========="

export cm_branch_start=`date +%c`
cd $cm_code_root_dir
./repo forall -c "git gerrit branch $cm_build_branch"
export cm_branch_end=`date +%c`

echo ""
echo "#############################################################################"
echo "========== Branch (Android) Accomplishment from "$cm_git_host_loc" =========="
echo ""
echo -e "Start  Time: "$cm_branch_start
echo -e "Finish Time: "$cm_branch_end
echo ""
echo ""
echo "##########################################################"

cd ~
rm -rf manifests
git clone ssh://bruno_lin@$cm_git_host_loc/var/git_repo/manifests.git
cd manifests
git checkout remotes/origin/$cm_build_trunk
#git branch $cm_build_branch
git checkout -b $cm_build_branch
echo ':1,$s/ <default remote="korg" revision="'$cm_build_trunk'"/ <default remote="korg" revision="'$cm_build_branch'"/:wq' | ex default.xml
#echo ':1,$s/ <default remote="korg" revision="'$cm_build_trunk'"/ <default remote="korg" revision="'$cm_build_branch'"/:wq' | ex a31.xml
git commit -a -m "add weekly build $cm_build_branch"
git push origin $cm_build_branch
cd $backuppwd

#Append label to flex
#. ./label_append.sh
