#!/bin/sh

# nicofo - http://nicofo.tuxfamily.org
# 12/12/08 : v1
# 12/01/09 : v1.1 : ajout commentaires et %
# 19/03/10 : v2 : simplification de la commande 'find'
#		  nouveau traitement des différences
# 12/06/10 : v2.1 : option -i ; traitement des dossiers
# 02/07/11 : v3 : tient compte de la date de modification également (option -t)
# 21/11/11 : v4 : n'affiche plus par défaut les fichiers contenus dans les dossiers différents (sauf option -a)
# 27/01/13 : v5 : affiche correctement les "\" dans les noms des fichiers
#		  ajout de 'LANG=C' avant sort (sinon 'DIR/a.txt - DIR.cc - .DIRD - DIR/z.txt' restent triés ainsi)
#		  ajout du '/' à la fin du nom des fichiers dans "find" (sinon 'DIR - DIR.cc - DIR/z.txt' restent triés ainsi)
#		  suppression des 'sort' à la fin (tout est trié une fois au début)
#		  suppression du caractère 'x' dans sort (plus besoin avec LANG=C)


# Compare 2 dossiers et affiche les différences
# par rapport aux NOMS et à la TAILLE des fichiers
# L'option '-i' => case-insensitive
# L'option '-t' => comparaison de la DATE de modification aussi
# L'option '-t' => affiche aussi les fichiers contenus dans les dossiers différents

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	echo "Usage : $(basename $0) [-i] [-t] [-a] [dossier1] [dossier2]"
	echo "   Compare les 2 dossiers et affiche les différences par rapport"
	echo "   aux noms et à la taille des fichiers."
	echo
	echo "   -i : case insensitive"
	echo "   -t : tient également compte de la date de modification des fichiers"
	echo "   -a : affiche aussi les fichiers contenus dans les dossiers différents"
	exit 0
fi

# traitement des options
DIFF_OPT=""
DATE=""
FIND_OPT_DATE=""
GREP_OPT_DATE=""
TEXT_DATE=""
SHOWALL=""
while [ -n "$1" ]; do
	case "$1" in
		-i)
			DIFF_OPT="-i"
			shift;;
		-t)
			DATE="1"
			FIND_OPT_DATE="\ty%T@"
			GREP_OPT_DATE="\ty[0-9]*"
			TEXT_DATE="ou date de modification "
			shift;;
		-a)
			SHOWALL="1"
			shift;;
		*)
			break;;
	esac
done

[ -z "$1" ] && read -p "Dossier 1 : " DIR1 || DIR1="$1"
[ ! -d "$DIR1" ] && echo "'$DIR1' n'est pas un dossier !" && exit 1
[ -z "$2" ] && read -p "Dossier 2 : " DIR2 || DIR2="$2"
[ ! -d "$DIR2" ] && echo "'$DIR2' n'est pas un dossier !" && exit 1

[ -n "$3" ] && echo "'$3' n'est pas une attendu ici !" && exit 1

file1="/tmp/compDossier1"
file2="/tmp/compDossier2"
diff1="/tmp/compDossier_diff1"
diff2="/tmp/compDossier_diff2"

#ajouter le cas échéant un "/" final aux noms de dossier
[ -z "$(echo "$DIR1"|grep "/$")" ] && DIR1="$DIR1/"
[ -z "$(echo "$DIR2"|grep "/$")" ] && DIR2="$DIR2/"

#lister les 2 dossiers
#rem : options find : 
#		%P = nom du fichier
#		/ -> ajout d'un '/' pour le 'sort', de sorte que "DIR - DIR.cc - DIR/z.txt" soient triés => "DIR.cc - DIR - DIR/z.txt" (dossier parent avec ses fichiers)
#		%s = taille du fichier (pour dossier, taille sans contenu : ! différent d'un file system à un autre)
#		%t = date de modification (! y compris partie décimale) ; %Tc = idem sans partie décimale
#		%T@ = idem sous le format 'nombre de secondes depuis 1/1/1970' ; ! y compris partie décimale
echo -en       "\n\033[1;34mPréparation : listage de \"$DIR1\" ...\033[0m"
find "$DIR1" -printf "%P/\t%s$FIND_OPT_DATE\n" | LANG=C sort >$file1
echo -en "\r\033[K\033[1;34mPréparation : listage de \"$DIR2\" ...\033[0m"
find "$DIR2" -printf "%P/\t%s$FIND_OPT_DATE\n" | LANG=C sort >$file2


