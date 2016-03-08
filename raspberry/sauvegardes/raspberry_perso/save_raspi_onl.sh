#!/bin/bash

# save_raspi_onl.sh
# --\\\\\--

Date=$(date +%d-%m-%Y)
Heure=$(date +%T)
SOURCEDIR='/var/www/vhosts'
SERVEUR="jpantinoux@195.154.73.137"
DESTDIR="/home/jpantinoux/80.240.4.59/"

# --\\\\\--

# Vidage du fichier log_tmp
> /root/bin/log_tmp

# Le script présent dans la machine A vérifie si la machine B est connectée.
# Si c'est le cas exécute le script.
echo -e "#####################################################################" >> /root/bin/log_tmp
echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
echo -e "Lancement sauvegarde le : $Date à $Heure" >> /root/bin/log_tmp
echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
ping -c 1 195.154.73.137 >> /root/bin/log_tmp
        if [ $? = "0" ]
        then
                # Se connecte à la machine B pour pour faire la sauvegarde
                rsync -av --del --stats -e "ssh -p 18525" $SOURCEDIR/* $SERVEUR:$DESTDIR >> /root/bin/log_tmp
                # rsync -av --del --stats -e "ssh -p 18525" /var/www/vhosts/* jpantinoux@195.154.73.137:/home/jpantinoux/80.240.4.59/ >> /root/bin/log_tmp
                # Réinitialise la date
                Date=$(date +%d-%m-%Y)
                Heure=$(date +%T)
                echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
                echo -e "Fin de la sauvegarde le : $Date à $Heure" >> /root/bin/log_tmp
                echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
                echo -e "#####################################################################" >> /root/bin/log_tmp
        else
                echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
                echo -e "!!!!! La synchronisation n'a pu être effectuée, serveur absent : interruption à $Heure..." >> /root/bin/log_tmp
                echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
                echo -e "#####################################################################" >> /root/bin/log_tmp

                exit 1
        fi
        # Envoi mail confirmation de sauvegarde
        mail -s "Sauvegarde raspi_onl du $Date" jeanpierre.antinoux@free.fr < log_tmp
        # Transfert des données du fichier log_tmp vers la fin du fichier log_marge
        cat /root/bin/log_tmp >> /root/bin/log_raspi

exit 0
# --\\\\\--
