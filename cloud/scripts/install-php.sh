#!/bin/bash
#
# install-php.sh
# 
# Jean-Pierre Antinoux - juillet 2017

CWD=$(pwd)

    # Installer les paquets supplémentaires
    PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/../php/list_php)
#    apt-get --assume-yes install $PAQUETS
    
exit 0
