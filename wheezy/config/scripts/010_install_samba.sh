#!/bin/bash

# ./010_install_samba.sh

# Dernière modifs 15 avril 2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
    else
	aptitude -y install samba smbclient

	groupadd smbguest 
	useradd -g smbguest -s /bin/false -c "Utilisateur Public Samba" smbguest 
	passwd -l smbguest 
	smbpasswd -a smbguest -d

	mkdir -pv -m 1777 /srv/samba/public
	cp /etc/samba/smb.conf /etc/samba/smb.conf_old
	cat $CWD/../samba/etc/samba/smb.conf > /etc/samba/smb.conf
	chmod 644 /etc/samba/smb.conf

	service smb restart
	sysv-rc-conf samba on
fi

exit 0

