#!/bin/bash


gui()
{
    action=$(yad --width 500 --entry --title="Options"  \
    --image=system-search \
    --button="gtk-save:2" \
    --button="gtk-ok:0" --button="gtk-close:1" \
    --text "Veuillez choisir l'action:" \
    --entry-text \
    "Copier" "Archiver" "Compresser" "Restaurer" "help")

    ret=$?

[[ $ret -eq 1 ]] && exit 0

if [[ $ret -eq 2 ]]; then
    echo saved
    exit 0
fi

case $action in

    Archiver*)
  ;;
    Compresser*) 
 ;;
    Restaurer*) 

 ;;

Help*) final=$( echo 
      hwinfo --cpu \
  | yad --text-info  --width="800" --height="600" --title="Hwinfo --cpu " --text=fnHelp)fnHelp

;;
    *) exit 1 ;;  
esac
}

fnHelp(){
echo "BIENVENUE DANS NOTRE PROGRAMME"
echo -e "\n\n"
echo "la fonction tar"

echo "tar (tape archiver) est un outil très puissant pour la manipulation d'archives sous les systèmes Unix et les dérivés dont Linux. Il ne compresse pas les fichiers, mais les concatène au sein d'une seule et même archive. La majorité des programmes linux utilisent ce système d'archivage."
echo "tar -cvf nom_archive.tar nom_dossier/ "
echo "-c : creer un archive / -v : affichage des details des operations/ -f : assembler l'archive dans un fichier"
echo "tar -xvf fichier.tar "
echo -e "\n"
echo "-x pour faire l extraction"
echo -e "\n"
echo "Les formats de compression"
echo -e "\n"
echo "lzma ou xz :  un utilitaire de compression libre parmi les plus puissants: c'est la même méthode de compression que celle utilisée par 7zip.
Pour utiliser le format « .xz », installez le paquet xz-utils."
echo "Bzip2 ou Bz2"
echo "Gzip ou gz"
sleep 4
}

fnErreur(){
echo "Erreur de syntaxe : \n"
fnHelp 
}
fnCompressGzip(){
echo "Compression GZIP"
dat=`date +%y%m%d-%H%M`
nomFich="$USER-$dat"
tar -zcvf /backup/$nomFich.tar.gz /home/$USER
echo "Archive Créée"
sleep 3
}

fnCompressBzip2(){
echo "Compression BZIP2"
dat=`date +%y%m%d-%H%M`
nomFich="$USER-$dat"
tar -jcvf /backup/$nomFich.tar.bz2 /home/$USER
echo "Archive Créée"
sleep 3
}

fnCompressXz(){
echo "Compression XZ"
dat=`date +%y%m%d-%H%M`
nomFich="$USER-$dat"
tar -Jcvf /backup/$nomFich.tar.xz /home/$USER
echo "Archive Créée"
sleep 3
}

fnClean(){
free=`df --output=avail -k -h "$PWD" | sed '1d;s/[^0-9]//g'`
if [ $free -lt 100 ]; then
i=1
for fich in `ls /backup` ; do
tiret=`expr index "$fich" '-'`
tiret=$(($tiret-1))
nom=${fich:0:$tiret}       
  if [ $nom = $USER ];then
	tab[$i]=$fich
	i=$(($i+1))
  fi
done
#echo "i= $i"
	i=$(($i-1))
nom=${tab[1]}
 tiret=`expr index "$nom" '-'`
nom=${nom:$tiret}  
tiret=`expr index "$nom" '-'`
tiret=$(($tiret-1))
datMax=${nom:0:$tiret}  
 tiret=`expr index "$nom" '-'`
nom=${nom:$tiret}  
tiret=`expr index "$nom" '.'`
tiret=$(($tiret-1))
timMax=${nom:0:$tiret}
for j in `seq 2 $i`;
do
 nom=${tab[$j]}
 tiret=`expr index "$nom" '-'`
nom=${nom:$tiret}  
tiret=`expr index "$nom" '-'`
tiret=$(($tiret-1))
dat=${nom:0:$tiret}  
 tiret=`expr index "$nom" '-'`
nom=${nom:$tiret}  
tiret=`expr index "$nom" '.'`
tiret=$(($tiret-1))
tim=${nom:0:$tiret}  
if [ $dat > $datMax ] || [ $dat == $datMax ] && [ $tim > $timMax ]; then
    datMax=$dat
    timMax=$tim
    jMax=$j
fi                
#echo $dat $tim 
done
#echo Max $datMax $timMax $jMax
for j in `seq 1 $i`;
do
 if [ $j != $jMax ]; then
  rm /backup/${tab[$j]}
 fi
done
 echo "Nettoyage réalisé"
else
 echo "Pas besoin de nettoyer"
fi
sleep 5
}

fnRestore(){
i=1
for fich in `ls /backup` ; do
tiret=`expr index "$fich" '-'`
tiret=$(($tiret-1))
nom=${fich:0:$tiret}       
  if [ $nom = $USER ];then
	tab[$i]=$fich
	i=$(($i+1))
  fi
done
#echo "i= $i"
	i=$(($i-1))

for j in `seq 1 $i`;
do
 echo $j - ${tab[$j]}
done

echo " Choisir le numéro du fichier à décompresser : "
read n
echo ${tab[$n]}
tar -xvf /backup/${tab[$n]} -C /
sleep 5
}

fnCompressMenu(){
echo "Compress Menu"
}

fnRestoreMenu(){
echo "Restore Menu"
}

fnCompressMenu(){
clear
echo "               *********************************************************************"
echo "               *                      C O M P R E S S I O N                        *"
echo "               *********************************************************************"
echo "               *                   1) Gzip                                         *"
echo "               *                                                                   *"
echo "               *                   2) Bzip2                                        *"
echo "               *                                                                   *"
echo "               *                   3) XZ                                           *"
echo "               *                                                                   *"
echo "               *********************************************************************"
echo "                            Donnez votre choix :"
  read option
  case $option in
	1) fnCompressGzip ;;
	2) fnCompressBzip2 ;;	
	3) fnCompressXz ;;
	*)  echo "Sorry option not found " 
	
  esac
}

fnMenu(){
clear
echo "               *********************************************************************"
echo "               *                            M   E   N   U                          *"
echo "               *********************************************************************"
echo "               *                   1) Comrpess home directory                      *"
echo "               *                                                                   *"
echo "               *                   2) Restore home directory                       *"
echo "               *                                                                   *"
echo "               *                   3) Clean compressed archives                    *"
echo "               *                                                                   *"
echo "               *                   4) Ask for help                                 *"
echo "               *                                                                   *"
echo "               *                   5) Exit script                                  *"
echo "               *                                                                   *"
echo "               *********************************************************************"
echo "                            Donnez votre choix :"
  read option
  case $option in
	1) fnCompressMenu ;;
	2) fnRestore ;;	
	3) fnClean ;;
	4) fnHelp ;; 
	5) echo " Thanks !!"
		exit ;; 


	*)  echo "Sorry option not found " 
	
  esac
}
