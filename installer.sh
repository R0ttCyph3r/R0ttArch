#!/bin/bash

if [ "$(id -u)" = 0 ]; then
    echo "This script MUST NOT be run as root user."
    exit 1
fi

# Function to install required packages
install_packages() {
    echo -e "\033[1;34mInstalling required packages...\033[0m"
    sudo pacman -Syy \
        opencl-nvidia hashcat inetutils base-devel git nmap dirsearch feroxbuster feh lsd lxappearance john \
        docker docker-compose gobuster ffuf xorg-xsetroot rustup ruby unzip picom polybar plocate python2 \
        ntfs-3g nemo neovim firefox alacritty zsh zsh-autosuggestions zsh-history-substring-search \
        zsh-completions zsh-syntax-highlighting ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-terminus-nerd \
        ttf-inconsolata ttf-joypixels noto-fonts noto-fonts-emoji noto-fonts-extra awesome-terminal-fonts \
        papirus-icon-theme mariadb virt-manager virt-viewer qemu-full bridge-utils libguestfs dnsmasq vde2 \
        reflector pacman-contrib dunst rofi jq xclip imagemagick libwebp webp-pixbuf-loader xdo xdotool \
        xorg-xdpyinfo xorg-xkill xorg-xprop xorg-xrandr xorg-xwininfo xbindkeys xvkbd wireshark \
        python-gobject flameshot tcpdump openvpn ntp net-tools sqlmap dbeaver bind-tools hydra rlwrap openbsd-netcat \
        proxychains-ng python-requests tree sshpass sshuttle postgresql-old-upgrade postgresql exploitdb socat \
        --needed --noconfirm
    echo -e "\033[1;32mRequired packages installed.\033[0m"
}

# Function to check if yay is installed and install if not
install_yay() {
    if command -v yay &> /dev/null; then
        echo -e "\033[1;33myay is already installed. Skipping...\033[0m"
    else
        echo -e "\033[1;34mInstalling yay...\033[0m"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
        echo -e "\033[1;32myay installed.\033[0m"
    fi
}

# Function to install packages using yay
install_packages_with_yay() {
    local packages=(
        "evil-winrm"
        "python-impacket-git"
        "aur/netexec"
        "burpsuite"
        "bloodhound"
        "downgrade"
        "metasploit"
        "aur/python-pypykatz"
        "seclists"
        "rustscan"
        "havoc-c2-git"
        "wpscan-git"
    )

    echo -e "\033[1;34mInstalling packages using yay...\033[0m"
    for package in "${packages[@]}"; do
        if yay -Q "$package" &> /dev/null; then
            echo -e "\033[1;33m$package is already installed. Skipping...\033[0m"
        else
            echo -e "\033[1;34mInstalling $package...\033[0m"
            yay -S "$package" --answerclean None --answerdiff None --noconfirm
        fi
    done
    echo -e "\033[1;32mPackages installed successfully.\033[0m"
}

# Function to install Sliver
install_sliver() {
    if command -v sliver &> /dev/null; then
        echo -e "\033[1;33mSliver is already installed. Skipping...\033[0m"
    else
        echo -e "\033[1;34mInstalling Sliver...\033[0m"
        curl https://sliver.sh/install | sudo bash
        echo -e "\033[1;32mSliver installed successfully.\033[0m"
    fi
}

# Function to clone repository and copy files
rice() {
    echo -e "\033[1;34mCloning R0ttArch repository...\033[0m"
    git clone https://github.com/R0ttCyph3r/R0ttArch
    cd R0ttArch/config
    cp -r * ~/.config
    cd ..
    cp -r wallpapers ~/wallpapers
    cp .zshrc ~/.zshrc
    echo -e "\033[1;32mFiles copied successfully.\033[0m"
}

