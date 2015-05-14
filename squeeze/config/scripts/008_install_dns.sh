#!/bin/bash

# ./008_install_dns.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 21/03/2013

CWD=$(pwd)


[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else

	# Installation et configuration du serveur dns
	# Tous les paramètre sont adaptés pour un réseau local 192.168.2.1

	aptitude -y install bind9 dnsutils
	echo ":: Installation des outils ::"	
	echo ":: Configuration de named.conf.options ::"
	cp /etc/bind/named.conf.options /etc/bind/named.conf.options_old
	cat $CWD../dns/etc/bind/named.conf.options > /etc/bind/named.conf.options
	chown root:bind /etc/bind/named.conf.options
	chmod 0644 /etc/bind/named.conf.options

	echo ":: Modification de resolv.conf ::"
	cp /etc/resolv.conf /etc/resolv.conf_old
	cat $CWD/..dns/etc/resolv.conf > /etc/resolv.conf
	chmod 0644 /etc/resolv.conf

	echo ":: Modification du serveur dhcp ::"
	cat $CWD/../dns/etc/dhcp/dhcpd.conf_dns > /etc/dhcp/dhcpd.conf
	service isc-dhcp-server restart

	echo ":: Création du fichier db.labo.arles ::"
	cp /etc/bind/db.local /etc/bind/db.labo.arles
	cat $CWD/../dns/etc/bind/db.labo.arles > /etc/bind/db.labo.arles
	chown root:bind /etc/bind/db.labo.arles
	chmod 0644 /etc/bind/db.labo.arles
	service bind9 restart

	echo ":: Vérification de la zone de recherche ::"
	named-checkzone labo.arles /etc/bind/db.labo.arles
	sleep 5
	
	echo ":: Création du fichier db.192.168.2 ::"
	cp /etc/bind/db.127 /etc/bind/db.192.168.2
        cat $CWD/../dns/etc/bind/db.192.168.2 > /etc/bind/db.192.168.2
	chown root:bind /etc/bind/db.192.168.2
        chmod 0644 /etc/bind/db.192.168.2
	service bind9 restart

	echo ":: Tester par : dig -x 127.0.0.1 ::"
	echo ":: Tester 2 fois : dig google.fr ::"

fi

exit 0

