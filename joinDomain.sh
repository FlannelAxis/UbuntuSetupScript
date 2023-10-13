#!/bin/bash

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Set the resolv.conf
sudo chmod 777   /run/systemd/resolve/stub-resolv.conf
sudo cp $SCRIPT/resolv.conf  /run/systemd/resolve/stub-resolv.conf
sudo chmod 755  /run/systemd/resolve/stub-resolv.conf

#Join AD
#Set the sssd to default to begin
sudo cp /usr/lib/x86_64-linux-gnu/sssd/conf/sssd.conf /etc/sssd/
sudo chmod 600 /etc/sssd/sssd.conf 
sudo systemctl enable sssd
sudo systemctl start sssd
set -e
echo "AD Domain Administrator password is here needed, please enter the domain passowrd:"
sudo realm join -v bsch.bancroftschool.org
echo "sudo pam-auth-update --enable mkhomedir"
sudo pam-auth-update --enable mkhomedir

# Use our configurations
sudo chmod 777  /etc/sssd/sssd.conf
sudo cp $SCRIPT/sssd.conf /etc/sssd/
sudo chmod 600  /etc/sssd/sssd.conf
echo "sudo systemctl enable sssd"
# restart sssd to finish setup
sudo systemctl enable sssd
echo "sudo systemctl start sssd"
sudo systemctl start sssd
echo "sudo realm permit -a"
sudo realm permit -a
set +e

# Set the resolv.conf
sudo rm /etc/resolv.conf
sudo cp $SCRIPT/resolv.conf  /etc/resolv.conf
sudo chmod 755  /etc/resolv.conf

echo "Diff of /etc/sssd/sssd.conf and the intended file:"
sudo diff /etc/sssd/sssd.conf $SCRIPT/sssd.conf
echo "Diff of /run/systemd/resolve/stub-resolv.conf and the intended file:"
sudo diff  /etc/resolv.conf $SCRIPT/resolv.conf

echo "Copying over SSH keys"
cat $SCRIPT/id_rsa.pub > ~/.ssh/authorized_keys 
cat $SCRIPT/id_ecdsa.pub  >> ~/.ssh/authorized_keys 

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

exit 0
## old cleanup section
#sudo mkdir -p /etc/skel/snap/firefox/common/
#sudo cp -r $SCRIPT/.mozilla/ /etc/skel/snap/firefox/common/
sudo rm -rf /etc/skel/snap/firefox/
cd /home/
for d in */ ; do
    echo "Checking $d"
    sudo rm -rf /home/$d/snap/firefox/
done
