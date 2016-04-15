#!/bin/bash

backuppwd=`pwd`

if [ "$matchtableName" == "nocheck" ]; then
    return
fi

export type=`cat $backuppwd/weekly/LINUX/android/out/target/product/sa77/system/build.prop | grep "ro.build.type" | sed -r 's/.*=(.*)/\1/g'`

cd "$backuppwd"/weekly/LINUX/android/"$type"_SOMCv3

rm -rf dir_*
rm -rf *_notexist.list
rm -rf ../*exist_list.txt
rm -rf ../*matchtablecheck-log.zip

scp cme@10.113.41.212:/Data/matchtablelist/"$matchtableName"_notexist.list .
matchtableNotExistList=$(cat "$matchtableName"_notexist.list | grep -i "$type" | sed -r 's/.*==>//g')

#common_SOMCv3.zip
rm -rf common_SOMCv3.zip
cp ../common_SOMCv3.zip .
#common_SOMCv3.zip END

zipNames=$(ls *.zip)

for zipName in $zipNames
do
    echo $zipName
    unzip $zipName -d "dir_$zipName"
done

#echo -e "@@@Below are IN MATCHTABLE NOT IN IMAGES@@@\n" >> ../notexist_list.txt

fileNames=$(cat ../vendor/semc/build/jdm-specs/matchtable.xml | grep "datafile name="  | sed -r 's/.*datafile name=\"(.*)\".*>/\1/g')
#fileNames=$(cat ../vendor/semc/build/jdm-specs/matchtable.xml | sed -r 's/datafile name=\"alternatives\///g' | grep "datafile name=" | sed -r 's/.*datafile name=\"(.*)\".*>/\1/g')
for fileName in $fileNames
do
    isOdex=`echo $fileName | sed -r 's/.*\.(odex)/\1/g'`
    if [ "$type" != "user" -a "$isOdex" == "odex" ]; then
        continue
    fi

    for zipName in $zipNames
    do
        cd dir_$zipName
        ls $fileName > /dev/null 2>&1

        export findResult=$?
        if [ $findResult == 0 ]; then
            echo -e "$fileName EXISTS~\n"
            echo ""
            cd ..
            break
        fi

        cd ..
    done

    if [ $findResult != 0 ]; then
        skip="no"
        for matchtableNotExistName in $matchtableNotExistList
        do
            if [ "$fileName" == "$matchtableNotExistName" ]; then
                echo -e "$fileName SKIPPED~\n"
                echo ""
                skip="yes"
                break
            fi
        done

        if [ "$skip" == "no" ]; then
            if [ "$first" != "no" ]; then
                echo -e "@@@Below are IN MATCHTABLE NOT IN IMAGES@@@\n" >> ../notexist_list.txt
                first="no"
            fi
            echo -e "$fileName\n" >> ../notexist_list.txt
            echo ""
        fi
    fi
#    echo $fileName
done

if [ "$first" == "no" ]; then
    echo -e "@@@---END---IN MATCHTABLE NOT IN IMAGES@@@\n" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
fi
#echo -e "@@@Below APKS are IN IMAGES NOT IN MATCHTABLE@@@\n" >> ../notexist_list.txt

for zipName in $zipNames
do
    #unzip -l $zipName | grep '.apk$' | sed -r 's/.*\/(.*)/\1/g'
    apkNames=`unzip -l $zipName | grep '.apk$' | sed -r 's/.*:[0-9]{2}[ ]+(.*)/\1/g'`
    for apkName in $apkNames
    do
        existInM="no"
        for fileName in $fileNames
        do
            if [ "$fileName" == "$apkName" ]; then
                echo -e "\n$apkName is in matchtable!\n"
                existInM="yes"
                break
            fi
        done

        for matchtableNotExistName in $matchtableNotExistList
        do
            if [ "$apkName" == "$matchtableNotExistName" ]; then
                echo -e "$apkName SKIPPED~\n"
                echo ""
                existInM="yes"
                break
            fi
        done

        if [ "$existInM" == "no" ]; then
            if [ "$first2" != "no" ]; then
                echo -e "@@@Below APKS are IN IMAGES NOT IN MATCHTABLE@@@\n" >> ../notexist_list.txt
                first2="no"
            fi
            echo -e "$apkName\n" >> ../notexist_list.txt
        fi
    done
done

if [ "$first2" == "no" ]; then
    echo -e "@@@---END---APKS IN IMAGES NOT IN MATCHTABLE@@@\n" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
fi

appPackageNames=`cat ../vendor/semc/build/jdm-specs/matchtable.xml | grep -i 'package.*name="' | sed -r 's/.*package.*name=//g' | sed -r 's/signing.*//g' | sed -r 's/provides.*//g' | sed -r 's/XB-SEMC-Releasable.*//g' | sed -r 's/" *//g' | grep -i 'app-' | sed -r 's/(.*)/\1___/g'`
cat ../vendor/semc/build/jdm-specs/matchtable.xml | grep -i 'package.*name="' | sed -r 's/.*package.*name=//g' | sed -r 's/signing.*//g' | sed -r 's/provides.*//g' | sed -r 's/XB-SEMC-Releasable.*//g' | sed -r 's/" *//g' | grep -i 'app-' | sed -r 's/(.*)/\1___/g' > appPackageList.txt

