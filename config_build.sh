#!/bin/bash

backuppwd=`pwd`

#Check if disk space is enough. 20GB
cm_build_space_OK=y
cm_build_space_OK_2=y
cm_build_space_OK_3=y
test `df -h ./ | grep "/dev" | awk '{print $4}' | sed 's/G.*$//g'` -gt 20 && cm_build_space_OK=y || cm_build_space_OK=n

df -h /Data | grep "/Data" > /dev/null
if [ "$?" == "0" ]; then
    test `df -h /Data | grep "/Data" | awk '{print $4}' | sed 's/G.*$//g'` -gt 20 && cm_build_space_OK_2=y || cm_build_space_OK_2=n
fi

df -h /Data/BuildFolder/CME_Release | grep "CME_Release" > /dev/null
if [ "$?" == "0" ]; then
    test `df -h /Data/BuildFolder/CME_Release | grep "CME_Release" | awk '{print $4}' | sed 's/G.*$//g'` -gt 50 && cm_build_space_OK_3=y || cm_build_space_OK_3=n
fi

if [ "$cm_build_space_OK" == "n" -o "$cm_build_space_OK_2" == "n" -o "$cm_build_space_OK_3" == "n" ]; then
    echo "Disk space less than 20GB. Stop build!"
    return
fi

serverDiskUsed1=`du -sh /media/DB_SA77_WB/ | sed -r 's/([0-9]*)G.*/\1/g'`
serverDiskUsed2=`du -sh /media/DB_SA77_CB/ | sed -r 's/([0-9]*)G.*/\1/g'`
serverDiskUsed=$(($serverDiskUsed1+$serverDiskUsed2))
#if [ "$serverDiskUsed" -gt "385" ];then
#if [ "$serverDiskUsed" -gt "135" ];then
if [ "$serverDiskUsed" -gt "300" ];then
    echo "Server Disk space less than 15GB. Stop build!"
    return
fi

ls /media/DB_SA77_WB/WB* > /dev/null
if [ "$?" != "0" ]; then
    echo "FAIL to mount /media/DB_SA77_WB"
    return
fi

ls /media/DB_SA77_CB/WB* > /dev/null
if [ "$?" != "0" ]; then
    echo "FAIL to mount /media/DB_SA77_CB"
    return
fi

read -p "Rebase Over [y/n]? " yesno
if [ $yesno != "y" -o $yesno == "n" ];then
   echo -e "\nPlease rebase first! \n"
   return
fi

read -p "Check modem branch name and script change [y/n]? " yesno
if [ $yesno != "y" -o $yesno == "n" ];then
   echo -e "\nPlease check modem branch name! \n"
   return
fi

read -p "Build with existing branch [y/n]? " yesno
if [ $yesno != "y" -a $yesno != "yes" -a $yesno != "n" -a $yesno != "no" ];then
   echo -e "\nWrong selection ! \n"
   return
fi

trunk=
if [ "$yesno" == "n" -o "$yesno" == "no" ];then
   read -p "   Trunk name [ex: SA77.1214_J68] " trunk
   if [ "$trunk" == "" ];then
      echo -e "\nTrunk is empty ! \n"
      return
   fi
   export cm_build_trunk=$trunk
   #export somc_build_trunk=$trunk
   export cm_build_new_branch=y

   read -p "   Check-in NON-HLOS.bin [y/n] " cm_build_checkin_modem
   if [ "$cm_build_checkin_modem" != "y" -a "$cm_build_checkin_modem" != "n" ];then
      echo -e "\nPlease select [y/n]! \n"
      return
   fi

   if [ "$cm_build_checkin_modem" == "y" ];then
       #modem branch name
       read -p "Modem Branch Name [ex: 8x30.12321] " modem_branch_name
       if [ "$modem_branch_name" == "" ];then
           echo -e "\nmodem_branch_name is empty ! \n"
           return
       fi
   fi
   #if [ "$cm_build_checkin_modem" == "y" ];then
   #   if [ ! -f ~/Modem_1489/NON_HLOS.bin ]; then
   #      echo -e "\nNON_HLOS.bin not exists!\n"
   #      return
   #   fi
   #   if [ ! -f ~/Modem_1489/sbl1.mbn ]; then
   #      echo -e "\nsbl1.mbn not exists!\n"
   #      return
   #   fi
   #   if [ ! -f ~/Modem_1489/sbl2.mbn ]; then
   #      echo -e "\nsbl2.mbn not exists!\n"
   #      return
   #   fi
   #   if [ ! -f ~/Modem_1489/sbl3.mbn ]; then
   #      echo -e "\nsbl3.mbn not exists!\n"
   #      return
   #   fi
   #   if [ ! -f ~/Modem_1489/tz.mbn ]; then
   #      echo -e "\ntz.mbn not exists!\n"
   #      return
   #   fi
   #   if [ ! -f ~/Modem_1489/rpm.mbn ]; then
   #      echo -e "\nrpm.mbn not exists!\n"
   #      return
   #   fi
   #
   #fi
