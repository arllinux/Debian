#!/bin/bash

# ./005_install_ntp_serv.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 21/03/2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else

	# NTP
	aptitude -y install ntp ntpdate
	service ntp stop
	ntpdate fr.pool.ntp.org
	touch /var/log/ntp.log
	chown ntp:ntp /var/log/ntp.log
	cp /etc/ntp.conf /etc/ntp.conf_old
	cat $CWD/../ntp/etc/ntp.conf > /etc/ntp.conf

	service ntp start
	sysv-rc-conf ntp on
	
fi

exit 0

