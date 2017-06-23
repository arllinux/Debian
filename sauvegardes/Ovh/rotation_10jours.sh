#!/bin/bash
# 17/06/2017
# JP Antinoux

# rotation_10jours.sh
# Dans /root/bin du serveur Regards
# sauvegarde sur 10 jours ouvrables.

DEST='/home/jpantinoux/save_nextcloud'
D=jour
H=Hjour
n=10
x=11

# Rotations
# Si le répertoire "jour.10" est présent, il est supprimé
if [ -d $DEST/$D.$n ] ; then
	rm -rf $DEST/$D.$n ;
fi

# Tant que le numérateur du répertoire "jour" n'est pas égal à 1
# remonter une par une les vues des jours précédents :
# jour.8 devient jour.9 par ex.
while [ "$n" != "1" ]
do
	let "n = $n - 1"
	let "x = $x - 1"
	if [ -d $DEST/$D.$n ] ; then
		mv $DEST/$D.$n $DEST/$D.$x ;
	fi
done

# Faire une copie (-al = archives + liens durs) de horairejour.0 vers jour.1
if [ -d $DEST/$H.0 ] ; then
	cp -al $DEST/$H.0 $DEST/$D.1 ;
	touch $DEST/$H.0
fi

exit 0
