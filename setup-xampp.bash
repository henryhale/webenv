#!/bin/env bash

# Use local common.bash script in development with `--local` argument
if [ "$1" == "--local" ]; then
    echo -e "************ DEV ************\n :- Running in development mode"
else 
    # Download the common variables and functions script from the GitHub repository
    curl -O https://raw.githubusercontent.com/henryhale/webenv/master/common.bash
fi

# Make the common functions script executable
chmod +x common.bash

# Source the common functions script
source common.bash

# Function to install XAMPP
function install_xampp() {
    # Check if running with sudo
    check_privileges
    # Prompt for PHP version
    php_versions=("PHP 7.4" "PHP 8.1" "PHP 8.2")
    version_number=""
    echo -e "\n[#] Choose a PHP version:"
    PS3="Enter the number corresponding to your choice: "
    select php_version in "${php_versions[@]}"; do
        case $php_version in
            "PHP 7.4" )
                version_number="7.4.33"
                break
            ;;
            "PHP 8.1" )
                version_number="8.1.25"
                break
            ;;
            "PHP 8.2" )
                version_number="8.2.12"
                break
            ;;
            * ) 
                echo "[x] Invalid option"
            ;;
        esac
    done
    # Install net-tools if not installed
    install_package "net-tools"
    # Install curl if not installed
    install_package "curl"
    # Download XAMPP installer
    file_path="/tmp/xampp-linux-x64-$version_number-installer.run"
    curl -L -o "$file_path" "https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/$version_number/xampp-linux-x64-$version_number-0-installer.run"
    if [ -e "$file_path" ]; then
        # Make the installer executable
        chmod +x "$file_path"
        # Run the executable (launches GUI window)
        echo "\n[#] Installing XAMPP..."
        sudo "$file_path"
        # Set up aliases
        alias xampp-cli=/opt/lampp/xampp
        alias xampp-gui=/opt/lampp/manager-linux-x64.run
        alias xampp-uninstall=/opt/lampp/uninstall
        # Create a desktop shortcut icon
        icon_path="/usr/share/applications"
        shortcut_path="$icon_path/xampp.desktop"
        if [ -e "$icon_path" ]; then
            check_privileges
            sudo echo "[Desktop Entry]" > "$shortcut_path"
            sudo echo "Version=1.0" >> "$shortcut_path"
            sudo echo "Type=Application" >> "$shortcut_path"
            sudo echo "Name=XAMPP Control Panel" >> "$shortcut_path"
            sudo echo "Exec=sudo /opt/lampp/manager-linux-x64.run" >> "$shortcut_path"
            sudo echo "Icon=/opt/lampp/htdocs/favicon.ico" >> "$shortcut_path"
            sudo echo "Terminal=false" >> "$shortcut_path"
            sudo echo "StartupNotify=false" >> "$shortcut_path"
        fi
    else
        echo "[x] Failed to download the XAMPP installer"
        exit 1
    fi
}

# Start installation
echo -e "$intro_message"

echo "PHP Backend Development Environment Setup"
echo "XAMPP includes: Apache - MySQL - MariaDB - PHP - Perl - phpMyAdmin - FTP server"
echo

# Install xampp
install_xampp

# Quick guide
echo -e "\n[2] Guide"
echo -e "    $ xampp-gui\n\t- open xampp gui window"
echo -e "    $ xampp-cli\n\t- use xampp via the command line"
echo -e "    $ xampp-uninstall\n\t- uninstall xampp via the command line"
echo -e "\n    Go to http://localhost/ - xampp welcome page"
echo -e "\n    Go to http://localhost/phpmyadmin - phpmyadmin homepage"
echo -e "\n    Go to http://localhost/security - access security settings page"

# Clean up
if [ "$1" != "--local" ]; then
    rm -rf common.bash
fi

echo "[-] PHP backend development environment setup complete."