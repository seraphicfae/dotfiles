#!/usr/bin/env bash

set -e

# ─────────── Theme and functions ───────────
# I like pretty colors :3
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
BOLD="\e[1m"
RESET="\e[0m"

okay()  { echo -e "${BOLD}${GREEN}[ OK ]${RESET} $1"; }
info()  { echo -e "${BOLD}${BLUE}[ .. ]${RESET} $1"; }
ask()   { echo -e "${BOLD}${MAGENTA}[ ? ]${RESET} $1"; }
warn()  { echo -e "${BOLD}${YELLOW}[ ! ]${RESET} $1"; }
fail()  { echo -e "${BOLD}${RED}[ FAIL ]${RESET} $1"; }
debug() { echo -e "${BOLD}${CYAN}[DEBUG]${RESET} $1"; }
note()  { echo -e "${BOLD}${WHITE}[ NOTE ]${RESET} $1"; }

# Get the directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify functions
SKIPPED_PACKAGE_INSTALL=0
SKIPPED_DOTFILES_COPY=0
SKIPPED_SERVICE_SETUP=0

# ─────────── Arch Linux check ───────────
if [ -f /etc/arch-release ]; then
    debug "This is an Arch-based distribution."
elif grep -qi "arch" /etc/os-release; then
    debug "This is an Arch-based distribution."
else
    fail "This is not an Arch-based distribution."
    exit 1
fi

# ─────────── SystemD check ───────────
if [ -d /run/systemd/system ]; then
    debug "System is running systemd"
else
    fail "System is not running systemd"
    exit 1
fi

clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗     ███████╗███████╗████████╗██╗   ██╗██████╗
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝
██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝    ███████║███████╗   ██║   ╚██████╔╝██║
╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝
EOF

# ─────────── Paru Installation ───────────
# Pretty self explanatory
if ! command -v paru &> /dev/null; then
    while true; do
        read -n 1 -r -p "$(ask "Would you like to install paru? [Y/n] ")" install_paru
        echo
        install_paru="${install_paru:-y}"

        if [[ "$install_paru" =~ ^[Yy]$ ]]; then
            git clone https://aur.archlinux.org/paru.git
            cd paru && makepkg -si && cd ..
            rm -rf paru
            if ! command -v paru &> /dev/null; then
            warn "Something went wrong with installing paru."
            fi
            break
        elif [[ "$install_paru" =~ ^[Nn]$ ]]; then
            fail "Paru is required. Exiting..."
            exit 1
        else
            warn "Please enter Y or N."
        fi
    done
else
    okay "Paru is already installed."
fi

# ─────────── Package Installation ───────────
sleep 5
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF

# Packages needed for dotfiles (and some that I use :3)
required_packages=(
    bluez bluez-utils blueman cava fastfetch fd ffmpegthumbnailer fzf g4music-git gimp grim gvfs gvfs-mtp hyprland hyprlock
    hyprpicker kitty mission-center mpv mtpfs nautilus-open-any-terminal network-manager-applet networkmanager noto-fonts-cjk
    noto-fonts-emoji noto-fonts-extra nwg-look obs-studio papirus-icon-theme pavucontrol qt5-wayland qt6-wayland rofi sddm
    sddm-theme-catppuccin slurp starship swaync swww ttf-jetbrains-mono-nerd ungoogled-chromium-bin viewnior waybar wl-clipboard
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-user-dirs xorg-xwayland zed zoxide zsh
)

optional_packages=(
    flac jdk21-openjdk keepassxc localsend-bin networkmanager-openvpn npm nodejs ryujinx vesktop-bin python-pipx polkit-gnome
)

# Filter out required packages that are already installed
required_packages=(
    $(for pkg in "${required_packages[@]}"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            echo "$pkg"
        fi
    done)
)

