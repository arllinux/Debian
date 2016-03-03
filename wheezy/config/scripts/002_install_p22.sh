#!/bin/bash

# ./002_install_p22.sh

# Dernière modifs 20/08/2012 - 10/09/2012 - 25/09/2012 - 20/03/2013

CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else

	# Modification du port ssh
	echo ":: Modification du port ssh ::"
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
	cat $CWD/../ssh/etc/ssh/sshd_config > /etc/ssh/sshd_config
	chmod 0644 /etc/ssh/sshd_config
	
	# service ssh restart

fi
