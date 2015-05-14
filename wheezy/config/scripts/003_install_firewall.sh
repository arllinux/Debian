#!/bin/bash

# ./003_install_firwall.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 20/03/2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else


	# Installation du parefeu
        echo ":: Installation du parefeu ::"
	cp $CWD/../firewall/etc/default/firewall /etc/default/firewall
	chmod 0644 /etc/default/firewall

	mkdir /etc/firewall
	cp $CWD/../firewall/etc/firewall/firewall-start /etc/firewall/firewall-start
	chmod 0700 /etc/firewall/firewall-start
	cp $CWD/../firewall/etc/firewall/firewall-stop /etc/firewall/firewall-stop
	chmod 0700 /etc/firewall/firewall-stop

	cp $CWD/../firewall/etc/init.d/firewall /etc/init.d/firewall
	chmod 0755 /etc/init.d/firewall
	
	# service firewall restart
	# Avant de lancer la commande ci-dessus adapter le fichier
	# /etc/default/firewall
	
fi

exit 0