change_user_shell() {
    local USERNAME=$(logname)
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        echo -e "\033[1;34mChanging shell to /usr/bin/zsh for user $USERNAME...\033[0m"
        chsh -s /usr/bin/zsh $USERNAME
        echo -e "\033[1;32mShell changed to /usr/bin/zsh for user $USERNAME.\033[0m"
    else
        echo -e "\033[1;33mShell is already /usr/bin/zsh. Skipping...\033[0m"
    fi
}

post_install_setup() {
    # Overwrite /usr/bin/burpsuite
    local burpsuite_file="/usr/bin/burpsuite"
    local burpsuite_content='#!/bin/sh
exec /usr/lib/jvm/java-22-openjdk/bin/java --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.desktop/javax.swing=ALL-UNNAMED -jar /usr/share/burpsuite/burpsuite.jar $@'
    
    echo "$burpsuite_content" | sudo tee "$burpsuite_file" > /dev/null
    sudo chmod +x "$burpsuite_file"

    # Edit /etc/libvirt/libvirtd.conf
    sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
    sudo sed -i 's/#unix_sock_ro_perms = "0777"/unix_sock_ro_perms = "0770"/' /etc/libvirt/libvirtd.conf

    # Add user to libvirt group
    sudo gpasswd -a $USER libvirt

    # Enable services
    sudo systemctl enable sliver.service
    sudo systemctl enable libvirtd.service
    sudo systemctl enable postgresql.service
    sudo archlinux-java set java-11-openjdk

    echo -e "\033[1;32mPost-installation setup completed.\033[0m"
}

# Function to add localhost and hostname entries to /etc/hosts
add_entries_to_hosts() {
    # Get the current hostname
    local HOSTNAME=$(hostname)
    # Path to the hosts file
    local HOSTS_FILE="/etc/hosts"
    # Entries to add
    local LOCALHOST_ENTRY="127.0.0.1       localhost"
    local HOSTNAME_ENTRY="127.0.1.1       $HOSTNAME"
    
    # Function to add an entry if it doesn't exist
    add_entry() {
        local entry="$1"
        local file="$2"
        if ! grep -Fxq "$entry" "$file"; then
            echo "$entry" | sudo tee -a "$file" > /dev/null
            echo -e "\033[1;32m$entry added to $file.\033[0m"
        else
            echo -e "\033[1;33m$entry already exists in $file. Skipping...\033[0m"
        fi
    }
    
    # Add the localhost entry
    add_entry "$LOCALHOST_ENTRY" "$HOSTS_FILE"
    # Add the hostname entry
    add_entry "$HOSTNAME_ENTRY" "$HOSTS_FILE"
    
    echo -e "\033[1;32mEntries added to $HOSTS_FILE.\033[0m"
}

# Path to the pacman configuration file
PACMAN_CONF="/etc/pacman.conf"

# Function to check if repository exists in /etc/pacman.conf
repo_exists() {
    local repo_name="$1"
    grep -q "^\[$repo_name\]" "$PACMAN_CONF"
}

# Function to add repository configuration to /etc/pacman.conf
add_repo_to_pacman_conf() {
    local repo_name="$1"
    local repo_content="$2"
    if ! repo_exists "$repo_name"; then
        echo -e "\n$repo_content" | sudo tee -a "$PACMAN_CONF" > /dev/null
        echo -e "\033[1;32m$repo_name repository added to $PACMAN_CONF.\033[0m"
    else
        echo -e "\033[1;33m$repo_name repository already exists in $PACMAN_CONF. Skipping...\033[0m"
    fi
}

# Function to uncomment a specific line
uncomment_line() {
    local file="$1"
    local line_pattern="$2"
    sudo sed -i "s/^#\s*\($line_pattern\)/\1/" "$file"
}

# Uncomment the Color line
uncomment_line "$PACMAN_CONF" "Color"

# Uncomment and change ParallelDownloads line
sudo sed -i "s/^#\s*ParallelDownloads\s*=.*/ParallelDownloads = 10/" "$PACMAN_CONF"