if (( ${#required_packages[@]} > 0 )); then
    warn "The following packages are missing:"
    printf "%s\n" "${required_packages[@]}" | paste -sd " " - | fold -s -w 80

    while true; do
        read -n 1 -r -p "$(ask "Would you like to install them? [Y/n] ")" install_missing
        echo
        install_missing="${install_missing:-y}"

        if [[ "$install_missing" =~ ^[Yy]$ ]]; then
            paru -S "${required_packages[@]}"
            okay "Missing packages installed."
            break
        elif [[ "$install_missing" =~ ^[Nn]$ ]]; then
            SKIPPED_PACKAGE_INSTALL=1
            warn "Skipped installing missing packages."
            break
        else
            warn "Please enter Y or N."
        fi
    done
else
    okay "All required packages are already installed."
    while true; do
        read -n 1 -r -p "$(ask "Would you like to update them anyway? [Y/n] ")" update_all
        echo
        update_all="${update_all:-y}"

        if [[ "$update_all" =~ ^[Yy]$ ]]; then
            paru -Syu --noconfirm
            okay "Packages updated."
            break
        elif [[ "$update_all" =~ ^[Nn]$ ]]; then
            info "Skipping package update."
            break
        else
            warn "Please enter Y or N."
        fi
    done
fi

# Filter out optional packages that are already installed
optional_packages=(
    $(for pkg in "${optional_packages[@]}"; do
        if ! pacman -Qq "$pkg" &>/dev/null; then
            echo "$pkg"
        fi
    done)
)

if (( ${#optional_packages[@]} > 0 )); then
    while true; do
        read -n 1 -r -p "$(ask "Would you like to install some optional packages? They are not required. [Y/n] ")" install_optional
        echo
        install_optional="${install_optional:-y}"

        if [[ "$install_optional" =~ ^[Yy]$ ]]; then
            warn "The following optional packages will be installed:"
            printf "%s\n" "${optional_packages[@]}" | paste -sd " " - | fold -s -w 80

            paru -S "${optional_packages[@]}"
            okay "Optional packages installed."
            break
        elif [[ "$install_optional" =~ ^[Nn]$ ]]; then
            info "Skipped installing optional packages."
            break
        else
            warn "Please enter Y or N."
        fi
    done
else
    info "All optional packages are already installed or none are missing."
fi

# ─────────── Dotfile(s) Installation ───────────
sleep 5
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF

declare -a dotfile_paths=(".config" ".icons" ".themes")

# Prompt if the user wants to backup their dotfiles.
while true; do
    read -n 1 -r -p "$(ask "Would you like to back up your existing dotfiles? [Y/n] ")" backup_dotfiles
    echo
    backup_dotfiles="${backup_dotfiles:-y}"

    if [[ "$backup_dotfiles" =~ ^[Yy]$ ]]; then
        for folder in "${dotfile_paths[@]}"; do
            target="$HOME/$folder"
            backup="$HOME/${folder}.bak"

            if [ -e "$target" ]; then
                info "Backing up $target to $backup"
                mv "$target" "$backup"
                okay "Backup of $folder complete."
            else
                warn "$target does not exist, skipping backup."
            fi
        done
        break
    elif [[ "$backup_dotfiles" =~ ^[Nn]$ ]]; then
        warn "Skipping backup of dotfiles."
        break
    else
        warn "Please enter Y or N."
    fi
done

# Prompt the user to copy over the dotfiles (will overwrite!!)
while true; do
    read -n 1 -r -p "$(ask "Would you like to copy dotfiles to your config(s)? [Y/n] ")" copy_dotfiles
    echo
    copy_dotfiles="${copy_dotfiles:-y}"

if [[ "$copy_dotfiles" =~ ^[Yy]$ ]]; then
    for folder in "${dotfile_paths[@]}"; do
        source="$DOTFILES_DIR/$folder"
        destination="$HOME/$folder"
        if [ -d "$source" ]; then
            mkdir -p "$destination"
            info "Copying contents of $source into $destination"
            cp -rf "$source/"* "$destination/"
            okay "Copied $folder to $destination"
        else
            warn "Source folder $source does not exist, skipping."
        fi
    done

    break
    elif [[ "$copy_dotfiles" =~ ^[Nn]$ ]]; then
        SKIPPED_DOTFILES_COPY=1
        warn "Skipping dotfile copy. Nothing was copied."
        break
    else
        warn "Please enter Y or N."
    fi
done
# ─────────── Services and Setup ───────────
sleep 5
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
EOF

while true; do
    read -n 1 -r -p "$(ask "Would you like to enable/start essential services? [Y/n] ")" enable_services
    echo
    enable_services=${enable_services:-y}

    if [[ "$enable_services" =~ ^[Yy]$ ]]; then
        # Start and enable NetworkManager
        if systemctl list-unit-files | grep -q '^NetworkManager\.service'; then
            if systemctl is-enabled --quiet NetworkManager; then
                info "NetworkManager is already enabled."
            else
                info "Enabling NetworkManager..."
                sudo systemctl enable NetworkManager
                okay "NetworkManager enabled."
            fi

            if systemctl is-active --quiet NetworkManager; then
                info "NetworkManager is already running."
            else
                info "Starting NetworkManager..."
                sudo systemctl start NetworkManager
                okay "NetworkManager started."
            fi
        else
            warn "NetworkManager is not installed or its unit file is missing."
        fi

        # Start and enable Bluetooth
        if systemctl list-unit-files | grep -q '^bluetooth\.service'; then
            if systemctl is-enabled --quiet bluetooth; then
                info "Bluetooth is already enabled."
            else
                info "Enabling Bluetooth..."
                sudo systemctl enable bluetooth
                okay "Bluetooth enabled."
            fi

            if systemctl is-active --quiet bluetooth; then
                info "Bluetooth is already running."
            else
                info "Starting Bluetooth..."
                sudo systemctl start bluetooth
                okay "Bluetooth started."
            fi
        else
            warn "Bluetooth is not installed or its unit file is missing."
        fi

        # Start SDDM
        if systemctl list-unit-files | grep -q '^sddm\.service'; then
            if systemctl is-enabled --quiet sddm; then
                info "SDDM is already enabled."
            else
                info "Enabling SDDM..."
                sudo systemctl enable sddm
                okay "SDDM enabled."
            fi
        else
            warn "SDDM is not installed or its unit file is missing."
        fi

        # Change the SDDM theme to /etc/sddm.conf (Warning: this will overwrite the file)
        info "Changing sddm theme..."
        bash -c 'echo -e "[Theme]\nCurrent=catppuccin-mocha" | sudo tee /etc/sddm.conf'
        okay "Changed sddm theme."

        # Set Zsh as default shell
        if command -v zsh &>/dev/null; then
            if [[ "$SHELL" == "/usr/bin/zsh" ]]; then
                info "Zsh is already the default shell for $(whoami)."
            else
                info "Setting Zsh as the default shell for $(whoami)..."
                chsh -s /usr/bin/zsh "$(whoami)"
                okay "Default shell changed to Zsh."
            fi

            # I hate zsh
            echo 'export ZDOTDIR="$HOME/.config/zsh"' > "$HOME/.zshenv"

            # Setup Antidote plugin manager
            mkdir -p "$HOME/.config/zsh"
            if [[ ! -d "$HOME/.config/zsh/antidote" ]]; then
                info "Downloading plugin manager..."
                git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.config/zsh/antidote"
            fi
        else
            warn "Zsh is not installed. Skipping shell setup."
        fi

        break
    elif [[ "$enable_services" =~ ^[Nn]$ ]]; then
        warn "Skipped enabling and starting services."
        SKIPPED_SERVICE_SETUP=1
        break
    else
        warn "Please enter Y or N."
    fi
done

# ─────────── System verification ───────────
sleep 5
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██████╗  ██████╗ ███╗   ██╗███████╗██╗
██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║
██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║
██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝
██████╔╝╚██████╔╝██║ ╚████║███████╗██╗
╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝
EOF

# Log skipped steps
echo -e "\n${BOLD}${BLUE}[ .. ]${RESET} Skipped steps:"
[ "$SKIPPED_PACKAGE_INSTALL" -eq 1 ] && warn "Package installation was skipped."
[ "$SKIPPED_DOTFILES_COPY" -eq 1 ] && warn "Dotfile copy was skipped."
[ "$SKIPPED_SERVICE_SETUP" -eq 1 ] && warn "Service setup was skipped."

# Final reboot prompt
while true; do
    read -n 1 -r -p "$(ask "Would you like to reboot now? [Y/n] ")" reboot_choice
    echo
    reboot_choice="${reboot_choice:-y}"

if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
    info "Rebooting system..."
    sudo reboot
    break
    elif [[ "$reboot_choice" =~ ^[Nn]$ ]]; then
        note "Setup complete. Reboot recommended before using your new system."
        break
    else
        warn "Please enter Y or N."
    fi
done

# Hey, you! Yeah, you! Good job on reading through this script. You never know what could be lurking! Your prize: The website I used for ascii art: https://patorjk.com/software/taag/#p=display&f=Sweet&t=%3A3
