#!/bin/bash

# ./009_install_squid.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 24/03/2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else


	# Squid
	aptitude -y install squid
	cp /etc/squid/squid.conf /etc/squid/squid.conf_old
	cat $CWD/../squid/etc/squid/squid.conf > /etc/squid/squid.conf
	chmod 0644 /etc/squid/squid.conf
	service squid start
	sysv-rc-conf squid on
	
fi
exit 0

