#!/bin/bash
# 17/07/2015

# save_vers_2600.sh (dans /root/bin du serveur HP serveur7centos)
# Lancement à 23 h 30
# crontab -l
# 30 23 * * 1-5 /root/bin/save_vers_dell_2600.sh
# --\\\\\--

# 1 - Ce script est lancé par la crond sur la machine A.
# |__  Il vérifie la présence de la machine B,
#
# 2 - puis se connecte par ssh et lance un script présent sur la machine B.
# |__  Ce script (rotation10_dell_3456.sh) permet d'archiver les vues les plus anciennes.
#      sur 10 jours ouvrables.

# 3 - Retour dans la machine A et lancement de rsync.
# 4 - Reconnection à la machine B pour lancer un script touch_3456.sh
# |__ pour horodater le répertoire qui vient d'être synchronisé.
#
# Les infos sur les opérations effectuées se trouvent dans le fichier
# "/root/bin/logs_sauvegardes/logfile_HP_DELL.txt" sur la machine A.
# --\\\\\--

Date=$(date +%d-%m-%Y)
Heure=$(date +%T)
SOURCEDIR='/srv/samba/partage2015/partages/*'
SOURCEDIR2='/srv/samba/partage2015/sauve_2015_1/*'
SOURCEDIR3='/srv/samba/partage2015/sauve_2015_2/*'
SOURCEDIR4='/srv/samba/partage2015/compta_2015/*'
SOURCEDIR5='/srv/samba/partage2015/confidentiel/*'
DESTDIR='/mnt/raid3456/sauvegardes_2015/Dossier_partagé_2015'
DESTDIR2='/mnt/raid3456/sauvegardes_2015/sauve_2015_1'
DESTDIR3='/mnt/raid3456/sauvegardes_2015/sauve_2015_2'
DESTDIR4='/mnt/raid3456/sauvegardes_2015/compta_2015'
DESTDIR5='/mnt/raid3456/sauvegardes_2015/courrier_2015'
SERVEUR="root@192.168.0.115"
logfile='/root/bin/logs_sauvegardes/logfile_HP_DELL.txt'
H='horairejour'
# --\\\\\--

# Le script présent dans la machine A vérifie si la machine B est connectée.

echo -e "----\nLancement sauvegarde à : $Heure le $Date" >> $logfile
  ping -c 1 192.168.0.115 > /dev/null
if [ $? = "0" ]
  then

  # Si c'est le cas exécute le script "rotation10_dell_3456.sh"
    ssh $SERVEUR bash -c "/root/bin/rotation10_dell_3456.sh"
    if [ $? = "0" ]
	then

	# Si le script précédent s'est bien déroulé,
	# vérifie si l'on se trouve sur la machine A (centos7serveur).
	  if [ $HOSTNAME = "centos7serveur" ]
	    then

		# Lance la syncro 
		rsync -av --delete $SOURCEDIR $SERVEUR:$DESTDIR/$H.0/ >> $logfile
		echo -e "Dossier partagé 2015 sauvegardé" >> $logfile
		rsync -av --delete $SOURCEDIR2 $SERVEUR:$DESTDIR2/$H.0/ >> $logfile 
		echo -e "Dossier sauve_2015_1 sauvegardé" >> $logfile
		rsync -av --delete $SOURCEDIR3 $SERVEUR:$DESTDIR3/$H.0/ >> $logfile
		echo -e "Dossier sauve_2015_2 sauvegardé" >> $logfile
		rsync -av --delete $SOURCEDIR4 $SERVEUR:$DESTDIR4/$H.0/ >> $logfile
		echo -e "Dossier compta_2015 sauvegardé" >> $logfile
		rsync -av --delete $SOURCEDIR5 $SERVEUR:$DESTDIR5/$H.0/ >> $logfile
		echo -e "Dossier confidentiel sauvegardé" >> $logfile

		# Se reconnecte à la machine B pour lancer
		# "touch_3456.sh"
		# qui va mettre à jour la date.
		# ssh $SERVEUR bash -c "/root/bin/touch_3456.sh"
		Date=$(date +%d-%m-%Y)
		Heure=$(date +%T)

		echo -e "Sauvegarde terminée à  : $Heure le $Date\n" >> $logfile
		echo -e "-------------------------------------------------------"
	      else
		echo -e "!!!!! La synchronisation n'a pu être effectuée : interruption à $HEURE" >> $logfile
		echo -e "-------------------------------------------------------"
	   fi
       else
	 echo -e "\n!!!!! Le dossier jour.0 est absent\nSauvegarde interrompue à $Heure le $Date" >> $logfile
	 echo -e "---------------------------------------------------------------"
     fi			
  else
    echo -e "\n!!!!! Serveur inaccessible : échoué à $Heure le $Date" >> $logfile
    echo -e "---------------------------------------------------------------"
fi
exit 0

# --\\\\\--
