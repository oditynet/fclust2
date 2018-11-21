#!/bin/bash

# Добавить  разом всехЖ
# for i in $(wbinfo -u|head);do bash adduser.sh $i;done
#
#     echo -e "$(ls -1)"|parallel -j 10 rsync --info=progress2  -a '{}' "/home/DEPO/bogdanov.dmitriy/users/Redirected\ folders/Downloads/"
#
#    echo -e "$(ls -1)"|parallel -j 10 rsync --info=progress2  -a '{}' "/home/DEPO/bogdanov.dmitriy/users/Redirected\ folders/Downloads/"
#

ROOT=0         # $UID root = 0.
if [ -z "$1" ]; then
    echo " bash adduser.sh %1 ( AD username )"
    exit 1;
fi

if [ "$UID" -ne "$ROOT" ]
then
  echo -e "\e[31mТолько root может запускать этот сценарий.\e[0m"
  exit 1;
fi

if [  -d "/home/DEPO/$1" ]; then
    echo -e "\e[31mДиректория существует\e[0m"
    exit 1;
else
	if [[ "$(wbinfo -u|grep -i $1|head -1)" == "$1" ]];then
	    echo -e "\e[36mAdd user $1\e[0m"
	    mkdir "/home/DEPO/$1"
	    #chown stogniev.aleksandr:"domain users" /home/DEPO/stogniev.aleksandr
	    chown $1:"domain users" /home/DEPO/$1
	    chmod 700 /home/DEPO/$1
	    mkdir "/home/DEPO/$1/Redirected folders"
	    #chown $1:"domain users" /home/DEPO/$1/WINDOWS
	    #chmod 700 /home/DEPO/$1/WINDOWS
	    #setfacl -m default:u:$1:rwx /home/DEPO/$1
	    #setfacl -m default:g:"Domain Users":--- /home/DEPO/$1
#	    edquota -u $1
	    setquota -u -F vfsv0 $1  20971520  31457280 0 0 /
	    
	    echo -e "\e[32mGood.\e[0m"
	fi
fi
exit 0

