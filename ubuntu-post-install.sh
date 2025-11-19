#!/bin/bash

## Post-installation script for Ubuntu 24.04
##
## Copyright (C) 2025 Mike Margreve (mike.margreve@outlook.com)
## Permission to copy and modify is granted under the MIT license
##
## Usage: ubuntu-post-install [no arguments]

# ---------------------------------------------------
# Creating folder structure
# ---------------------------------------------------
echo "[Creating the folder structure]"

CREATE_DIRS=(
	$HOME/projects
	$HOME/scripts
	$HOME/src
)

mkdir -pv ${CREATE_DIRS[@]}

REMOVE_DIRS=(
	$HOME/Templates
	$HOME/Music
	$HOME/Videos
	$HOME/Public
)

rmdir -v ${REMOVE_DIRS[@]}

# ---------------------------------------------------
# Symbolic links
# ---------------------------------------------------
# Ubuntu SMB mounted folders
ln -si /run/user/$UID/gvfs/ $HOME/smb

# ---------------------------------------------------
# APT package installation
# ---------------------------------------------------
echo "[Installing apt packages]"

APT_INSTALL_PACKAGES=(
	tree
	fastfetch
	vlc
	htop
	gnome-tweaks
	gnome-shell-extension-manager
	python3
 	python3-pip
	nmap
	wget
	default-jdk
	default-jre
	heif-gdk-pixbuf
	git
	curl
	unzip
	xclip
	less
  	ubuntu-restricted-extras
   	gedit
	libreoffice
	preload
	simple-scan
	drawing
	snapshot
	stow
	colordiff
	vim
	net-tools
	wine
	wine32:i386
	lutris
	batcat
	flatpak
	xournal
	pdfarranger
	ttf-mscorefonts-installer
)

# Danger zone /!\ Please be careful and make sure to not purge/remove any essential packages
APT_PURGE_PACKAGES=(
	geary
	gnome-contacts
)

APT_REMOVE_PACKAGES=(
)

echo "➜ Adding apt repositories..."
sudo add-apt-repository  ppa:zhangsongcui3371/fastfetch 

echo "➜ Updating apt repositories..."
sudo apt update -yq

echo "➜ Installing packages..."
# Existing packages will not be installed by apt.
sudo apt install ${APT_INSTALL_PACKAGES[@]} -q

echo "➜ Purging/removing apt packages..."
# This will remove the package and the configuration files (/etc)
# Should be used for applications you will never need. If you are not sure use 'apt remove' 
# instead (uncomment below) which will leave the config files.
sudo apt purge ${APT_PURGE_PACKAGES[@]} -q
#sudo apt remove ${APT_REMOVE_PACKAGES[@]}

echo "➜ Removing unused apt package dependencies..."
# ... packages that are not longer needed
sudo apt autoremove -q

echo "➜ Upgrading apt packages to their latest version..."
# 'apt full-upgrade' is an enhanced version of the 'apt upgrade' command. 
# Apart from upgrading existing software packages, it installs and removes 
# some packages to satisfy some dependencies. The command includes a smart conflict 
# resolution feature that ensures that critical packages are upgraded first 
# at the expense of those considered of a lower priority.
sudo apt full-upgrade -q

echo "➜ Cleaning package cache..."
# 'apt autoclean' removes all stored archives in your cache for packages that can not 
# be downloaded anymore (thus packages that are no longer in the repo or that have a newer version in the repo).
# You can use 'apt clean' to remove all stored archives in your cache to safe even more disk space.
sudo apt autoclean -q
#sudo apt clean

# ---------------------------------------------------
# Flatpack packages installation
# ---------------------------------------------------
echo "[Installing flatpak packages]"

FLATPAK_INSTALL_PACKAGES=(
	com.stremio.Stremio
)

echo "➜ Add flatpak repositories..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "➜ Install flatpak packages..."
# By default flatpak packages will be installed system wide.
flatpak install --system ${FLATPAK_INSTALL_PACKAGES[@]}

echo "➜ Udate flatpak packages..."
flatpak update

