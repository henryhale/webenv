#!/bin/bash

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

# Function to install Node.js using NVM (Node Version Manager)
function install_nodejs() {
    echo -e "\n[#] Install Node.js"
    # Check if running with sudo
    check_privileges
    # Install curl if not installed
    install_package "curl"
    # Check if NVM is installed
    if ! command_exists "nvm"; then
        echo "[+] Installing NVM..."
        # Install NVM
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        # Activate NVM (or restart the terminal)
        source ~/.bashrc
    fi
    echo "[+] Installing the latest Node.js version..."
    # Install the latest Node.js version
    nvm install node
    nvm use node
    # Check if Node.js installation was successful
    if ! command_exists "node"; then
        echo "[x] Node.js installation failed. Please check for errors and try again."
        exit 1
    fi
}

# Function to install Node.js package manager
function install_nodejs_package_manager() {
    echo -e "\n[#] Choose a Node.js package manager:"
    PS3="Enter the number corresponding to your choice: "
    package_managers=(npm yarn pnpm)
    select pkg_manager in "${package_managers[@]}";
    do
        case $pkg_manager in
            "npm" )
                npm -g npm@latest
                npm -v
                break
            ;;
            "yarn" )
                npm install -g yarn
                yarn -v
                break
            ;;
            "pnpm" )
                npm install -g pnpm
                pnpm -v
                pnpm setup
                break
            ;;
            * )
                echo "[x] Invalid option."
                echo " -  Taking npm as default Node.js package manager"
                pkg_manager="npm"
            ;;
        esac
    done
}

# Function to install web framework cli tool
function install_web_framework() {
    echo -e "\n[#] Choose a web development framework:"
    PS3="Enter the number corresponding to your choice: "
    frameworks=(Vite React Angular Vue)
    select framework in "${frameworks[@]}";
    do
        case $framework in
            "Vite" )
                echo "[+] Installing vite globally..."
                $pkg_manager install -g vite
                break
            ;;
            "React" )
                echo "[+] Installing create-react-app globally..."
                $pkg_manager install -g create-react-app
                break
            ;;
            "Angular" )
                echo "[+] Installing @angular/cli globally..."
                $pkg_manager install -g @angular/cli
                break
            ;;
            "Vue" )
                echo "[+] Installing @vue/cli globally..."
                $pkg_manager install -g @vue/cli
                break
            ;;
            * )
                echo "[x] Invalid option"
            ;;
        esac
    done

    # Check if the selected framework is installed successfully
    if [ "$framework" ]; then
        if ! command_exists "$framework"; then
            echo "[x] $framework installation failed. Please check for errors and try again."
            exit 1
        fi
    fi
}

# Start installation
echo -e "$intro_message"

echo "Node.js Development Environment Setup"

# Install IDE
install_ide

# Install Web browser
install_web_browser

# Install Git (Source Control)
install_git

# Install Node.js
install_nodejs

# Install Package manager
install_nodejs_package_manager

# Install a web dev framework cli (e.g. vite, create-react-app, ...)
install_web_framework

# Clean up
if [ "$1" != "--local" ]; then
    rm -rf common.bash
fi

echo "[-] Node.js development environment setup complete."
