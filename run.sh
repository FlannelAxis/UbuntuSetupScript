#!/bin/bash


wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt update
sudo apt purge -y bcmwl-kernel-source
sudo apt install -y firmware-b43-installer

sudo apt install -y git ssh net-tools build-essential curl wget inkscape scratch docker.io  libfuse2 nodejs npm sssd-ad sssd-tools realmd adcli krita obs-studio godot3 google-chrome-stable
sudo apt purge -y brltty
sudo apt purge -y modemmanager



SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if (! test -e /usr/local/bin/cura) then
	curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o $SCRIPT/cura
	sudo mv $SCRIPT/cura /usr/local/bin/
	sudo chmod +x /usr/local/bin/cura
fi
ICON=$SCRIPT/Cura/resources/images/cura-icon.png
CURADESKTOP=$SCRIPT/Cura-5.4.desktop
ARDUINODESKTOP=$SCRIPT/Arduino-2.desktop
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
	sudo wget https://downloads.arduino.cc/arduino-ide/nightly/arduino-ide_nightly-latest_Linux_64bit.AppImage -O /usr/local/bin/arduino-2
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

SCRATCHJR=$SCRIPT/ScratchJr-Desktop/
if (! test -e $SCRATCHJR) then
	git clone https://github.com/leonskb4/ScratchJr-Desktop $SCRATCHJR
	cd $SCRATCHJR
	npm install && npm run publish
	sudo dpkg -i $SCRATCHJR/out/make/scratchjr*.deb
fi

wget https://github.com/CommonWealthRobotics/Installer-Linux-BowlerStudio/releases/latest/download/bowlerstudio -O $SCRIPT/bowlerstudio
sudo cp $SCRIPT/bowlerstudio /usr/local/bin/bowlerstudio
sudo chmod +x /usr/local/bin/bowlerstudio

wget https://github.com/CommonWealthRobotics/ESP32ArduinoEclipseInstaller/releases/latest/download/eclipse -O $SCRIPT/eclipse
sudo cp $SCRIPT/eclipse /usr/local/bin/eclipse
sudo chmod +x /usr/local/bin/eclipse
sudo cp icon.xpm /usr/local/bin/
sudo cp splash.png /usr/local/bin/

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




sudo mkdir /etc/skel/.config


sudo touch /etc/skel/.config/gnome-initial-setup-done
sudo chmod -R 777 /etc/skel/.config/
sudo chmod -R 777 /etc/skel/.bashrc
if grep -q yes /etc/skel/.config/gnome-initial-setup-done; then
  echo "Initial setup detected for DO Not Disturb";
else
  echo "yes" >> /etc/skel/.config/gnome-initial-setup-done;
fi

if grep -q show-banners /etc/skel/.bashrc; then
	echo "Initial setup detected for .bashrc";
else
	echo "gsettings set org.gnome.desktop.notifications show-banners false" >> /etc/skel/.bashrc
fi
# Set the resolv.conf
sudo chmod 777   /run/systemd/resolve/stub-resolv.conf
sudo mkdir -p /etc/sssd/
sudo cp $SCRIPT/resolv.conf  /run/systemd/resolve/stub-resolv.conf
sudo chmod 755  /run/systemd/resolve/stub-resolv.conf
#Join AD
echo "AD Domain Administrator password is here needed, please enter the domain passowrd:"
sudo realm join -v bsch.bancroftschool.org
sudo pam-auth-update --enable mkhomedir

# Use our configurations
sudo chmod 777  /etc/sssd/sssd.conf
echo "Diff of /etc/sssd/sssd.conf and the intended file:"
sudo diff /etc/sssd/sssd.conf $SCRIPT/sssd.conf
sudo cp $SCRIPT/sssd.conf /etc/sssd/
sudo chmod 600  /etc/sssd/sssd.conf

echo "Diff of /run/systemd/resolve/stub-resolv.conf and the intended file:"
sudo diff /run/systemd/resolve/stub-resolv.conf $SCRIPT/resolv.conf

echo "Copying over SSH keys"
cat $SCRIPT/id_rsa.pub >> ~/.ssh/authorized_keys 
cat $SCRIPT/id_ecdsa.pub  >> ~/.ssh/authorized_keys 

#sudo mkdir -p /etc/skel/snap/firefox/common/
#sudo cp -r $SCRIPT/.mozilla/ /etc/skel/snap/firefox/common/
sudo rm -rf /etc/skel/snap/firefox/
cd /home/
for d in */ ; do
    echo "Checking $d"
done