#supprimer la partie décimale des secondes
if [ -n "$DATE" ]; then
	sed -i 's/\.[0-9]*$//' $file1
	sed -i 's/\.[0-9]*$//' $file2
fi

#supprimer la ligne qui est la taille du dossier DIR1/2
sed -i "/^\/\t[0-9]*$GREP_OPT_DATE$/d" $file1
sed -i "/^\/\t[0-9]*$GREP_OPT_DATE$/d" $file2


#chercher les différences
diff $DIFF_OPT $file1 $file2 > $diff1			#contient toutes les différences (les différences de taille/date en double)

#supprimer la taille/date des fichiers/dossiers et supprimer le "/" après le nom du fichiers
sed -i "s/\/\t[0-9]*$GREP_OPT_DATE$//" $file1
sed -i "s/\/\t[0-9]*$GREP_OPT_DATE$//" $file2
sed -i "s/\/\t[0-9]*$GREP_OPT_DATE$//" $diff1

diff $DIFF_OPT $file1 $file2 > $diff2			#contient uniquement les différences de fichiers en plus

#pour le bon affichage des "\" dans le nom des fichiers ("\" supprimé par "read" ci-dessous)
sed -i 's/\\/\\\\/g' $diff1
sed -i 's/\\/\\\\/g' $diff2

#comparer
echo -e "\r\033[K\033[1;34mFichiers différents par leur taille $TEXT_DATE:\033[0m"
grep '^[<>] ' $diff1  | sed "s/^[<>] //" | LANG=C sort | uniq -d $DIFF_OPT |	#ne garde que les lignes en double (sort nécessaire)
while read file ; do							#et n'affiche pas les dossiers
	[ ! -d "$DIR1$file" -o ! -d "$DIR2$file" ] && echo "$file"
done

echo -e "\n\033[1;34mCe que \"$DIR1\" contient en plus :\033[0m"
{ grep '^<' $diff2 | cut -d' ' -f1 --complement ; echo ; } |	#echo=rajouter une ligne vide
while read file ; do
	#si le fichier ne fait partie du dossier lastDir
	if [[ ! "$file" == "$lastDir/"* ]]; then	# [[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
		[ -z "$SHOWALL" ] && [ -n "$lastDir" ] && echo -e "\033[1m$lastDir_bs/\033[0m   \033[37m($((n)) éléments)\033[0m" && lastDir="" && n=0
		if [ -d "$DIR1$file" ]; then
			lastDir=$file
			lastDir_bs=$(echo "$lastDir"|sed 's/\\/\\\\/g')	#si lastDir est affiché via "echo -e ..." -> le '\' est interprêté ! -> utiliser lastDir_bs à la place
			[ -n "$SHOWALL" -a -n "$file" ] && echo -e "\033[1m$lastDir_bs/\033[0m"
		else
			echo $file
		fi
	else
		[ -n "$SHOWALL" ] && echo -e "\033[37m '- ${file#$lastDir_bs/}\033[0m" || n=$((n+1))
	fi
done

echo -e "\n\033[1;34mCe que \"$DIR2\" contient en plus :\033[0m"
{ grep '^>' $diff2 | cut -d' ' -f1 --complement ; echo ; } |
while read file ; do
	#si le fichier ne fait partie du dossier lastDir
	if [[ ! "$file" == "$lastDir/"* ]]; then	# [[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
		[ -z "$SHOWALL" ] && [ -n "$lastDir" ] && echo -e "\033[1m$lastDir_bs/\033[0m   \033[37m($((n)) éléments)\033[0m" && lastDir="" && n=0
		if [ -d "$DIR2$file" ]; then
			lastDir=$file
			lastDir_bs=$(echo "$lastDir"|sed 's/\\/\\\\/g')	#si lastDir est affiché via "echo -e ..." -> le '\' est interprêté ! -> utiliser lastDir_bs à la place
			[ -n "$SHOWALL" -a -n "$file" ] && echo -e "\033[1m$lastDir_bs/\033[0m"
		else
			echo $file
		fi
	else
		[ -n "$SHOWALL" ] && echo -e "\033[37m '- ${file#$lastDir_bs/}\033[0m" || n=$((n+1))
	fi
done

rm $file1 $file2 $diff1 $diff2