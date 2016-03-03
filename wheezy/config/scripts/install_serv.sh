#!/bin/bash

# ./install_serveur.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else

	 Configuration du fichier /etc/network/interfaces
        echo ":: Configuration des interfaces réseau ::"
	cp /etc/network/interfaces /etc/network/interfaces_old
	cat $CWD/../interfaces/etc/network/interfaces > /etc/network/interfaces
	chmod 0644 /etc/network/interfaces
	service networking stop
	service networking start

	# Installation du parefeu
        echo ":: Installation du parefeu ::"
	cp $CWD/../../parefeu/etc/default/firewall /etc/default/firewall
	chmod 0644 /etc/default/firewall

	mkdir /etc/firewall
	cp $CWD/../../parefeu/etc/firewall/firewall-start /etc/firewall/firewall-start
	chmod 0700 /etc/firewall/firewall-start
	cp $CWD/../../parefeu/etc/firewall/firewall-stop /etc/firewall/firewall-stop
	chmod 0700 /etc/firewall/firewall-stop

	cp $CWD/../../parefeu/etc/init.d/firewall /etc/init.d/firewall
	chmod 0755 /etc/init.d/firewall
	
	service firewall restart
	
	# Modification du port ssh et accès interdit à root
	cp /etc/ssh/sshd_conf /etc/ssh/sshd_conf.old
	cat $CWD ../ssh/etc/ssh/sshd_conf > /etc/ssh/sshd_conf
	chmod 0644 /etc/ssh/sshd_conf
	service ssh restart

	# Encapsuleur tcp
	echo ":: Configuration de l'encapsuleur tcp ::"
	cat $cwd/../tcp/etc/hosts.allow > /etc/hosts.allow
	chmod 0644 /etc/hosts.allow
	cat $cwd/../tcp/etc/hosts.deny > /etc/hosts.deny
	chmod 0644 /etc/hosts.deny

	# NTP
	aptitude -y install ntp ntpdate
	service ntp stop
	ntpdate fr.pool.ntp.org
	touch /var/log/ntp.log
	chown ntp:ntp /var/log/ntp.log
	cp /etc/ntp.conf /etc/ntp.conf_old
	read -p 'Configuration pour serveur ? (O/n) :' ntp
	if [ $ntp = "o" ]
		then
		cat $CWD/../ntp/etc/ntp.conf > /etc/ntp.conf
		else
		cat $CWD/../ntp/etc/ntp.conf_pdt > /etc/ntp.conf
	fi		
	service ntp start
	
	# apt-cacher
	#aptitude install apt-cacher
	#cat $CWD/../apt-cacher/etc/default/apt-cacher > /etc/default/apt-cacher
	#chmod 0644 /etc/default/apt-cacher

	#cat $CWD/../apt-cacher/etc/apt-cacher/apt-cacher.conf > /etc/apt-cacher/apt-cacher.conf
	#chmod 0644 /etc/apt-cacher/apt-cacher.conf

	#service apt-cacher start
	
	# dhcp
	aptitude install dhcp3-server
	cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server_old
	cat $CWD/../dhcp/etc/default/isc-dhcp-server > /etc/default/isc-dhcp-server
	chmod 0644 /etc/default/isc-dhcp-server
	
	cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf_old
	cat $CWD/../dhcp/etc/dhcp/dhcpd.conf > /etc/dhcp/dhcpd.conf
	chmod 0644 /etc/dhcp/dhcpd.conf
	#service isc-dhcp-server restart

	# dns
	aptitude install bind9 dnsutils
	cp /etc/bind/named.conf.options /etc/bind/named.conf.options_old
	cat $CWD../dns/etc/bind/named.conf.options > /etc/bind/named.conf.options
	chmod 0644 /etc/bind/named.conf.options

	cp /etc/resolv.conf /etc/resolv.conf_old
	cat $CWD/..dns/etc/resolv.conf > /etc/resolv.conf
	chmod 0644 /etc/resolv.conf

	cat $CWD/../dns/etc/dhcp/dhcpd.conf_dns > /etc/dhcp/dhcpd.conf
	service isc-dhcp-server restart

	cp /etc/bind/db.local /etc/bind/db.labo.arles
	cat $CWD/../dns/etc/bind/db.labo.arles > /etc/bind/db.labo.arles
	chmod 0644 /etc/bind/db.labo.arles
	service bind9 restart

	named-checkzone labo.arles /etc/bind/db.labo.arles
	sleep 5

	cp /etc/bind/db.127 /etc/bind/db.192.168.1
        cat $CWD/../dns/etc/bind/db.192.168.1 > /etc/bind/db.192.168.1
        chmod 0644 /etc/bind/db.192.168.1
	service bind9 restart

	# Squid
	aptitude install squid
	cp /etc/squid/squid.conf /etc/squid/squid.conf_old
	cat $CWD/../squid/etc/squid/squid.conf > /etc/squid/squid.conf
	chmod 0644 /etc/squid/squid.conf
	service squid start
	sysv-rc-conf squid on
	
	# SquidGuard
	read -p 'Installer SquidGard ? (O/n) :' sg
        if [ $sg = "o" ]
                then
		aptitude install squidguard
	        mv /etc/squid/squidGuard.conf /etc/squid/squidGuard.conf_old
       		 cat $CWD/../squidguard/etc/squid/squidGuard.conf > /etc/squid/squidGuard.conf
        	chmod 0644 /etc/squid/squidGuard.conf

        	cat $CWD/../squidguard/etc/squid/squid.conf > /etc/squid/squid.conf
        	cd /var/lib/squidguard/db
        	wget -c ftp://ftp.univ-tlse1.fr/blacklist/blacklists.tar.gz
        	tar xvzf blacklists.tar.gz
        	chown -R proxy:proxy blacklists/
        	cat $SWD/../squidguard/usr/local/sbin/blacklist.sh > /usr/local/sbin/blacklist.sh
        fi
fi