# ---------------------------------------------------
# Snap packages installation
# ---------------------------------------------------
echo "[Installing snap packages]"
# Important: Install 'snapd' to support snap packages (available as apt package).
# Snap is not natively supported by Pop!_OS. The usage of flatpak is recommended.
SNAP_INSTALL_PACKAGES=(
  bw
  spotify
  joplin-desktop
  whatsapp-for-linux
  code
  bitwarden
  discord
)

SNAP_REMOVE_PACKAGES=(
)

echo "➜ Remove snap packages..."
snap remove ${SNAP_REMOVE_PACKAGES[@]}

echo "➜ Install snap packages..."
snap install ${SNAP_INSTALL_PACKAGES[@]}

echo "➜ Updating (refreshing) snap packages..."
snap refresh

# ---------------------------------------------------
# .deb packages installation (manual)
# ---------------------------------------------------
#echo "[Downloading and installing .deb packages manually]"

#echo "➜ Downloading .deb packages..."
#DL_DIR=$HOME/Downloads/packages
#mkdir -pv $DL_DIR
#wget -q --show-progress "<URL>" -P "$DL_DIR"

#echo "➜ Installing .deb packages..."
#sudo dpkg -i $DL_DIR/*.deb
#sudo apt install -f

# ---------------------------------------------------
# Other packages installation (full manual installation)
# ---------------------------------------------------
echo "[Other packages]"

echo "➜ Installing DaVinci Resolve..."
cd $HOME/scripts
git clone git@github.com:margrevm/davinci-resolve-studio-installer-ubuntu.git
chmod +x davinci-resolve-studio-installer-ubuntu/TK_resolve_installer.sh
./davinci-resolve-studio-installer-ubuntu/TK_resolve_installer.sh

echo "➜ Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

# ---------------------------------------------------
# Third-party drivers (Nvidia, ...)
# ---------------------------------------------------
echo "[Drivers]"

echo "➜ Updating drivers..."
sudo ubuntu-drivers install

# ---------------------------------------------------
# Custom actions
# ---------------------------------------------------
echo "[Custom actions]"

echo "➜ Updating font cache..."
# Update font cache (required after installing MS fonts)
sudo fc-cache -f

# ---------------------------------------------------
# Gnome settings
# ---------------------------------------------------
# This really depends on your preferences :-)
echo "[Applying Gnome settings]"

# Gnome windows:
# When you click an icon in the launcher, it opens the application. But, you cannot minimize it by clicking it again. This can be changed with the following command.
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
# Enable night light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
# Gedit settings:
# All gedit related settings can be listed with: gsettings list-recursively | grep -i gedit
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
# Set mutter (gnome window manager) to a higher value to avoid "programm not responding" issues with steam
# Default is 3000 (3 seconds), setting it to 15000 (15 seconds
gsettings set org.gnome.mutter check-alive-timeout 15000

# ---------------------------------------------------
# Create SSH key
#----------------------------------------------------
echo "[Create SSH key]"
ssh-keygen -t rsa -b 4096 -C "mike.margreve@outlook.com"
ssh-add ~/.ssh/id_rsa

# copy key to clipboard
xclip -sel clip < ~/.ssh/id_rsa.pub

# open github to configure key
echo "Now paste the new ssh key in your Github configuration..."
firefox https://github.com/settings/ssh/new

# ---------------------------------------------------
# Clone git repos
# ---------------------------------------------------
echo "[Cloning git repos]"

cd $HOME/scripts
git clone git@github.com:margrevm/ubuntu-post-install.git
git clone git@github.com:margrevm/ubuntu-update.git
git clone git@github.com:margrevm/ubuntu-cleanup.git

# ---------------------------------------------------
# Overwrite 'gnu stow'ed dotfiles from Git repo
# ---------------------------------------------------
cd $HOME/scripts
git clone git@github.com:margrevm/dotfiles.git

# stow dotfiles
stow -d "$HOME/scripts/dotfiles" -t "$HOME" . --adopt

#Revert dotfiles from git repo
cd dotfiles
git --reset hard


# ---------------------------------------------------
# Summary
# ---------------------------------------------------
neofetch
echo "[Installation completed!]"
cd $HOME
