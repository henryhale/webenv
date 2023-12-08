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
        if ["$confirm" != "y"]; then
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

# Function to install Node.js using NVM (Node Version Manager)
function install_nodejs() {
    # Check if running with sudo
    check_privileges
    # Install curl if not installed
    install_package "curl"
    # Check if NVM is installed
    if ! command_exists "nvm"; then
        echo "[-] Installing NVM..."
        # Install NVM
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        # Activate NVM (or restart the terminal)
        source ~/.bashrc
    fi
    echo "[-] Installing the latest Node.js version..."
    # Install the latest Node.js version
    nvm install node
    nvm use node
    # Check if Node.js installation was successful
    if ! command_exists "node"; then
        echo "[x] Node.js installation failed. Please check for errors and try again."
        exit 1
    fi
}

# Start installation
echo -e "               _                     
 __      _____| |__   ___ _ ____   __
 \ \ /\ / / _ \ '_ \ / _ \ '_ \ \ / /
  \ V  V /  __/ |_) |  __/ | | \ V / 
   \_/\_/ \___|_.__/ \___|_| |_|\_/  
                                     "

echo "Node.js Development Environment Setup"

# Prompt user to select IDE
echo "[1] Choose an IDE:"
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

# Prompt user to select a web browser
echo -e "\n[2] Choose a web browser:"
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

# Check if Git is installed successfully
echo -e "\n[3] Install Git"
install_package "git"

# Install Node.js and npm
echo -e "\n[4] Install Node.js and npm"
install_nodejs

# Prompt user to select Node.js package manager
echo -e "\n[5] Choose a Node.js package manager:"
PS3="Enter the number corresponding to your choice: "
package_managers=(npm yarn pnpm)
select pkg_manager in "${package_managers[@]}";
do
    case $pkg_manager in
        "npm" )
            npm -g npm@latest
            break
        ;;
        "yarn" )
            npm install -g yarn
            break
        ;;
        "pnpm" )
            npm install -g pnpm && pnpm -v && pnpm setup
            break
        ;;
        * )
            echo "[x] Invalid option."
            echo " -  Taking npm as default Node.js package manager"
            pkg_manager="npm"
        ;;
    esac
done

# Install a web development framework (e.g. React)
echo -e "\n[6] Choose a web development framework:"
PS3="Enter the number corresponding to your choice: "
frameworks=(Vite React Angular Vue)
select framework in "${frameworks[@]}";
do
    case $framework in
        "Vite" )
            echo "[-] Installing vite globally..."
            $pkg_manager install -g vite
            break
        ;;
        "React" )
            echo "[-] Installing create-react-app globally..."
            $pkg_manager install -g create-react-app
            break
        ;;
        "Angular" )
            echo "[-] Installing @angular/cli globally..."
            $pkg_manager install -g @angular/cli
            break
        ;;
        "Vue" )
            echo "[-] Installing @vue/cli globally..."
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

echo "[-] Node.js development environment setup complete."