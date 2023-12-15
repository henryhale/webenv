#!/bin/bash

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
        echo "[-] Installing $1 ..."
        sudo apt-get install -y "$1"
    else
        echo "[-] $1 is already installed."
    fi
}

# Function to install PHP and web server
function install_php_webserver() {
    echo "[1] Choose a PHP version:"
    PS3="Enter the number corresponding to your choice: "
    php_versions=("PHP 7.4" "PHP 8.1")
    php_modules=(cli common mysql zip gd mbstring curl xml bcmath)
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
    echo "[2] Choose a web server:"
    PS3="Enter the number corresponding to your choice: "
    webservers=(Nginx Apache Lighttpd)
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
    if ! command_exists "composer"; then
        echo "[-] Installing Composer..."
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    else
        echo "[-] Composer is already installed."
    fi
}

# Function to install MySQL or MariaDB
function install_database() {
    echo "[3] Choose a database server:"
    PS3="Enter the number corresponding to your choice: "
    databases=(MySQL MariaDB)
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
    echo "[-] Configuring MySQL..."
    read -p "Enter MySQL user account name (default: root): " mysql_user
    mysql_user=${mysql_user:-root}
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
    echo "[4] Install PhpMyAdmin"
    install_package "phpmyadmin"
}

# Start installation
echo -e "               _                     
 __      _____| |__   ___ _ ____   __
 \ \ /\ / / _ \ '_ \ / _ \ '_ \ \ / /
  \ V  V /  __/ |_) |  __/ | | \ V / 
   \_/\_/ \___|_.__/ \___|_| |_|\_/  
                                     "

echo "PHP Backend Development Environment Setup"

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

echo "[-] PHP backend development environment setup complete."