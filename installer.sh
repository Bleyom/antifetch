#!/bin/bash

declare -r green="\e[0;32m\033[1m"
declare -r end="\033[0m\e[0m"
declare -r red="\e[0;31m\033[1m"
declare -r blue="\e[0;34m\033[1m"

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -ne "${red}[*] Pls run me as root\n"
    exit 1
fi

all() {
    echo -ne "${blue}Welcome to Antifetch Installer\n"
    echo -ne "${green}do you wish to continue (y/n)) ?\n"
    read i
    if [ $i != "y" ]; then
        exit
    fi

    echo -ne "${green}[*] Downloading fonts ...\n"
    echo -ne "${end}"
    spinner &
    mkdir /tmp/resources
    wget https://github.com/google/material-design-icons/raw/master/font/MaterialIcons-Regular.ttf -O /tmp/resources/nerd-font.ttf
    wget https://github.com/google/material-design-icons/raw/master/font/MaterialIcons-Regular.ttf -O /tmp/resources/material-icons.ttf
    kill "$!" >/dev/null
    mv /tmp/resources/{material-icons.ttf,nerd-font.ttf} /usr/share/fonts
    echo -ne "${green}[*] Moving fonts to the target directory ...\n"
    spinner &
    echo -ne "${end}"
    sleep 0.5
    fc-cache -f -v 2>/dev/null
    echo -ne "${green}[*] Reloaded font cache!\n"
    chmod +x antifetch
    mv antifetch /usr/bin
    echo -ne "${green}[*] Binary moved to PATH\n"
    kill "$!" >/dev/null
    echo -ne "${red}[*] Antifetch correctly installed!\n"
    echo -ne "${end}"
    /usr/bin/antifetch
}

all
