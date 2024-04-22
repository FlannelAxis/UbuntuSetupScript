#!/bin/bash
SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SBA=SceneBuilder-21.0.0.deb

if (! test -e $SBA) then
	wget https://github.com/BancroftSchoolOpenSource/UbuntuSetupScript/releases/download/0.0.0/$SBA
	sudo dpkg -i $SBA
else
	echo "$SBA installed "
fi

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
sudo add-apt-repository -y ppa:openshot.developers/ppa
sudo add-apt-repository -y ppa:sunderme/texstudio

sudo apt update
sudo apt  -y upgrade

GITHUBDESKTOPRELEASE=3.3.5-linux2
#https://github.com/shiftkey/desktop/releases/download/release-3.3.5-linux2/GitHubDesktop-linux-amd64-3.3.5-linux2.deb
GITHUBDESKTOP=GitHubDesktop-linux-amd64-$GITHUBDESKTOPRELEASE.deb
if (! test -e $GITHUBDESKTOP) then
	sudo apt purge -y bcmwl-kernel-source
	sudo apt install -y firmware-b43-installer
	wget https://github.com/shiftkey/desktop/releases/download/release-$GITHUBDESKTOPRELEASE/$GITHUBDESKTOP
	sudo dpkg -i $GITHUBDESKTOP
else
	echo "$GITHUBDESKTOP installed "
fi

sudo apt install -y git  texstudio python3-pip libncurses5 libpython2.7 mesa-utils openshot-qt python3-openshot ssh net-tools build-essential curl wget inkscape docker.io  libfuse2 nodejs npm sssd-ad sssd-tools realmd adcli krita obs-studio godot3 google-chrome-stable
sudo apt purge -y modemmanager scratch brltty
sudo pip install pyserial

 


sudo snap install blender --classic


sudo cp $SCRIPT/81-bancroft.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules 
sudo udevadm trigger



if (! test -e /usr/local/bin/cura) then
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o $SCRIPT/cura
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
	sudo wget https://downloads.arduino.cc/arduino-ide/arduino-ide_2.2.1_Linux_64bit.AppImage -O /usr/local/bin/arduino-2
	sudo chmod +x /usr/local/bin/arduino-2 
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
	npm install && npm run publish
	sudo dpkg -i $SCRATCHJR/out/make/scratchjr*.deb
 	cd $SCRIPT/
fi

wget https://github.com/CommonWealthRobotics/Installer-Linux-BowlerStudio/releases/latest/download/bowlerstudio -O $SCRIPT/bowlerstudio
sudo cp $SCRIPT/bowlerstudio /usr/local/bin/bowlerstudio
sudo chmod +x /usr/local/bin/bowlerstudio

wget https://github.com/CommonWealthRobotics/ESP32ArduinoEclipseInstaller/releases/latest/download/eclipse -O $SCRIPT/eclipse
sudo cp $SCRIPT/eclipse /usr/local/bin/eclipse
sudo chmod +x /usr/local/bin/eclipse
sudo cp $SCRIPT/icon.xpm /usr/local/bin/icon.xpm
sudo cp $SCRIPT/splash.png /usr/local/bin/splash.png

sudo sed -i 's/sudo/#sudo/g' /usr/local/bin/bowlerstudio
sudo sed -i 's/pkexec/#pkexec/g' /usr/local/bin/eclipse

ECLIPSE=$SCRIPT/Eclipse-BS.desktop
if (! test -e $ECLIPSE) then
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=Eclipse Bowlerstudio
	Comment=
	Exec=/usr/local/bin/eclipse
	Icon=/usr/local/bin/icon.xpm
	Path=
	Terminal=false
	StartupNotify=false" > $ECLIPSE
	sudo chmod +x $ECLIPSE
	gio set $ECLIPSE "metadata::trusted" yes
	sudo desktop-file-install $ECLIPSE
fi
DESKTOP_FILE=$SCRIPT/bowlerstudio.desktop
if (! test -e $DESKTOP_FILE) then
	echo "[Desktop Entry]
	Version=1.0
	Type=Application
	Name=BowlerStudio
	Comment=BowlerStudio Robotics IDE
	Exec=/usr/local/bin/bowlerstudio
	Icon=/usr/local/bin/splash.png
	Path=
	Terminal=false
	StartupNotify=false" > $DESKTOP_FILE
	sudo chmod +x $DESKTOP_FILE
	gio set $DESKTOP_FILE "metadata::trusted" yes
	sudo desktop-file-install $DESKTOP_FILE
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

cd /home/
for d in */ ; do
    TRIMMED=$(basename $d);
    echo "Checking $TRIMMED"
    TMP=$(id -u $TRIMMED)
    sudo mkdir -p /home/$TRIMMED/.arduinoIDE/plugins/
    sudo cp $SCRIPT/$EXCEPTION_ZIP /home/$TRIMMED/.arduinoIDE/plugins/
    if (! test -d /home/$TRIMMED/.config/cura/) then
    	    echo "Updating cura config for $TRIMMED"
	    sudo cp -r $SCRIPT/.config/cura/  /home/$TRIMMED/.config/
    fi
    sudo mkdir -p /home/$TRIMMED/Desktop/
    sudo rm -rf /home/$TRIMMED/.config/google-chrome/Singleton*
    sudo chown -R $TMP:$TMP /home/$TRIMMED/
    
done


sudo lpadmin -p MDC_LAB -E -v ipp://10.88.5.129/ipp/print -m everywhere 






