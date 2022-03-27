#!/usr/bin/env bash

function confirmation_prompt() {
    read -p "$1 (y/n) " yn
    case $yn in 
        [yY] ) ;;
        [nN] ) echo exiting...;
            exit;;
        * ) echo invalid response;;
    esac
}

echo "--------------------------"
echo " Ubuntu post-installation"
echo "--------------------------"
confirmation_prompt "Do you want to run the script now?"

echo "➜ Getting after-effects script from Github"

# Original project can be found here: https://github.com/tprasadtp/ubuntu-post-install.git)
wget -q --show-progress https://github.com/tprasadtp/ubuntu-post-install/releases/latest/download/after-effects -O after-effects

echo "➜ Running after-effects (autopilot mode)"
sudo bash after-effects ubuntu_post_install.yml -A

echo "➜ Installing Nvidia drivers if compatible"
# More info here: https://www.linuxcapable.com/how-to-install-or-upgrade-nvidia-drivers-on-ubuntu-21-10-impish-indri/
sudo ubuntu-drivers autoinstall

echo "➜ Additional cleanup actions"
# Clean unused packet dependencies
sudo apt autoremove -y 
# Update font cache (required after installing MS fonts)
sudo fc-cache -f

echo "➜ Creating folder structure in home directory"
# Folder for projects (other than source code)
mkdir -pv $HOME/projects
# Folder for bash scripts
mkdir -pv $HOME/scripts
# Folder for source code repos
mkdir -pv $HOME/src

echo "➜ Configuring Gnome"
# All gedit related settings can be listed with: gsettings list-recursively | grep -i gedit
# Display line numbers in gedit
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
# Tab size is 4 spaces
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor insert-spaces true

echo "➜ Rebooting system"
confirmation_prompt "Do you want to reboot now?"
reboot

