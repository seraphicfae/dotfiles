### My somewhat minimal dotfiles for Hyprland

Thanks to [LinuxMobile](https://github.com/linuxmobile) for the base config. \
Thanks to [Catppuccin](https://github.com/catppuccin) for the amazing themes. \
Thanks to [Adi1090x](https://github.com/adi1090x/rofi/) for the incredible rofi config.

### Showcase
https://github.com/user-attachments/assets/6b7fde5b-2e64-4ce6-908a-5a709ffebdbd

### Run the installation script:
##### Don't run random scripts blindly.
```
git clone https://github.com/seraphicfae/hyprland-dotfiles
cd hyprland-dotfiles
./setup.sh
```

### Manual installation:
##### Made for a fresh install, do not execute commands blindly.
#### Dependencies

```
paru -S bluez bluez-utils blueman cava fastfetch ffmpegthumbnailer grim gvfs gvfs-mtp hyprland hyprlock hyprpicker kitty mission-center
mpv mtpfs nautilus-open-any-terminal network-manager-applet networkmanager noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nwg-look
nushell obs-studio papirus-icon-theme pavucontrol qt5-wayland qt6-wayland rofi sddm sddm-theme-catppuccin slurp starship swaync swww
ttf-jetbrains-mono-nerd viewnior waybar wl-clipboard xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-user-dirs
xorg-xwayland zed && rm -rf ~/paru
```
###### Psst, edit your /etc/pacman.conf for multilib so you can get steam

#### Steps
```
cd hyprland-dotfiles
cp -r .config/* ~/.config/
mkdir -p ~/.icons ~/.themes
cp -r .icons/* ~/.icons/
cp -r .themes/* ~/.themes/
```

#### Finalizing
```
sudo systemctl enable --now NetworkManager bluetooth
sudo systemctl enable sddm
echo -e "[Theme]\nCurrent=catppuccin-mocha" | sudo tee /etc/sddm.conf
chsh -s /usr/bin/nu
reboot
```

### FAQ / Common Issues
**My temperature module doesn’t load** \
Default path is `/sys/class/hwmon/hwmon2/temp1_input`. Set it to your system's correct thermal zone.

**My theme isn't applying to GTK4 apps? (Nautilus & Amberol)** \
Try deleting the `~/.config/gtk-4.0 folder`, and set the theme via nwg-look.

**MPRIS module is empty** \
It only shows when media is playing.

**How can I set my resolution and refresh rate?** \
Via Hyprland.conf: scroll down to the bottom and input your specifications.
