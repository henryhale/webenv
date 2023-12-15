#!/bin/bash

# Welcome message
intro_message="
               _                     
 __      _____| |__   ___ _ ____   __
 \ \ /\ / / _ \ '_ \ / _ \ '_ \ \ / /
  \ V  V /  __/ |_) |  __/ | | \ V / 
   \_/\_/ \___|_.__/ \___|_| |_|\_/  
                                     
        by @henryhale (github)       
                                     "

# Function to check if a command is available
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if running with sudo
function check_privileges() {
    if [ "$EUID" -ne 0 ]; then
        echo "[x] This command often requires sudo privileges."
        read -p "Do you want to continue without sudo? (y/n) " confirm
        if [ "$confirm" != "y" ]; then
            echo "[x] Please run the script with sudo."
            exit 1
        fi
    fi
}

# Function to install a package if it's not already installed
function install_package() {
    if ! command_exists "$1"; then
        # Check if running with sudo
        check_privileges
        # install package
        echo "[+] Installing $1 ..."
        sudo apt-get install -y "$1"
    else
        echo "[-] $1 is already installed."
    fi
}

# Function to install IDE
function install_ide() {
    echo -e "\n[#] Choose an IDE:"
    PS3="Enter the number corresponding to your choice: "
    options=("Vim" "Neovim" "VSCode" "Atom" "Sublime Text")
    select ide in "${options[@]}";
    do
        case $ide in
            "Vim" )
                install_package "vim"
                break
            ;;
            "Neovim" )
                install_package "neovim"
                break
            ;;
            "VSCode" )
                install_package "code"
                break
            ;;
            "Atom" )
                install_package "atom"
                break
            ;;
            "Sublime Text" )
                install_package "sublime-text"
                break
            ;;
            * )
                echo "[x] Invalid option"
            ;;
        esac
    done
}

# Function to install web browser
function install_web_browser() {
    echo -e "\n[#] Choose a web browser:"
    PS3="Enter the number corresponding to your choice: "
    browsers=(Chrome Firefox)
    select browser in "${browsers[@]}"; 
    do
        case $browser in
            "Chrome" )
                install_package "google-chrome-stable"
                break
            ;;
            "Firefox" )
                install_package "firefox"
                break
            ;;
            * )
                echo "[x] Invalid option"
            ;;
        esac
    done
}

# Function to install git
function install_git() {
    echo -e "\n[#] Source control"
    install_package "git"
}
