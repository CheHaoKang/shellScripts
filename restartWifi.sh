#!/bin/bash

# sudo crontab -e
# @reboot rm -rf /home/kang/restartWifi.log;/home/kang/restartWifi.sh > /home/kang/restartWifi.log 2>&1

#rm -rf /home/kang/restartWifi.log

first="YES"
while [ "YES" == "YES" ]
do
	if [ "$first" == "YES" ]; then
 		first="NO"
		echo "Start-up. Sleep for 3 mins."
		sleep 180
        fi

	ping www.google.com -c3

	if [ "$?" != "0" ]; then
		echo "Restart network-manager."
    		sudo service network-manager restart
	fi

        sleep 3
done