for appPackageName in $appPackageNames
do
    times=`grep -wc "$appPackageName" appPackageList.txt`
    if [ "$times" -ge "2" ]; then
        if [ "$first3" != "no" ]; then
            echo -e "@@@Below are DUPLICATE APP NAMES@@@\n" >> ../notexist_list.txt
            first3="no"
        fi
        echo -e "$appPackageName \t\t$times times" >> ../notexist_list.txt
    fi
done

if [ "$first3" == "no" ]; then
    echo -e "@@@---END---DUPLICATE APP NAMES@@@\n" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
fi


for appPackageName in $appPackageNames
do
    #echo $appPackageName | grep "[A-Z]"
    echo $appPackageName | grep "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]"
    if [ "$?" == "0" ]; then
        if [ "$first4" != "no" ]; then
            echo -e "@@@Below are APP NAMES IN UPPER CASE@@@\n" >> ../notexist_list.txt
            first4="no"
        fi
        echo -e "$appPackageName" >> ../notexist_list.txt
    fi
done

if [ "$first4" == "no" ]; then
    echo -e "@@@---END---IN UPPER CASE APP NAMES@@@\n" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
fi

packageTimes=`grep -c "<package name" ../vendor/semc/build/jdm-specs/matchtable.xml`
slashPackageTimes=`grep -c "</package" ../vendor/semc/build/jdm-specs/matchtable.xml`
if [ "$packageTimes" != "$slashPackageTimes" ]; then
    echo -e "@@@ <package> is not equal with </package> @@@\n" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
    echo "" >> ../notexist_list.txt
fi


for zipName in $zipNames
do
    #unzip -l $zipName | grep '.apk$' | sed -r 's/.*\/(.*)/\1/g'
    apkTxtNames=`unzip -l $zipName | grep '.apk.txt$' | sed -r 's/.*:[0-9]{2}[ ]+(.*)/\1/g'`
    for apkTxtName in $apkTxtNames
    do
        existInM="no"
        for fileName in $fileNames
        do
            if [ "$fileName" == "$apkTxtName" ]; then
                echo -e "\n$apkTxtName is in matchtable!\n"
                existInM="yes"
                break
            fi
        done

        if [ "$existInM" == "no" ]; then
            if [ "$first5" != "no" ]; then
                #echo -e "@@@Below APK.TXTs are IN IMAGES NOT IN MATCHTABLE@@@\n" >> ../notexist_list.txt
                first5="no"
            fi
            #echo -e "$apkTxtName\n" >> ../notexist_list.txt
        fi
    done
done

if [ "$first5" == "no" ]; then
    echo ""
    #echo -e "@@@---END---APK.TXTs IN IMAGES NOT IN MATCHTABLE@@@\n" >> ../notexist_list.txt
    #echo "" >> ../notexist_list.txt
    #echo "" >> ../notexist_list.txt
    #echo "" >> ../notexist_list.txt
    #echo "" >> ../notexist_list.txt
    #echo "" >> ../notexist_list.txt
fi


rm -rf dir_*
rm -rf *_notexist.list
rm -rf appPackageList.txt
rm -rf common_SOMCv3.zip

cd ..
if [ -e "notexist_list.txt" ]; then
    export cm_matchtablecheck_log_zip='error_matchtablecheck-log.zip'
    export cm_matchtablecheck_ok="no"
    zip -j $cm_matchtablecheck_log_zip "notexist_list.txt"
else
    touch exist_list.txt
    export cm_matchtablecheck_log_zip='noerror_matchtablecheck-log.zip'
    export cm_matchtablecheck_ok="yes"
    zip -j $cm_matchtablecheck_log_zip "exist_list.txt"
fi

cd $backuppwd
