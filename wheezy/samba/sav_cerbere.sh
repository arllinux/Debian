#!/bin/bash

# save_cerbere
# --\\\\\--
# Ce script sauvegarde et éteint le contenu du poste de travail sur lequel on se trouve

Date=$(date +%d-%m-%Y)
Heure=$(date +%T)
SOURCEDIR='/home/jpantinoux/'
DESTDIR='/srv/samba/public/save_doc_jp_dell/'
SERVEUR='root@192.168.2.1'

# Chemin vers le fichier externe des répertoires à exclure de la syncronisation
CHEMIN='/home/jpantinoux/bin/exclus_sav_cerbere'

# --\\\\\--

# Le script présent dans la machine A vérifie si la machine B est connectée.
# Si c'est le cas exécute le script.

read -p "Voulez-vous éteindre la machine après la sauvegarde ? (o/n) :" down

	echo -e "----\nLancement sauvegarde à : $Heure le $Date"
	sleep 5
	ping -c 1 192.168.2.1 > /dev/null
	if [ $? = "0" ]
		then
		rsync -av --del --exclude-from=$CHEMIN -e "ssh -p 18525" $SOURCEDIR $SERVEUR:$DESTDIR 
		# Ce script dans le serveur se charge de faire un chown smbguest:user save_doc_jp
		#ssh -p 18525 $SERVEUR bash -c /root/bin/ch_smb_jp.sh
		Date=$(date +%d-%m-%Y)
		Heure=$(date +%T)
		echo -e "----\nFin de la sauvegarde à : $Heure le $Date"
		sleep 5
	else
		read -p "!!!!! La synchronisation n'a pu être effectuée, serveur absent : interruption à $Heure... Ctrl + c pour fermer la fenetre"


	exit 0
	fi

# Eteint le poste de travail si le paramètre down est o
if [ $down = "o" ] ; then sudo shutdown -h now ; fi

exit 0

# --\\\\\--
