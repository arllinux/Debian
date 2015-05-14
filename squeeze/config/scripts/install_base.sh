#!/bin/bash

# Ce script permet, avec les deux fichiers contenus dans ce même dossier,
# d'installer les invites de commande personnalisée
# de paramétrer vim, et d'installer les outils de bases.

# Fichiers :	invite_user
#               invite_root
# Script :	script_install_invites.sh
# Pour lancer ce script il faut se placer dans le dossier qui le contient
# ./script_install_invites.sh


# Dernière modifs 4/02/2012 
# Nouvelles modifs le 29/04/2012 - 22/08/2012

FILE_U=invite_user
FILE_R=invite_root
RC_USER=/home/
RC_USER2=/.bashrc
RC_ROOT=/root/.bashrc
CWD=$(pwd)

[ $USER != "root" ]
if [ $? = "0" ]
    then
	echo "Pour exécuter ce script il faut être l'utilisateur root !"
else
   # read -p 'Nom Utilisateur (login) à personnaliser : ' nom
   # if [ $nom != "" ]
   # then

	# Configuration de Vim
        echo ":: Configuration de Vim. ::"
	cat $CWD/../vim/etc/vim/vimrc.local > /etc/vim/vimrc.local
	chmod 0644 /etc/vim/vimrc.local

	# Installation invite perso
	# cat "$FILE_U" > "$RC_USER$nom$RC_USER2"
	# chown $nom:$nom "$RC_USER$nom$RC_USER2"
	# chmod 0644 "$RC_USER$nom$RC_USER2"

	# Personnalisation invite pour les futurs utilisateurs
	echo ":: Personnalisation invite pour les futurs utilisateurs. ::"
	cat $CWD/../bash/$FILE_U > /etc/skel/.bash_aliases
	chown root:root /etc/skel/.bash_aliases
	chmod 0644 /etc/skel/.bash_aliases

	# Installation invite root
        echo ":: Coloration invite de commande root. ::"
	cat $CWD/../bash/$FILE_R > "$RC_ROOT"
	chown root:root "$RC_ROOT"
	chmod 0644 "$RC_ROOT"

	# Mise en place du bootsplash
	echo ":: Mise en place du bootsplash. ::"
	cp $CWD/../bootsplash/wwl.tga /boot/grub/
        
	# Configurer grub
        echo ":: Configuration de /etc/default/grub. ::"
	cp /etc/default/grub /etc/default/grub_old
	cat $CWD/../grub/etc/default/grub_800x600 > /etc/default/grub
 
        # Configurer APT
        echo ":: Configuration de base de APT. ::"
        cat $CWD/../repositories/etc/apt/sources.list > /etc/apt/sources.list
        chmod 0644 /etc/apt/sources.list
	update-grub
    
	# Installation de quelques outils en ligne de commande
        echo ":: Installation outils de base. ::"
        TOOLS=$(egrep -v '(^\#)|(^\s+$)' $CWD/../bases_install/paquets-base)
        aptitude -y install $TOOLS
        
        # Désactiver l'IPV6
        echo ":: Désactivation de l'ipv6. ::"
	cp /etc/sysctl.conf /etc/sysctl.conf_old
        cat $CWD/../ipv4-6/etc/sysctl.conf > /etc/sysctl.conf
        sysctl -p
        
        # Installation du fichier hosts pour poste de travail ou serveur
        read -p 'Installation fichier hosts pour un poste de travail ? (O/n) : ' ptrv
	     if [ $ptrv = "o" ]
             then
                cp /etc/hosts /etc/hosts_old
                cat $CWD/../hosts/etc/hosts > /etc/hosts
	     else
	        cp /etc/hosts /etc/hosts_old
	        cat $CWD/../hosts/etc/hosts_serveur > /etc/hosts
             fi

        # Désactiver pcspkr
        echo ":: Désactivation du modules pcspkr (son). ::"
        cp /etc/modprobe.d/blacklist.conf /etc/modprobe.d/blacklist.conf_old
        cat $CWD/../blacklist/etc/modprobe.d/blacklist.conf > /etc/modprobe.d/blacklist.conf

        # Installer Alsa
  	read -p 'Installation Alsa pour poste de travail ? (O/n) : ' alsa
	   if [ $alsa = "o" ]
	   then
              echo ":: Installation d'Alsa (contrôle du son). ::"
              aptitude install alsa-utils
	   fi
	echo ":: Réglages de base terminés ::"
    # else
       # echo "Le nom d'utilisateur est vide. Recommencez !"
    # fi
fi
