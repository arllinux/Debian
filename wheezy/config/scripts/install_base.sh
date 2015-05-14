#!/bin/bash

# Ce script permet, de finaliser l'installation d'un poste de travail
# d'installer les invites de commande personnalisée
# de paramétrer vim, et d'installer les outils de bases.

# Script :      script_install_invites.sh
# Pour lancer ce script il faut se placer dans le dossier qui le contient
# ./script_install_invites.sh


# Dernière modifs 4/02/2012 
# Nouvelles modifs le 29/04/2012 - 22/08/2012
# Intégration boucle de vérification du nom - 25/01/2013
# Installation du programme cowsay - 25/01/2013
# Ajout de la clé gpg pour dépot Mozilla - 25/01/2013

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

    # installe un petit utilitaire pour l'execution du script
    echo ":: Installation d'un utilitaire pour l'exécution du script d'installation ::"
    aptitude -y install cowsay
    sleep 3

    read -p 'Nom Utilisateur (login) à personnaliser : ' nom

        while [ -z $nom ]; do
                echo "Veuillez saisir votre nom"
                read nom
                done
        
        cat /etc/passwd | grep bash | awk -F ":" '{print $1}' | grep -w $nom > /dev/null
        if [ $? = "0" ]
        then

        # Configuration de Vim
        echo ":: Configuration de Vim. ::"
        cat $CWD/../vim/etc/vim/vimrc.local > /etc/vim/vimrc.local
        chmod 0644 /etc/vim/vimrc.local
        sleep 3

        # Installation invite perso
        echo ":: Installation invite de commande utilisateur ::"
        cat "$FILE_U" > "$RC_USER$nom$RC_USER0"
        chown $nom:$nom "$RC_USER$nom$RC_USER2"
        chmod 0644 "$RC_USER$nom$RC_USER2"
        sleep 3

        # Personnalisation invite pour les futurs utilisateurs
        echo ":: Personnalisation invite pour les futurs utilisateurs. ::"
        cat $CWD/../bash/$FILE_U > /etc/skel/.bash_aliases
        chown root:root /etc/skel/.bash_aliases
        chmod 0644 /etc/skel/.bash_aliases
        sleep 3

        # Installation invite root
        echo ":: Coloration invite de commande root. ::"
        cat $CWD/../bash/$FILE_R > "$RC_ROOT"
        chown root:root "$RC_ROOT"
        chmod 0644 "$RC_ROOT"
        sleep 3

        # Mise en place du bootsplash
        echo ":: Mise en place du bootsplash. ::"
        cp $CWD/../bootsplash/wwl.tga /boot/grub/
        sleep 3

        # Configurer grub
        echo ":: Configuration de /etc/default/grub. ::"
        cp /etc/default/grub /etc/default/grub_old
        cat $CWD/../grub/etc/default/grub_800x600 > /etc/default/grub
        update-grub
        sleep 3

        # Configurer APT
        echo ":: Configuration de base de APT. ::"
        cat $CWD/../repositories/etc/apt/sources.list > /etc/apt/sources.list
        chmod 0644 /etc/apt/sources.list
        sleep 3

        # Installer la clé du dépot Mozilla
        aptitude -y install pkg-mozilla-archive-keyring
        gpg --check-sigs --fingerprint --keyring /etc/apt/trusted.gpg.d/pkg-mozilla-archive-keyring.gpg --keyring /usr/share/keyrings/debian-keyring.gpg pkg-mozilla-maintainers
        aptitude update
        aptitude -y upgrade
        sleep 3

        # Installation de quelques outils en ligne de commande
        echo ":: Installation outils de base. ::"
        TOOLS=$(egrep -v '(^\#)|(^\s+$)' $CWD/../bases_install/paquets-base)
        aptitude -y install $TOOLS
        sleep 3

        # Désactiver l'IPV6
        echo ":: Désactivation de l'ipv6. ::"
        cp /etc/sysctl.conf /etc/sysctl.conf_old
        cat $CWD/../ipv4-6/etc/sysctl.conf > /etc/sysctl.conf
        sysctl -p
        sleep 3

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
        sleep 3

        # Désactiver la mise en veille X de l'écran (xset)
        #echo ":: Désactivation de la mise en veille de X ::"
        #cp $CWD/../xscreen/etc/init.d/xscreen /etc/init.d/xscreen
        #chmod 0700 /etc/init.d/xscreen
        #ln -s /etc/init.d/xscreen /etc/rc2.d/S99xscreen
        #/etc/rc2.d/S99xscreen

        # Désactiver pcspkr
        #echo ":: Désactivation du modules pcspkr (son). ::"
        #cp /etc/modprobe.d/blacklist.conf /etc/modprobe.d/blacklist.conf_old
        #cat $CWD/../blacklist/etc/modprobe.d/blacklist.conf > /etc/modprobe.d/blacklist.conf

        # Installer Alsa
        #read -p 'Installation Alsa pour poste de travail ? (O/n) : ' alsa
        #   if [ $alsa = "o" ]
        #   then
        #      echo ":: Installation d'Alsa (contrôle du son). ::"
        #      aptitude install alsa-utils
        #   fi

        echo ":: Réglages de base terminés ::"
     else
        echo "Cet utilisateur n'existe pas sur cette machine. Recommencez !" | /usr/games/cowsay
     fi
fi
                                                                                                                                                                                                   142,1         Bas

