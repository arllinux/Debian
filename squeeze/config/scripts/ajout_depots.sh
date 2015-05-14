#!/bin/bash

# /usr/share/debian/squeeze/config/apt/ajout_depots

# Mise en place des dépots complémentaires :
	# debian multimédia
	# dépots rétroportés pour iceweaseal et icedove
	# dépots pour virtualBox

# Dernières modif 13/07/2012 - 22/08/2012

CWD=$(pwd)


echo ":: Mise en place des dépots supplémentaires ::"

# Création des fichiers backports, multimedia et virtualbox
for LIST in backports deb-multimedia virtualbox; do
   cat $CWD/../repositories/etc/apt/sources.list.d/sources.list.d/$LIST.list > /etc/apt/sources.list.d/$LIST.list
   chmod 0644 /etc/apt/sources.list.d/$LIST.list
done

# Suppression du dépot debian-multimedia si celui-ci existe
if [ -e /etc/apt/sources.list.d/debian-multimedia.list ];  then
   rm -f /etc/apt/sources.list.d/debian-multimedia.list
fi

# Télécharger et installer la clé multimédia
apt-get -q -y --force-yes install deb-multimedia-keyring

# Télécharger et installer la clé pour mozilla
apt-get -q -y --force-yes install pkg-mozilla-archive-keyring

# Télécharger et installer la clé publique d'Oracle
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | apt-key add -

# Préférences pour icedove et iceweasel
cat $CWD/../repositories/etc/apt/preferences > /etc/apt/preferences 
chown root:root /etc/apt/preferences
chmod 0644 /etc/apt/preferences

aptitude update
#aptitude -y -t squeeze-backports install iceweasel iceweasel-l10n-fr
#aptitude -y -t squeeza-backports install icedove icedove-l10n-fr

echo ":: Mise à jour terminée... ::"

