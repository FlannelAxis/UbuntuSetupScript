# UbuntuSetupScript
This script will set up a fresh Ubuntu machine as a Bancroft lab computer

# How To Run

This script can be run on a fresh Ubuntu machine to set it up as a lab machine

This script must be run by a user with sudo permission and someone that has the AD Administrator password. 

Create a partition 5% larger than ram to setup hibernate feature.

```
sudo apt -y install git
git clone https://github.com/BancroftSchoolOpenSource/UbuntuSetupScript.git
cd UbuntuSetupScript
bash setup
```
