[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Ubuntu (Gnome) post-installation script

Basic Ubuntu post-installation shell script to setup my OS. Feel free to fork and tailor it according to your own needs. I put an emphasis on **(re-)usability** and **simplicity**: No fancy libraries, unnecessary loops or colorful prompts... just plain linux commands that are easy to understand and to modify.

## Features

- 📂 Folder structure creation
- 📦 Supports snap, .deb and apt package installation
- 🗑️ Cleaning of unnecessary packages and files
- 📥 Cloning of git repositories
- 🔧 Custom actions

## Running the script

The first thing I do on a clean installation...

```sh
wget https://raw.githubusercontent.com/margrevm/ubuntu-post-install/main/ubuntu-post-install.sh
chmod +x ubuntu-postinstall.sh 
./ubuntu-postinstall.sh 
```

## Supported versions

- Ubuntu 24.04 (LTS) - **Current version**

## Credits

By Mike Margreve (mike.margreve@outlook.com) and licensed under MIT. The original source can be found here: https://github.com/margrevm/kubuntu-post-install
