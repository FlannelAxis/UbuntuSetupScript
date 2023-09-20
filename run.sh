#!/bin/bash

sudo apt install -y git curl wget inkscape scratch docker.io  libfuse2

curl -L https://github.com/Ultimaker/Cura/releases/download/5.4.0/UltiMaker-Cura-5.4.0-linux-modern.AppImage -o cura
sudo mv cura /usr/local/bin/
sudo chmod +x /usr/local/bin/cura