fi

#read -p "Branch name [ex: DA803134WB099]" branch
read -p "Branch name [ex: SA77_0_0_026] " branch
if [ "$branch" == "" ];then
      echo -e "\nBranch is empty ! \n"
      return
fi

#read -p "Version [ex: 027]" label
read -p "Version [ex: 026] " label
if [ "$label" == "" ];then
      echo -e "\nLabel is empty ! \n"
      return
fi

#Flex version
read -p "Flex Version [ex: 2.7.J.0.063] " flexVersion
if [ "$flexVersion" == "" ];then
      echo -e "\nflexVersion is empty ! \n"
      return
fi

#S1 boot version
read -p "S1 Boot Version [ex: 22] " s1_version
if [ "$s1_version" == "" ];then
      echo -e "\ns1_version is empty ! \n"
      return
fi

#modem branch name
#read -p "Modem Branch Name [ex: 8x30.12321] " modem_branch_name
#if [ "$modem_branch_name" == "" ];then
#      echo -e "\nmodem_branch_name is empty ! \n"
#      return
#fi

#matchtable not exist list name
read -p "matchtable not exist list name [ex: SA77.12321_J68] " matchtableName
if [ "$matchtableName" == "" ];then
      echo -e "\nmatchtableName is empty ! \n"
      return
fi

#read -p "Current  Label[ex: DA80_DSR3134.099.0]" cm_current_git_label
#read -p "Current  Label[ex: SA77.026F.0] " cm_current_git_label
#if [ "$cm_current_git_label" == "" ];then
#      echo -e "\nCurrent Label is empty ! \n"
#      return
#fi

#read -p "Previous Label[ex: DA80_DSR3134.098.0]" cm_previous_git_label
#read -p "Previous Label[ex: SA77.025F.0] " cm_previous_git_label
#if [ "$cm_previous_git_label" == "" ];then
#      echo -e "\nPrevious Label is empty ! \n"
#      return
#fi

###Previous Weekly Build Branch Name
#read -p "Previous Branch Name[ex: SA77.0.0.004] " previousBranch
#if [ "$previousBranch" == "" ];then
#      echo -e "\nPrevious branch is empty ! \n"
#      return
#fi
#END#

###Current Weekly BUild Branch Name
#read -p "Current  Branch Name[ex: SA77.0.0.005] " currentBranch
#if [ "$currentBranch" == "" ];then
#      echo -e "\nCurrent branch is empty ! \n"
#      return
#fi
#END#

read -p "Build with signed key [y/n] " build_with_signedkey
if [ "$build_with_signedkey" == "y" ]; then
      read -p "   Signkey Password: " password
      if [ "$password" == "" ]; then
         echo -e "\nSignkey Password is empty ! \n"
         return
      fi

      read -p "   Do you want to include boot package in the OTA package(y/n): " boot_in_ota
      if [ "$boot_in_ota" == "y" -o "$boot_in_ota" == "yes" ];then
         bootpackage="M"
      else
         bootpackage="m"
      fi
fi

#read -p "Remove codebase [y/n] " cm_remove_codebase
#if [ "$cm_remove_codebase" == "" ]; then
#	echo -e "\nRemove codebase is empty ! \n"
#        return
#fi

####### get build feature ##########################
. ./build_feature.sh

export cm_build_config_ok=y
#export cm_build_branch=$branch$cm_build_label_append
export cm_build_branch=$branch
#export cm_build_label=$label$cm_build_label_append
export cm_build_label=$label
export BUILD_NUMBER='Android.'$label
export cm_config_ok=y

cd $backuppwd

