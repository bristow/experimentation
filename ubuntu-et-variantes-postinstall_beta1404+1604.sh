#!/bin/bash

# Variantes validés :
# Ubuntu 14.04/16.04, Xubuntu 14.04/16.04, Lubuntu 14.04/16.04, Ubuntu Mate 16.04, Linux Mint 17.3/18

#############################################
# Run using sudo, of course.
#############################################
if [ "$UID" -ne "0" ]
then
  echo "Il faut etre root pour executer ce script. ==> sudo "
  exit 
fi 

. /etc/lsb-release

# Vérification que le système est a jour
apt-get update ; apt-get -y dist-upgrade

################################
# Concerne toutes les variantes
################################

# Police d'écriture de Microsoft
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections | apt-get -y install ttf-mscorefonts-installer ;

# Oracle Java 8
#add-apt-repository -y ppa:webupd8team/java ; apt-get update ; echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt-get -y install oracle-java8-installer ;
# vérifier si ça marche sinon mettre fichier.list sur le github...

#########################################
# Paquet uniquement pour la 14.04 / 17.3
#########################################
if [ "$DISTRIB_RELEASE" = "14.04" ] || [ "$DISTRIB_RELEASE" = "17.3" ] ; then

wget --no-check-certificate https://raw.githubusercontent.com/dane-lyon/fichier-de-config/master/trusty-ppa-supplement.list ;
mv trusty-ppa-supplement.list /etc/apt/sources.list.d/ ;
apt-get update ; apt-get -y --force-yes upgrade ; 

# paquet
apt-get -y install idle-python3.4 gstreamer0.10-plugins-ugly celestia

# LibreOffice toujours en dernière version (PPA)
#add-apt-repository -y ppa:libreoffice/ppa ; apt-get update ; apt-get -y upgrade
#apt-get -y install libreoffice libreoffice-l10n-fr libreoffice-help-fr 


# Pour Google Earth : #(cette méthode ne fonctionne pas sur la 16.04)
apt-get -y install libfontconfig1:i386 libx11-6:i386 libxrender1:i386 libxext6:i386 libgl1-mesa-glx:i386 libglu1-mesa:i386 libglib2.0-0:i386 libsm6:i386
wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb ; dpkg -i google-earth-stable_current_i386.deb ; apt-get -fy install ; rm -f google-earth-stable_current_i386.deb 

fi

#########################################
# Paquet uniquement pour la 16.04 / 18
#########################################
if [ "$DISTRIB_RELEASE" = "16.04" ] || [ "$DISTRIB_RELEASE" = "18" ] ; then

wget --no-check-certificate https://raw.githubusercontent.com/dane-lyon/fichier-de-config/master/xenial-ppa-supplement.list ;
mv xenial-ppa-supplement.list /etc/apt/sources.list.d/ ;
apt-get update ; apt-get -y --force-yes upgrade ; 

# paquet
apt-get -y install idle-python3.5 x265 ;
# méthode d'installation alternative pour Google Earth ? pour Celestia ? 

fi

#=======================================================================================================#

# Installation quelque soit la variante et la version 

#[ Bureautique ]
apt-get -y --force-yes install libreoffice libreoffice-gtk libreoffice-l10n-fr 
apt-get -y install freeplane scribus gnote xournal cups-pdf

#[ Web ]
apt-get -y install firefox chromium-browser flashplugin-downloader pepperflashplugin-nonfree

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections | apt-get -y install oracle-java8-installer ;

#[ Video / Audio ]
apt-get -y install imagination openshot audacity vlc x264 ffmpeg2theora flac vorbis-tools lame oggvideotools mplayer ogmrip goobox
#x265 installé sur la 16.04 en +

#[ Graphisme / Photo ]
apt-get -y install blender sweethome3d gimp pinta inkscape gthumb mypaint hugin shutter

#[ Systeme ]
apt-get -y install gparted vim pyrenamer rar unrar htop diodon p7zip-full

#[ Mathematiques ]
apt-get -y install geogebra algobox carmetal scilab

#[ Sciences ]
apt-get -y install stellarium avogadro 
#celestia installé uniquement sur la 14.04, cf en haut

#[ Programmation ]
apt-get -y install scratch ghex geany imagemagick
# + idle-python installé en 2 versions différente suivant 14.04 ou 16.04 (cf en haut)

#[ Serveur ]
#apt-get -y install openssh-server #a décommenter si vous utilisez "Ansible"
#=======================================================================================================#


################################
# Concerne Ubuntu / Unity
################################
if [ "$(which unity)" = "/usr/bin/unity" ] ; then  # si Ubuntu/Unity alors :

#[ Paquet AddOns ]
apt-get -y install ubuntu-restricted-extras ubuntu-restricted-addons unity-tweak-tool
apt-get -y install nautilus-image-converter nautilus-script-audio-convert

fi

################################
# Concerne Xubuntu / XFCE
################################
if [ "$(which xfwm4)" = "/usr/bin/xfwm4" ] && [ "$DISTRIB_RELEASE" = "14.04" ] ; then # si Xubuntu/Xfce 14.04 alors :

#[ Paquet AddOns ]
apt-get -y install xubuntu-restricted-extras xubuntu-restricted-addons xfce4-goodies xfwm4-themes

# Customisation XFCE

#add-apt-repository -y ppa:docky-core/stable ; apt-get update ; apt-get -y install plank --force-yes
# PPA temporairement désactivé, méthode alternative : #uniquement pour 14.04
apt-get -y install plank --force-yes #sera installé via le dépot ppa ajout au début du script

wget --no-check-certificate https://dane.ac-lyon.fr/spip/IMG/tar/skel_xub1404.tar ; tar xvf skel_xub1404.tar -C /etc ; rm -rf skel_xub1404.tar
fi

if [ "$(which xfwm4)" = "/usr/bin/xfwm4" ] && [ "$DISTRIB_RELEASE" = "16.04" ] ; then # si Xubuntu/Xfce 16.04 alors :

#[ Paquet AddOns ]
apt-get -y install xubuntu-restricted-extras xubuntu-restricted-addons xfce4-goodies xfwm4-themes plank #pas besoin de ppa

# Vérifier si skel de la 14.04 est compatible avec 16.04 !!!  remis ici pour test :
wget --no-check-certificate https://dane.ac-lyon.fr/spip/IMG/tar/skel_xub1404.tar ; tar xvf skel_xub1404.tar -C /etc ; rm -rf skel_xub1404.tar
fi

################################
# Concerne Ubuntu Mate / Mate
################################
if [ "$(which caja)" = "/usr/bin/caja" ] && [ "$DISTRIB_RELEASE" = "16.04" ] ; then # si Ubuntu Mate 16.04 alors :

#paquet
apt-get -y install ubuntu-restricted-extras mate-desktop-enivonment-extras

# Customisation Mate
# Mettre 1 skel spécifique a Mate ?

fi

########################################################################
#nettoyage station 
########################################################################
apt-get -y autoremove --purge ; apt-get -y clean

########################################################################
#FIN
########################################################################
echo "Le script de postinstall a terminé son travail"
read -p "Voulez-vous redémarrer immédiatement ? [O/n] " rep_reboot
if [ "$rep_reboot" = "O" ] || [ "$rep_reboot" = "o" ] || [ "$rep_reboot" = "" ] ; then
  reboot
fi

