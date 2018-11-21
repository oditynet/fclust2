#!/bin/bash


if [ -z "$1" ]; then
    echo " bash copy.sh %1"
    exit 1;
fi

mkdir /home/DEPO/$1/users
chown $1:"domain users" /home/DEPO/$1/users
mkdir /home/DEPO/$1/tmp
chown $1:"domain users" /home/DEPO/$1/tmp
cp -f  pam_mount.conf.xml1 /etc/security/
su $1
if [[ "$(cat /proc/mount|grep fclust2|wc -l)" == "1" ]];then
    echo -e "\e[36mOk. Go to copy...\e[0m"
    mkdir "/home/DEPO/$1/users/Redirected\ folders"
    #ls -1 /usr/|pv -s $(du -sb . | awk '{print $1}')
    echo -e "$(ls -1 /home/DEPO/$1/tmp/Redirected\ folders/)"|pv -s $(du -sb  /home/DEPO/$1/tmp/Redirected\ folders/| awk '{print $1}')|parallel -j 10 rsync --info=progress2  -a '{}' "/home/DEPO/$1/users/Redirected\ folders/"
    echo -e "\e[36mOk. Copy Downloads...\e[0m"
    echo -e "$(ls -1 /home/DEPO/$1/Загрузки/)"|pv -s $(du -sb  /home/DEPO/$1/Загрузки| awk '{print $1}')| parallel -j 10 rsync --info=progress2  -a '{}' "/home/DEPO/$1/users/Redirected\ folders/Downloads/"
    echo -e "\e[36mOk. Copy Desktop...\e[0m"
    cp -r -p "/home/DEPO/$1/Desktops/Desktop1/" "/home/DEPO/$1/users/Redirected\ folders/Desktop/"
    echo -e "\e[36mOk. Copy Documents...\e[0m"
    cp -r -p "/home/DEPO/$1/Документы/" "/home/DEPO/$1/users/Redirected\ folders/Documents/"

    cp -f user-dirs.dirs /home/DEPO/$1/.config/
    echo -e "\e[32mGood.\e[0m"
else
    echo -e "\e[31mfclust2 not mount!\e[0m"
    exit 1;
fi

exit 0;

