#!/bin/bash

pkexec apt install -y git curl wget inkscape scratch docker.io  libfuse2
SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (! test -e /usr/local/bin/cura) then
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o cura
	pkexec mv cura /usr/local/bin/
	pkexec chmod +x /usr/local/bin/cura
fi

if (! test -e $SCRIPT/Cura.desktop) then
	
	git clone https://github.com/Ultimaker/Cura.git $SCRIPT/Cura
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
