#!/bin/bash

# ./004_install_encapsuleur.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 20/03/2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else
	# Encapsuleur tcp
	echo ":: Configuration de l'encapsuleur tcp ::"
	cat $CWD/../tcp/etc/hosts.allow > /etc/hosts.allow
	chmod 0644 /etc/hosts.allow
	cat $CWD/../tcp/etc/hosts.deny > /etc/hosts.deny
	chmod 0644 /etc/hosts.deny
	
	# Aller modifier les paramètres du fichier hosts.allow
fi

exit 0

