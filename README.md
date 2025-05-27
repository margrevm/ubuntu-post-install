# Ubuntu post-installation script

Basic Ubuntu post-installation shell script to setup my OS. Feel free to fork and tailor it according to your own needs. I put an emphasis on **(re-)usability** and **simplicity**: No fancy libraries, unnecessary loops or colorful prompts... just plain linux commands that are easy to understand and to modify.

## Features

- 📂 Folder structure creation
- 📦 Supports snap, flatpak, .deb and apt package installation and upgrade
- 🗑️ Cleaning of unnecessary packages and files
- 📥 Cloning of git repositories
- 🔧 Custom actions

## Running the script

```sh
chmod +x update.sh
./ubuntu-postinstall.sh 
```

## Supported versions

- Ubuntu 24.04 (LTS)

## Credits

By Mike Margreve (mike.margreve@outlook.com) and licensed under MIT. The original source can be found here: https://github.com/margrevm/ubuntu-post-install
