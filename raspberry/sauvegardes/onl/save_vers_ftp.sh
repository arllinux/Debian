#!/bin/bash

# save_vers_ftp.sh

# Déplace les données reçue du Raspberry pi du dossier personnel ver commun
# Mets à jour les autorisations des fichiers
# Envoie un mail du contenu de la sauvegarde
# --\\\\\--

Date=$(date +%d-%m-%Y)
Heure=$(date +%T)
SOURCEDIR='/home/jpantinoux/80.240.4.59/'
DESTDIR="/home/commun/arles-linux/site_internet/elements_site/80.240.4.59/"

# --\\\\\--
    # Vidage du fichier log_tmp
       > /root/bin/log_tmp
    # Horodate du début de sauvegarde
      echo -e "#####################################################################" >> /root/bin/log_tmp
      echo -e "Lancement sauvegarde le : $Date à $Heure" >> /root/bin/log_tmp
      echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
    # Effectue la sychro du dossier utilisateur vers le serveur ftp
       rsync -av --del --stats $SOURCEDIR $DESTDIR >> /root/bin/log_tmp
    # Réinitialise la date
       Date=$(date +%d-%m-%Y)
       Heure=$(date +%T)
       echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
       echo -e "Fin de la sauvegarde le : $Date à $Heure" >> /root/bin/log_tmp
       echo -e "---------------------------------------------------------------------" >> /root/bin/log_tmp
     # Mise à jour des autorisations pour pouvoir manipuler les fichiers dans le répertoire commun
        chown -R commun:commun $DESTDIR
       echo -e "Mise à jour des autorisations des fichiers dans le répertoire commun" >> /root/bin/log_tmp
       echo -e "#####################################################################" >> /root/bin/log_tmp
     # Envoi mail confirmation de sauvegarde
       mail -s "Sauvegarde onl_ftp du $Date" jeanpierre.antinoux@free.fr < log_tmp
     # Transfert des données du fichier log_tmp vers la fin du fichier log_marge
       cat /root/bin/log_tmp >> /root/bin/log_marge

exit 0

# --\\\\\--
