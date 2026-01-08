#!/bin/bash

## Post-installation script for Ubuntu 24.04
##
## Copyright (C) 2025 Mike Margreve (mike.margreve@outlook.com)
## Permission to copy and modify is granted under the MIT license
##
## Usage: ubuntu-post-install.sh <settings-file>
## The settings file (ubuntu-settings.rc) must be provided as the first argument
## It defines arrays like CREATE_DIRS, REMOVE_DIRS, APT_INSTALL_PACKAGES, etc.

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: $0 <settings-file>"
    exit 0
fi

SETTINGS_FILE="$1"

if [ -z "$SETTINGS_FILE" ]; then
    printf '\033[0;31mError\033[0m: settings file not provided.\n'
    echo "Usage: $0 <settings-file>"
    exit 1
fi

if [ ! -f "$SETTINGS_FILE" ]; then
    printf '\033[0;31mError\033[0m: settings file '\''%s'\'' not found.\n' "$SETTINGS_FILE"
    exit 1
fi

# Load configuration (arrays and variables) from provided settings file
source "$SETTINGS_FILE"

# ---------------------------------------------------
# Creating folder structure
# ---------------------------------------------------
printf '\033[1;32m[Creating the folder structure]\033[0m\n'

mkdir -pv "${CREATE_DIRS[@]}"
rmdir -v "${REMOVE_DIRS[@]}"

# ---------------------------------------------------
# APT package installation
# ---------------------------------------------------
printf '\033[1;32m[Installing apt packages]\033[0m\n'

printf '\033[0;32m➜ Adding apt repositories...\033[0m\n'

sudo add-apt-repository ppa:zhangsongcui3371/fastfetch # Adding fastfetch PPA repository

# Download Microsoft's GPG signing key, convert it to a keyring format,
# and store it in a system-wide trusted location
wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/packages.microsoft.gpg > /dev/null

# Add the Visual Studio Code APT repository
# - arch=amd64 restricts the repo to x86_64 systems
# - signed-by ensures APT only trusts packages signed with this key
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" \
| sudo tee /etc/apt/sources.list.d/vscode.list

# ---------------------------------------------------

printf '\033[0;32m➜ Updating apt repositories...\033[0m\n'
sudo apt update -yq

# ---------------------------------------------------

printf '\033[0;32m➜ Installing packages...\033[0m\n'
# Existing packages will not be installed by apt.
sudo apt install -yq ${APT_INSTALL_PACKAGES[@]}

# ---------------------------------------------------

printf '\033[0;32m➜ Purging/removing apt packages...\033[0m\n'
# This will remove the package and the configuration files (/etc)
# Should be used for applications you will never need. If you are not sure use 'apt remove' 
# instead (uncomment below) which will leave the config files.
sudo apt purge -yq ${APT_PURGE_PACKAGES[@]}
#sudo apt remove ${APT_REMOVE_PACKAGES[@]}

# ---------------------------------------------------

printf '\033[0;32m➜ Removing unused apt package dependencies...\033[0m\n'
# ... packages that are not longer needed
sudo apt autoremove -yq

# ---------------------------------------------------

printf '\033[0;32m➜ Upgrading apt packages to their latest version...\033[0m\n'
# 'apt full-upgrade' is an enhanced version of the 'apt upgrade' command. 
# Apart from upgrading existing software packages, it installs and removes 
# some packages to satisfy some dependencies. The command includes a smart conflict 
# resolution feature that ensures that critical packages are upgraded first 
# at the expense of those considered of a lower priority.
sudo apt full-upgrade -yq

# ---------------------------------------------------

printf '\033[0;32m➜ Cleaning package cache...\033[0m\n'
# 'apt autoclean' removes all stored archives in your cache for packages that can not 
# be downloaded anymore (thus packages that are no longer in the repo or that have a newer version in the repo).
# You can use 'apt clean' to remove all stored archives in your cache to safe even more disk space.
sudo apt autoclean -yq
#sudo apt clean

# ---------------------------------------------------
# Flatpak packages installation
# ---------------------------------------------------
printf '\033[1;32m[Installing flatpak packages]\033[0m\n'

printf '\033[0;32m➜ Add flatpak repositories...\033[0m\n'
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

printf '\033[0;32m➜ Install flatpak packages...\033[0m\n'
# By default flatpak packages will be installed system wide.
flatpak install --system -y ${FLATPAK_INSTALL_PACKAGES[@]}

printf '\033[0;32m➜ Update flatpak packages...\033[0m\n'
flatpak update

# ---------------------------------------------------
# Snap packages installation
# ---------------------------------------------------
printf '\033[1;32m[Installing snap packages]\033[0m\n'
# Important: Install 'snapd' to support snap packages (available as apt package).
# Snap is not natively supported by Pop!_OS. The usage of flatpak is recommended.

printf '\033[0;32m➜ Remove snap packages...\033[0m\n'
snap remove ${SNAP_REMOVE_PACKAGES[@]} || true

printf '\033[0;32m➜ Install snap packages...\033[0m\n'
snap install ${SNAP_INSTALL_PACKAGES[@]}

printf '\033[0;32m➜ Updating (refreshing) snap packages...\033[0m\n'
snap refresh

# ---------------------------------------------------
# .deb packages installation (manual)
# ---------------------------------------------------
#echo "[Downloading and installing .deb packages manually]"

#TODO: Add syno client here



#echo "➜ Downloading .deb packages..."
#DL_DIR=$HOME/Downloads/packages
#mkdir -pv $DL_DIR
#wget -q --show-progress "<URL>" -P "$DL_DIR"

#echo "➜ Installing .deb packages..."
#sudo dpkg -i $DL_DIR/*.deb
#sudo apt install -f

# ---------------------------------------------------
# Other packages / custom installers
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
printf '\033[1;32m[Drivers]\033[0m\n'

printf '\033[0;32m➜ Updating drivers...\033[0m\n'
sudo ubuntu-drivers install

# ---------------------------------------------------
# Custom actions
# ---------------------------------------------------
printf '\033[1;32m[Custom actions]\033[0m\n'

printf '\033[0;32m➜ Updating font cache...\033[0m\n'
sudo fc-cache -f

# ---------------------------------------------------
# Gnome settings
# ---------------------------------------------------
# This really depends on your preferences :-)
echo "[Applying Gnome settings]"

# Gnome windows:
# When you click an icon in the launcher, it opens the application. But, you cannot minimize it by clicking it again. This can be changed with the following command.
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
# Gedit settings:
# All gedit related settings can be listed with: gsettings list-recursively | grep -i gedit
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
# Set mutter (gnome window manager) to a higher value to avoid "programm not responding" issues with steam
# Default is 3000 (3 seconds), setting it to 30000 (30 seconds)
gsettings set org.gnome.mutter check-alive-timeout 30000

# ---------------------------------------------------
# Create SSH key
# ---------------------------------------------------
printf '\033[1;32m[Create SSH key]\033[0m\n'
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
# Alternative: git clone https://github.com/margrevm/ubuntu-post-install.git
git clone git@github.com:margrevm/ubuntu-update.git 
# Alternative: git clone https://github.com/margrevm/ubuntu-update.git
git clone git@github.com:margrevm/ubuntu-cleanup.git
# Alternative: git clone https://github.com/margrevm/ubuntu-cleanup.git

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
neofetch || true
printf '\033[1;32m[Installation completed!]\033[0m\n'
cd "$HOME" || exit 0
