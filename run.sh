#!/bin/bash

pkexec apt install -y git curl wget inkscape scratch docker.io  libfuse2 nodejs npm sssd-ad sssd-tools realmd adcli
SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (! test -e /usr/local/bin/cura) then
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o $SCRIPT/cura
	pkexec mv $SCRIPT/cura /usr/local/bin/
	pkexec chmod +x /usr/local/bin/cura
fi
ICON=$SCRIPT/Cura/resources/images/cura-icon.png
if (! test -e $SCRIPT/Cura.desktop) then
	if (! test -e $ICON) then
		git clone https://github.com/Ultimaker/Cura.git $SCRIPT/Cura/
	fi
	pkexec cp $SCRIPT/Cura/resources/images/cura-icon.png /usr/local/bin/cura-icon.png
	echo "[Desktop Entry]
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
	pkexec desktop-file-install $SCRIPT/Cura.desktop
fi
SCRATCHJR=$SCRIPT/ScratchJr-Desktop/
if (! test -e $SCRATCHJR) then
	git clone https://github.com/leonskb4/ScratchJr-Desktop $SCRATCHJR
	cd $SCRATCHJR
	npm install && npm run publish
fi
echo "AD Domain Administrator password is here needed, please enter the domain passowrd:"
sudo realm join -v bsch.bancroftschool.org
sudo pam-auth-update --enable mkhomedir
sudo mkdir /etc/skel/.config
echo "yes" >> /etc/skel/.config/gnome-initial-setup-done
sudo echo "ad_gpo_access_control = permissive" >> /etc/sssd/sssd.conf

sudo echo "nameserver 10.88.0.8
nameserver 127.0.0.53
options edns0 trust-ad
search .
" >  /etc/resolv.conf


