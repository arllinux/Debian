#!/bin/bash

# ./001_install_interfaces.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 20/03/2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
    else

	# Configuration du fichier /etc/network/interfaces
        echo ":: Configuration des interfaces réseau ::"
	cp /etc/network/interfaces /etc/network/interfaces_old
	cat $CWD/../interfaces/etc/network/interfaces_freebox > /etc/network/interfaces
	chmod 0644 /etc/network/interfaces
	
	service networking stop
	service networking start
	
	# Avant de lancer ce script ajuster le fichier /etc/udev/rules.d/70-persistant-net.rules
	# Une fois les fichiers en place, ajuster les adresses IP
	# Lancer ensuite les deux commandes stop et start ci-dessus
fi

exit 0