# Uncomment the [multilib] section and Include line
sudo sed -i '/#\[multilib\]/,/#Include = \/etc\/pacman\.d\/mirrorlist/ s/^#//' "$PACMAN_CONF"

echo -e "\033[1;33mModifications to $PACMAN_CONF completed.\033[0m"

# Function to install Chaotic AUR repository
install_chaotic_aur() {
    if repo_exists "chaotic-aur"; then
        echo -e "\033[1;33mChaotic AUR repository already installed. Skipping...\033[0m"
    else
        echo -e "\033[1;34mInstalling Chaotic AUR repository...\033[0m"
        sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
        sudo pacman-key --lsign-key 3056513887B78AEB
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
        chaotic_repo="[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist"
        add_repo_to_pacman_conf "chaotic-aur" "$chaotic_repo"
        sudo pacman -Syy
        echo -e "\033[1;32mChaotic AUR repository installed.\033[0m"
    fi
}

# Function to install Athena OS repository
install_athena_os() {
    if repo_exists "athena"; then
        echo -e "\033[1;33mAthena OS repository already installed. Skipping...\033[0m"
    else
        echo -e "\033[1;34mInstalling Athena OS repository...\033[0m"
        athena_repo="[athena]
Include = /etc/pacman.d/athena-mirrorlist"
        add_repo_to_pacman_conf "athena" "$athena_repo"
        sudo curl https://raw.githubusercontent.com/Athena-OS/athena/main/packages/os-specific/athena-mirrorlist/athena-mirrorlist -o /etc/pacman.d/athena-mirrorlist
        sudo pacman-key --recv-keys A3F78B994C2171D5 --keyserver keys.openpgp.org
        sudo pacman-key --lsign-key A3F78B994C2171D5
        sudo pacman -Syy
        echo -e "\033[1;32mAthena OS repository installed.\033[0m"
    fi
}

# Function to install Blackarch repository
install_blackarch() {
    if repo_exists "blackarch"; then
        echo -e "\033[1;33mBlackarch repository already installed. Skipping...\033[0m"
    else
        echo -e "\033[1;34mInstalling Blackarch repository...\033[0m"
        curl -O https://blackarch.org/strap.sh
        chmod +x strap.sh
        sudo ./strap.sh
        echo -e "\033[1;32mBlackarch repository installed.\033[0m"
    fi
}

# Function to install Archstrike repository
install_archstrike() {
    if repo_exists "archstrike"; then
        echo -e "\033[1;33mArchstrike repository already installed. Skipping...\033[0m"
    else
        echo -e "\033[1;34mInstalling Archstrike repository...\033[0m"
        archstrike_repo="[archstrike]
Server = https://mirror.archstrike.org/\$arch/\$repo"
        add_repo_to_pacman_conf "archstrike" "$archstrike_repo"

        sudo pacman -Syy
        sudo pacman-key --init
        sudo dirmngr < /dev/null
        sudo pacman-key -r 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
        sudo pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
        sudo pacman -S --noconfirm archstrike-keyring
        sudo pacman -S --noconfirm archstrike-mirrorlist

        archstrike_repo="[archstrike]
Include = /etc/pacman.d/archstrike-mirrorlist"
        sudo sed -i '/\[archstrike\]/,/^Include/ s|Server = https://mirror.archstrike.org/\$arch/\$repo|Include = /etc/pacman.d/archstrike-mirrorlist|' "$PACMAN_CONF"
        sudo pacman -Syy
        echo -e "\033[1;32mArchstrike repository installed.\033[0m"
    fi
}

# Installation begins
install_chaotic_aur
install_athena_os
install_blackarch
install_archstrike
install_packages
install_yay
install_packages_with_yay
install_sliver
post_install_setup
rice
change_user_shell

echo -e "\033[1;32mSetup have been successfully completed. Please reboot the system.\033[0m"
