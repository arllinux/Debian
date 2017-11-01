#!/bin/bash
#
# debian9manager.sh
# 
# Jean-Pierre Antinoux - novembre 2017

CWD=$(pwd)

# Vérification de la syntaxe de l'utilisateur principal
if [ $USER != "root" ]
    then
        echo "Pour exécuter ce script il faut être l'utilisateur root !"
    else
    # Vérification du nom d'utilisateur
    read -p 'Utilisateur (login) à personnaliser : ' nom
    while [ -z $nom ]; do
    echo "Veuillez saisir votre nom"
    read nom
    done
    cat /etc/passwd | grep bash | awk -F ":" '{print $1}' | grep -w $nom > /dev/null
        if [ $? = "0" ]
    then
    
    # Configuration des invites de commandes
    echo ":: Configuration invite de commande pour l'administrateur."
    cat $CWD/../bash/invite_root > /root/.bashrc
    
    echo ":: Configuration invite de commande pour les futurs utilisateurs."
    cat $CWD/../bash/invite_users > /etc/skel/.bashrc
    
    echo ":: Configuration invite de commande pour l'utilisateur courant."
    cat $CWD/../bash/invite_users > /home/$nom/.bashrc
    
    # Configuration de Vim
    echo ":: Configuration de Vim."
    cat $CWD/../vim/vimrc.local > /etc/vim/vimrc.local
    chmod 0644 /etc/vim/vimrc.local
    
    # Mettre en place le fichier qui permet la validation des messages
    echo ":: Validation messages dpkg ::"
    cat $CWD/../dpkg/local > /etc/apt/apt.conf.d/local
    
    # Recharger les informations et mettre à jour
    apt-get update
    apt-get -y dist-upgrade
    
echo ":: Réglages de base terminés - Redémarrage obligatoire ::"
    else
       echo "Ce nom d'utilisateur n'existe pas. Réessayez !"
    fi
fi

exit 0
