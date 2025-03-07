#!/bin/bash
SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
set -e
SBA=SceneBuilder-21.0.0.deb
APPINVENT=aisetup.deb
APPINVENTDesktop="AppInventorTerminal.desktop"
FreecadDesktop="Freecad.desktop"
#https://github.com/FreeCAD/FreeCAD-Bundle/releases/download/weekly-builds/
FREECAD=FreeCAD_1.0.0-conda-Linux-x86_64-py311.AppImage
if (! test -e ~/bin/ ) then
	mkdir ~/bin/
fi
if (! test -e $APPINVENT) then
	sudo apt -y install zlib1g:i386 lib32stdc++6 libstdc++6:i386 lib32z1
	sudo rm -rf /usr/google/appinventor/
	wget http://appinv.us/aisetup_linux_deb -O $APPINVENT
	sudo dpkg -i $APPINVENT
	sudo cp $SCRIPT/Android.png /usr/google/appinventor/Android.png
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=App Inventor Terminal
	Comment=
	Exec=/usr/google/appinventor/commands-for-Appinventor/aiStarter
	Icon=/usr/google/appinventor/Android.png
	Path=""
	Terminal=true
	StartupNotify=false" > $APPINVENTDesktop
  	sudo chmod +x $APPINVENTDesktop
	gio set $APPINVENTDesktop "metadata::trusted" yes
	sudo desktop-file-install $APPINVENTDesktop
else
	echo "$APPINVENT installed "
fi

if (! test -e $FreecadDesktop) then

	wget https://github.com/FreeCAD/FreeCAD-Bundle/releases/tag/1.0.0/$FREECAD -O freecad
	sudo cp freecad /usr/local/bin/
	sudo chmod +x /usr/local/bin/freecad
	sudo cp FreeCAD-logo.png /usr/local/bin/
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=FreeCAD 0.22.0
	Comment=
	Exec=/usr/local/bin/freecad
	Icon=/usr/local/bin/FreeCAD-logo.png
	Path=""
	Terminal=true
	StartupNotify=false" > $FreecadDesktop
  	sudo chmod +x $FreecadDesktop
	gio set $FreecadDesktop "metadata::trusted" yes
	sudo desktop-file-install $FreecadDesktop
else
	echo "$FreecadDesktop installed "
fi

if (! test -e $SBA) then
	wget https://github.com/BancroftSchoolOpenSource/UbuntuSetupScript/releases/download/0.0.0/$SBA
	sudo apt install libpcre3
	sudo dpkg -i $SBA
else
	echo "$SBA installed "
fi

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
sudo add-apt-repository -y ppa:openshot.developers/ppa
sudo add-apt-repository -y ppa:sunderme/texstudio
#sudo add-apt-repository -y ppa:sylvain-pineau/kazam
set +e
sudo apt update
sudo apt  -y upgrade
set -e
GITHUBDESKTOPRELEASE=3.3.5-linux2
#https://github.com/shiftkey/desktop/releases/download/release-3.3.5-linux2/GitHubDesktop-linux-amd64-3.3.5-linux2.deb
GITHUBDESKTOP=GitHubDesktop-linux-amd64-$GITHUBDESKTOPRELEASE.deb
if (! test -e $GITHUBDESKTOP) then
	wget https://github.com/shiftkey/desktop/releases/download/release-$GITHUBDESKTOPRELEASE/$GITHUBDESKTOP
	sudo dpkg -i $GITHUBDESKTOP
else
	echo "$GITHUBDESKTOP installed "
fi

sudo apt install -y git  texstudio python3-pip mesa-utils openshot-qt python3-openshot ssh net-tools build-essential curl wget inkscape docker.io  libfuse2 nodejs npm sssd-ad sssd-tools realmd adcli krita obs-studio godot3 google-chrome-stable kazam gnome-sound-recorder ffmpeg gedit f3d python3-serial
sudo apt purge -y modemmanager scratch brltty meshlab
#sudo pip install pyserial

sudo snap install blender --classic


sudo cp $SCRIPT/81-bancroft.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules 
sudo udevadm trigger



if (! test -e /usr/local/bin/cura) then
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.8.1/UltiMaker-Cura-5.8.1-linux-X64.AppImage  -o $SCRIPT/cura
	sudo mv $SCRIPT/cura /usr/local/bin/
	sudo chmod +x /usr/local/bin/cura
fi
ICON=$SCRIPT/Cura/resources/images/cura-icon.png
CURADESKTOP=$SCRIPT/Cura-5.4.desktop
ARDUINODESKTOP=$SCRIPT/Arduino-2.desktop
MESHLAB=$SCRIPT/MashLab.desktop
if (! test -e $CURADESKTOP) then
	if (! test -e $ICON) then
		git clone https://github.com/Ultimaker/Cura.git $SCRIPT/Cura/
	fi
	sudo cp $SCRIPT/Cura/resources/images/cura-icon.png /usr/local/bin/cura-icon.png
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Cura
	Comment=
	Exec=/usr/local/bin/cura
	Icon=/usr/local/bin/cura-icon.png
	Path=
	Terminal=false
	StartupNotify=false" > $CURADESKTOP
  	sudo chmod +x $CURADESKTOP
	gio set $CURADESKTOP "metadata::trusted" yes
	sudo desktop-file-install $CURADESKTOP
