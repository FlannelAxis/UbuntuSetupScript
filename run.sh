#!/bin/bash

sudo apt install -y git curl wget inkscape scratch docker.io  libfuse2 nodejs npm sssd-ad sssd-tools realmd adcli
SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (! test -e /usr/local/bin/cura) then
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o $SCRIPT/cura
	sudo mv $SCRIPT/cura /usr/local/bin/
	sudo chmod +x /usr/local/bin/cura
fi
ICON=$SCRIPT/Cura/resources/images/cura-icon.png
if (! test -e $SCRIPT/Cura.desktop) then
	if (! test -e $ICON) then
		git clone https://github.com/Ultimaker/Cura.git $SCRIPT/Cura/
	fi
	sudo cp $SCRIPT/Cura/resources/images/cura-icon.png /usr/local/bin/cura-icon.png
	sudo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Cura
	Comment=
	Exec=/usr/local/bin/cura
	Icon=/usr/local/bin/cura-icon.png
	Path=
	Terminal=false
	StartupNotify=false" > $SCRIPT/Cura.desktop
	gio set $SCRIPT/Cura.desktop "metadata::trusted" yes
	echo desktop-file-install $SCRIPT/Cura.desktop
fi
SCRATCHJR=$SCRIPT/ScratchJr-Desktop/
if (! test -e $SCRATCHJR) then
	git clone https://github.com/leonskb4/ScratchJr-Desktop $SCRATCHJR
	cd $SCRATCHJR
	npm install && npm run publish
	sudo dpkg -i $SCRATCHJR/out/make/scratchjr*.deb
fi

wget https://github.com/CommonWealthRobotics/Installer-Linux-BowlerStudio/releases/latest/download/bowlerstudio -O $SCRIPT/bowlerstudio
sudo cp $SCRIPT/bowlerstudio /usr/local/bin/bowlerstudio
chmod +x /usr/local/bin/bowlerstudio

wget wget https://github.com/CommonWealthRobotics/ESP32ArduinoEclipseInstaller/releases/latest/download/eclipse -O $SCRIPT/eclipse
sudo cp $SCRIPT/bowlerstudio /usr/local/bin/eclipse
chmod +x /usr/local/bin/eclipse

echo "AD Domain Administrator password is here needed, please enter the domain passowrd:"
sudo realm join -v bsch.bancroftschool.org
sudo pam-auth-update --enable mkhomedir
sudo mkdir /etc/skel/.config


sudo touch /etc/skel/.config/gnome-initial-setup-done
sudo chmod -R 777 /etc/skel/.config/
sudo chmod -R 777 /etc/skel/.bashrc
if grep -q yes /etc/skel/.config/gnome-initial-setup-done; then
  echo "Initial setup detected";
else
  echo "yes" >> /etc/skel/.config/gnome-initial-setup-done;
fi

if grep -q show-banners /etc/skel/.bashrc; then
	echo "Initial setup detected";
else
	echo "gsettings set org.gnome.desktop.notifications show-banners false" >> /etc/skel/.bashrc
fi
sudo chmod 777  /etc/sssd/sssd.conf
sudo chmod 777  /etc/resolv.conf

if grep -q ad_gpo_access_control /etc/sssd/sssd.conf; then
	echo "Initial setup detected";
else
	sudo echo "ad_gpo_access_control = permissive" >> /etc/sssd/sssd.conf
fi
sudo echo "nameserver 10.88.0.8
nameserver 127.0.0.53
options edns0 trust-ad
search .
" >  /etc/resolv.conf

sudo chmod 600  /etc/sssd/sssd.conf


