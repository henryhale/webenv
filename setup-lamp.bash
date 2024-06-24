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

# Function to install PHP and web server
function install_php_webserver() {
    echo -e "\n[#] Choose a PHP version:"
    local PS3="Enter the number corresponding to your choice: "
    local php_versions=("PHP 7.4" "PHP 8.1")
    local php_modules=(cli common mysql zip gd mbstring curl xml bcmath)
    select php_version in "${php_versions[@]}"; do
        case $php_version in
            "PHP 7.4" )
                install_package "php7.4"
                for pkg in ${php_modules[@]}; do install_package "php7.4-$pkg"; done
                break
            ;;
            "PHP 8.1" )
                install_package "php8.1"
                for pkg in ${php_modules[@]}; do install_package "php8.1-$pkg"; done
                break
            ;;
            * ) 
                echo "[x] Invalid option"
            ;;
            esac
    done
    echo -e "\n[#] Choose a web server:"
    PS3="Enter the number corresponding to your choice: "
    local webservers=(Nginx Apache Lighttpd)
    select webserver in "${webservers[@]}"; do
        case $webserver in
            "Nginx" )
                install_package "nginx"
                break
            ;;
            "Apache" )
                install_package "apache2"
                break
            ;;
            "Lighttpd" )
                install_package "lighttpd"
                break
            ;;
            * )
                echo "[x] Invalid option"
            ;;
        esac
    done
}

# Function to install Composer
function install_composer() {
    echo -e "\n[#] Composer"
    if ! command_exists "composer"; then
        echo "[+] Installing Composer..."
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    else
        echo "[-] Composer is already installed."
    fi
}

# Function to install MySQL or MariaDB
function install_database() {
    echo -e "\n[#] Choose a database server:"
    local PS3="Enter the number corresponding to your choice: "
    local databases=(MySQL MariaDB)
    select database in "${databases[@]}"; do
        case $database in
            "MySQL" )
                install_package "mysql-server"
                break
            ;;
            "MariaDB" )
                install_package "mariadb-server"
                break
            ;;
            * ) 
                echo "[x] Invalid option"
            ;;
        esac
    done
}

# Function to configure MySQL and prompt user for credentials
function configure_mysql() {
    echo -e "\n[#] Configuring MySQL..."
    read -p "Enter MySQL user account name (default: root): " mysql_user
    local mysql_user=${mysql_user:-root}
    read -sp "Enter MySQL user account password: " mysql_password
    echo

    # Run MySQL secure installation script with provided credentials
    sudo mysql_secure_installation <<EOF
Y
$mysql_password
$mysql_password
Y
Y
Y
Y
EOF
}

# Function to install phpMyAdmin
function install_phpmyadmin() {
    echo -e "\n[#] Install PhpMyAdmin"
    install_package "phpmyadmin"
}

# Start installation
echo -e "$intro_message"

echo "PHP Backend Development Environment Setup"

# Install IDE
install_ide

# Install Web browser
install_web_browser

# Install Git (Source Control)
install_git

# Install PHP and web server
install_php_webserver

# Install Composer
install_composer

# Install database server
install_database

# Configure MySQL and prompt user for credentials
configure_mysql

# Install phpMyAdmin
install_phpmyadmin

# Clean up
if [ "$1" != "--local" ]; then
    rm -rf common.bash
fi

echo -e "\n[-] PHP backend development environment setup complete."