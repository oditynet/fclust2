#!/bin/bash
if [[ "$(dpkg -l|grep ' pv '|wc -l)" == "0" ]];then
    echo " Are you installed a: apt-get install parallel rsync pv libpam-mount"
    exit 1;
fi
if [ -z "$1" ]; then
    echo " bash copy.sh %1"
    exit 1;
fi
printf 'Настройка - 1, Копирование данных - 2 '
read num
case $num in
1)
mkdir /home/user/$1/users
chown $1:"domain users" /home/user/$1/users
mkdir /home/user/$1/tmp
chown $1:"domain users" /home/user/$1/tmp
cp -f  pam_mount.conf.xml /etc/security/
echo -e "\e[32mGood.\e[0m"
;;
#sudo su
2)
if [[ "$(cat /proc/mounts|grep fclust2|wc -l)" == "1" ]];then
    echo -e "\e[36mOk. Go to copy...\e[0m"
    mkdir "/home/user/$1/users/Redirected folders"
    chown $1:"domain users" "/home/user/$1/users/Redirected folders"
    cd "/home/user/$1/tmp/Redirected folders/"
    echo -e "$(ls -1 )"|pv -S $(du -sb  "/home/user/$1/tmp/Redirected\ folders/"| awk '{print $1}')|parallel -j 10 rsync --info=progress2  -a '{}' "/home/DEPO/$1/users/Redirected\ folders/"
    echo -e "\e[36mOk. Copy Downloads...\e[0m"
    cd "/home/user/$1/Загрузки/"
    echo -e "$(ls -1 /home/user/$1/Загрузки/)"| parallel -j 10 rsync --info=progress2  -a '{}' "/home/user/$1/users/Redirected\ folders/Downloads/"
    echo -e "\e[36mOk. Copy Desktop...\e[0m"
    cp -r -p "/home/user/$1/Desktops/Desktop1/." "/home/DEPO/$1/users/Redirected folders/Desktop"
    echo -e "\e[36mOk. Copy Documents...\e[0m"
    cp -r -p "/home/user/$1/Документы/." "/home/user/$1/users/Redirected folders/Documents"

    cp -f user-dirs.dirs /home/user/$1/.config/
    echo -e "\e[32mGood.\e[0m"
else
    echo -e "\e[31mfclust2 not mount!\e[0m"
    exit 1;
fi
;;
*)
    echo "Hmm..."
    exit 1;
;;
esac
exit 0;

