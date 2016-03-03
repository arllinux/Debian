#!/bin/bash

# save_raspi_onl.sh
# --\\\\\--

Date=$(date +%d-%m-%Y)
Heure=$(date +%T)
SOURCEDIR='/var/www/vhosts'
SERVEUR="jpantinoux@195.154.73.137"
DESTDIR="/home/jpantinoux/80.240.4.59/"

# --\\\\\--
 
# Le script présent dans la machine A vérifie si la machine B est connectée.
# Si c'est le cas exécute le script.
echo -e "#####################################################################" >> /root/bin/log_raspi
echo -e "---------------------------------------------------------------------" >> /root/bin/log_raspi
echo -e "Lancement sauvegarde à : $Heure le $Date" >> /root/bin/log_raspi
echo -e "---------------------------------------------------------------------" >> /root/bin/log_raspi
ping -c 1 195.154.73.137 >> /root/bin/log_raspi
	if [ $? = "0" ]
	then
       		# Se connecte à la machine B pour pour faire la sauvegarde
		rsync -av --del --stats -e "ssh -p 18525" $SOURCEDIR/* $SERVEUR:$DESTDIR >> /root/bin/log_raspi
        	# rsync -av --del --stats -e "ssh -p 18525" /var/www/vhosts/* jpantinoux@195.154.73.137:/home/jpantinoux/80.240.4.59/ >> /root/bin/log_raspi
		# Réinitialise la date
		Date=$(date +%d-%m-%Y)
		Heure=$(date +%T)
		echo -e "---------------------------------------------------------------------" >> /root/bin/log_raspi
		echo -e "Fin de la sauvegarde à : $Heure le $Date" >> /root/bin/log_raspi
		echo -e "---------------------------------------------------------------------" >> /root/bin/log_raspi
		echo -e "#####################################################################" >> /root/bin/log_raspi
	else
		echo -e "---------------------------------------------------------------------" >> /root/bin/log_raspi
		echo -e "!!!!! La synchronisation n'a pu être effectuée, serveur absent : interruption à $Heure..." >> /root/bin/log_raspi
		echo -e "---------------------------------------------------------------------" >> /root/bin/log_raspi
		echo -e "#####################################################################" >> /root/bin/log_raspi
	exit 1
	fi

exit 0

# --\\\\\--
