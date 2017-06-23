#!/bin/bash

# touch_3456.sh (dans /root/bin/ du serveur DELL)
# script appelé par "save_vers_2600.sh" sur serveur HP

DEST1='/mnt/raid3456/sauvegardes_2015/Dossier_partagé_2015/'
DEST2='/mnt/raid3456/sauvegardes_2015/sauve_2015_1/'
DEST3='/mnt/raid3456/sauvegardes_2015/sauve_2015_2'
DEST4='/mnt/raid3456/sauvegardes_2015/compta_2015'

chown -R smbguest:users $DEST1
cd $DEST1
find -type d -exec chmod 770 {} \;
find -type f -exec chmod 660 {} \;

chown -R smbguest:users $DEST2
cd $DEST2
find -type d -exec chmod 770 {} \;
find -type f -exec chmod 660 {} \;

chown -R smbguest:users $DEST3
cd $DEST3
find -type d -exec chmod 770 {} \;
find -type f -exec chmod 660 {} \;

chown -R smbguest:users $DEST4
cd $DEST4
find -type d -exec chmod 770 {} \;
find -type f -exec chmod 660 {} \;

exit 0

