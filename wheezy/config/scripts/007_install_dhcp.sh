#!/bin/bash

# ./007_install_dhcp.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 21/03/2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else

	
	# dhcp
	aptitude -y install dhcp3-server
	cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server_old
	cat $CWD/../dhcp/etc/default/isc-dhcp-server > /etc/default/isc-dhcp-server
	chmod 0644 /etc/default/isc-dhcp-server
	
	cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf_old
	cat $CWD/../dhcp/etc/dhcp/dhcpd.conf > /etc/dhcp/dhcpd.conf
	chmod 0644 /etc/dhcp/dhcpd.conf

	service isc-dhcp-server restart

fi

exit 0

