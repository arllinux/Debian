#!/bin/bash

# rotation10_dell_3456.sh
# Dans /root/bin du serveur DELL
# sauvegarde sur 10 jours dans des répertoires différenciés.

########## Dossier_partagé_2015 ###########

DEST=/mnt/raid3456/sauvegardes_2015/Dossier_partagé_2015
D=jour
H=horairejour
n=10
x=11

# Rotations disque 3456
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

########## sauve_2015_1 ###########

DEST=/mnt/raid3456/sauvegardes_2015/sauve_2015_1
D=jour
H=horairejour
n=10
x=11

# Rotations disque 3456
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

########## sauve_2015_2 ###########

DEST=/mnt/raid3456/sauvegardes_2015/sauve_2015_2
D=jour
H=horairejour
n=10
x=11

# Rotations disque 3456
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
########## Compta ###########

DEST=/mnt/raid3456/sauvegardes_2015/compta_2015
D=jour
H=horairejour
n=10
x=11

# Rotations disque 3456
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
