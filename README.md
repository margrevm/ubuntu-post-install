# ubuntu-post-install

By Mike Margreve (mike.margreve@outlook.com) and licensed under MIT. The original source can be found here: https://github.com/margrevm/ubuntu-post-install.git

## Disclaimer

This project is heavily tailored to my personal needs but can serve as inspiration for your own script.

## Features

1) after-effects:
    - `apt update` and `apt upgrade`
    - Installing a series of apps (snap, apt,deb) from a variaty of repositories defined in the `.yml` file.
    - Purge unused apps (Please be careful with this and make sure to not purge any essential packages!)
2) Additional installation and cleaning steps:
    - NVidia graphic driver installation if compatible.
    - `apt autoremove` to remove any unused package dependencies.
3) Create a folder structure in home directory
4) Gnome configuration (settings for gedit and other gnome apps)
5) Rebooting the system (required if graphics driver was installed)

## Supported versions (branches)

- [Ubuntu 21.10](https://github.com/margrevm/ubuntu-post-install/tree/ubuntu-21.10) - **Current version**

## Contributions

- This project uses the [after-effects script](https://github.com/tprasadtp/ubuntu-post-install.git) from [tprasadtp](https://github.com/tprasadtp).