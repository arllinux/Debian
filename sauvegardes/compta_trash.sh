#!/bin/sh
#
# samba_trash.sh

FIND=$(which find)
RM=$(which rm)
WAYS="/srv/samba/partage2015/compta_2015/SQL/1 \
     /srv/samba/partage2015/compta_2015/SQL/2 \
     /srv/samba/partage2015/compta_2015/SQL/3 \
     /srv/samba/partage2015/compta_2015/SQL/4 \
     /srv/samba/partage2015/compta_2015/SQL/5 \
     /srv/samba/partage2015/compta_2015/SQL/6 \
     /srv/samba/partage2015/compta_2015/SQL/7"

     for WAY in $WAYS; do
        if [ -d $WAY ]; then
          $FIND $WAY -mtime +10 -exec $RM -rf {} \;
        fi
done

exit 0

