#!/bin/bash

pkexec apt install -y git curl wget inkscape scratch docker.io  libfuse2

if (! test -e /usr/local/bin/cura)
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o cura
	pkexec mv cura /usr/local/bin/
	pkexec chmod +x /usr/local/bin/cura
fi

if (! test -e Cura.desktop) then
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Cura
	Comment=
	Exec=/usr/local/bin/cura
	Icon=$HOME/bin/eclipse-bs/eclipse/icon.xpm
	Path=
	Terminal=false
	StartupNotify=false" > Cura.desktop
	chmod +x ~/bin/Eclipse-BS.desktop
	gio set Cura.desktop "metadata::trusted" yes
	pkexec desktop-file-install Cura.desktop
fi
