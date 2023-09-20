#!/bin/bash

pkexec apt install -y git curl wget inkscape scratch docker.io  libfuse2

if (! test -e /usr/local/bin/cura)
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o cura
	pkexec mv cura /usr/local/bin/
	pkexec chmod +x /usr/local/bin/cura
fi

if (! test -e Cura.desktop) then
	git clone https://github.com/Ultimaker/Cura.git
	pkexec cp Cura/resources/images/cura-icon.png /usr/local/bin/cura-icon.png
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Cura
	Comment=
	Exec=/usr/local/bin/cura
	Icon=/usr/local/bin/cura-icon.png
	Path=
	Terminal=false
	StartupNotify=false" > Cura.desktop
	chmod +x ~/bin/Eclipse-BS.desktop
	gio set Cura.desktop "metadata::trusted" yes
	pkexec desktop-file-install Cura.desktop
fi