fi
if (! test -e $ARDUINODESKTOP) then
	sudo wget https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.4_Linux_64bit.AppImage -O /usr/local/bin/arduino-2
	sudo chmod +x /usr/local/bin/arduino-2
	sudo cp $SCRIPT/arduinoappimage /etc/apparmor.d/ 
	sudo systemctl reload apparmor.service
	sudo wget https://www.arduino.cc/wiki/370832ed4114dd35d498f2f449b4781e/arduino.svg -O /usr/local/bin/arduino.svg
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Arduino IDE 2
	Comment=
	Exec=/usr/local/bin/arduino-2
	Icon=/usr/local/bin/arduino.svg
	Path=
	Terminal=false
	StartupNotify=false" > $ARDUINODESKTOP
 	sudo chmod +x $ARDUINODESKTOP
	gio set $ARDUINODESKTOP "metadata::trusted" yes
	sudo desktop-file-install $ARDUINODESKTOP
fi

if (! test -e $MESHLAB) then
	sudo wget https://github.com/cnr-isti-vclab/meshlab/releases/download/MeshLab-2023.12/MeshLab2023.12-linux.AppImage -O /usr/local/bin/mashlab
	sudo chmod +x /usr/local/bin/mashlab 
	sudo cp $SCRIPT/meshlab.png /usr/local/bin/meshlab.png
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Mesh Lab
	Comment=
	Exec=/usr/local/bin/mashlab
	Icon=/usr/local/bin/meshlab.png
	Path=
	Terminal=false
	StartupNotify=false" > $MESHLAB
 	sudo chmod +x $MESHLAB
	gio set $MESHLAB "metadata::trusted" yes
	sudo desktop-file-install $MESHLAB
fi

SCRATCHJR=$SCRIPT/ScratchJr-Desktop/
if (! test -e $SCRATCHJR) then
	git clone https://github.com/leonskb4/ScratchJr-Desktop $SCRATCHJR
	cd $SCRATCHJR
	set +e
	npm install && npm run publish
	set -e
	sudo dpkg -i $SCRATCHJR/out/make/scratchjr*.deb
 	cd $SCRIPT/
fi



ECLIPSE=$SCRIPT/Eclipse-BS.desktop
if (! test -e $ECLIPSE) then
	mkdir ~/bin/eclipse/
	wget https://github.com/CommonWealthRobotics/ExternalEditorsBowlerStudio/releases/download/0.1.1/Eclipse-Groovy-Linux-x86_64.tar.gz -O ~/bin/Eclipse-Groovy-Linux-x86_64.tar.gz
	tar -xvzf ~/bin/Eclipse-Groovy-Linux-x86_64.tar.gz -C ~/bin/eclipse/
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Eclipse CommonWealthRobotics Build
	Comment=
	Exec=$HOME/bin/eclipse/eclipse
	Icon=$HOME/bin/eclipse/icon.xpm
	Path=
	Terminal=false
	StartupNotify=false" > $ECLIPSE
	sudo chmod +x $ECLIPSE
	gio set $ECLIPSE "metadata::trusted" yes
	sudo desktop-file-install $ECLIPSE
fi
#https://github.com/CommonWealthRobotics/HatRack/releases/latest/download/BowlerLauncher-Linux-x86_64.deb
BOWLERLAUNCHER=BowlerLauncher-Linux-x86_64.deb
if (! test -e $BOWLERLAUNCHER) then
	wget https://github.com/CommonWealthRobotics/HatRack/releases/latest/download/$BOWLERLAUNCHER
	sudo dpkg -i $BOWLERLAUNCHER
fi
CADOODLE=CaDoodle-Linux-x86_64.deb 
if (! test -e $CADOODLE) then
	wget https://github.com/CommonWealthRobotics/CaDoodle/releases/latest/download/$CADOODLE
	sudo dpkg -i $CADOODLE
fi

SCRATCH3=scratch-desktop_3.3.0_amd64.deb
if (! test -e $SCRATCH3) then
	wget https://github.com/redshaderobotics/scratch3.0-linux/releases/download/3.3.0/scratch-desktop_3.3.0_amd64.deb -O $SCRIPT/$SCRATCH3
	sudo dpkg -i $SCRATCH3
fi


## old cleanup section
EXCEPTION_ZIP=esp-exception-decoder-1.0.2.vsix 
# https://github.com/dankeboy36/esp-exception-decoder

sudo mkdir -p /etc/skel/Arduino/tools/
if (! test -e $EXCEPTION_ZIP) then

	wget https://github.com/dankeboy36/esp-exception-decoder/releases/download/1.0.2/$EXCEPTION_ZIP	 -O $SCRIPT/$EXCEPTION_ZIP	
	sudo mkdir -p /etc/skel/.arduinoIDE/plugins/
	sudo cp $SCRIPT/$EXCEPTION_ZIP	 /etc/skel/.arduinoIDE/plugins/
fi
sudo mkdir -p /tmp/arduino/sketches/
sudo mkdir -p /tmp/arduino/cores/
sudo chmod 777 -R /tmp/arduino/

sudo mkdir -p /etc/skel/.config
sudo cp -r $SCRIPT/.config/cura/ /etc/skel/.config/

sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub net.mkiol.SpeechNote

echo "Success! All Packaged Installed!"







