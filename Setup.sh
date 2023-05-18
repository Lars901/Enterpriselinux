#!/bin/bash
username=$(id -u -n 1000)
builddir=$(pwd)

sudo dnf update -y
sudo dnf upgrade --refresh -y
sudo dnf config-manager --set-enabled crb
sudo dnf install -y epel-release
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm
#sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video

# Making .config and Moving config files and background to Pictures/Wallpapers
cd "$builddir" || exit
mkdir -p "/home/$username/.config"
mkdir -p "/home/$username/.fonts"
mkdir -p "/home/$username/Pictures"
mkdir -p "/home/$username/Wallpapers"
sudo mkdir -p /usr/share/sddm/themes
cd $builddir
#cd /Wallpapers
#cp -R *.jpg /$HOME/$USER/Pictures/Wallpapers/

PKGS=(
'alsa-utils' # audio utils
'ark' # compression
'bash-completion'
'autoconf' # build
'automake' # build
'bash-completion'
'binutils'
'bison'
'bluedevil'
'bluez'
'cups' #Common Unix Printing System
'curl'
'dialog'
'dosfstools'
'flex'
'fuse3'
'konsole'
'gcc'
'git-core'
'gnome-tweaks'
#'gnome-shellextension-desktop-icons'
'gdisk'
'haveged'
'htop'
'nftables'
'libtool'
'libcupsimage2' #Canon Printer driver requirement
'lsof'
'lutris'
'lzop'
'm4'
'make'
'nano'
'neofetch'
'ntfs-3g'
'okular'
'os-prober'
'p7zip'
'patch'
'pkgconf' 
'python3-pip'
'rsync'
'flatpak'
'ttmkfdir'
'thunar'
'jq'
'ufw'
'unrar'
'unzip'
'usbutils'
'vulkan-tools'
'wget'
'zip'
'g++'
'rpm-build'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo dnf install "$PKG"
done
systemctl enable cups
systemctl start cups
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
sudo dnf remove firefox
sudo dnf remove neovim
sudo dnf remove gnome-terminal
#Fonts
#Requirements
sudo rpm -i https://dl.rockylinux.org/pub/rocky/9/devel/x86_64/os/Packages/x/xorg-x11-font-utils-7.5-53.el9.x86_64.rpm
sudo rpm -i http://mirror.stream.centos.org/9-stream/AppStream/x86_64/os/Packages/xorg-x11-fonts-Type1-7.5-33.el9.noarch.rpm
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
sudo dnf makecache
sudo dnf install fontawesome-fonts.noarch
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d "/home/$username/.fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d "/home/$username/.fonts"
mv dotfonts/fontawesome/otfs/*.otf "/home/$username/.fonts/"
git clone https://github.com/SpudGunMan/segoe-ui-linux
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip
sudo dnf install -y google-noto-emoji-fonts
sudo mkdir ~/.config/fontsconfig
sudo cp 01-emoji.conf ~/.config/fontconfig/conf.d/01-emoji.conf
# Reloading Font cache
fc-cache -vf

# Layan Cursors
cd "$builddir" || exit
git clone https://github.com/vinceliuice/Layan-cursors
cd Layan-cursors || exit
chmod +x ./install.sh
sudo ./install.sh
cd "$builddir" || exit

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors || exit
chmod +x ./install.sh
sudo ./install.sh
cd "$builddir" || exit
rm -rf Nordzy-cursors

#Mybash
cd "$builddir" || exit
git clone https://github.com/christitustech/mybash.git
cd /mybash
sudo chmod +x ./Install.sh
./Install.sh

#Win11 Icons
cd "$builddir" || exit
git clone https://github.com/yeyushengfan258/Win11-icon-theme.git
#GTK Theme
cd "$builddir" || exit
git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
#Wallpapers 
wget https://4kwallpapers.com/images/wallpapers/windows-11-blue-stock-white-background-light-official-3840x2400-5616.jpg
wget https://4kwallpapers.com/images/wallpapers/windows-11-dark-mode-blue-stock-official-3840x2400-5630.jpg

#Dash to panel
cd "$builddir" || exit
git clone https://github.com/home-sweet-gnome/dash-to-panel.git
#Automatic updates
sudo dnf install -y dnf-automatic
sudo dnf install rocky-indexhtml

#Drivers
wget https://repo.radeon.com/amdgpu-install/22.40.3/rhel/9.1/amdgpu-install-5.4.50403-1.el9.noarch.rpm
#sudo dnf install -y --accept-eula ./amdgpu-install-5.4.50403-1.el9.noarch.rpm --opencl=rocr,legacy --vulkan=amdvlk,pro


#Qemu
sudo dnf install @virt
sudo dnf -y install libvirt-devel virt-top libguestfs-tools
sudo systemctl enable --now libvirtd
sudo dnf -y install virt-manager
sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG kvm $USER
sudo usermod -aG input $USER
sudo usermod -aG disk $USER

#Google Chrome for installing Gnome Extensions
cd "$builddir" || exit
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#Flatpaks
#Flatseal addon
flatpak install -y flathub com.github.tchx84.Flatseal
#Spotify
flatpak install -y flathub com.spotify.Client
#Dolphin Emu
flatpak install -y flathub org.DolphinEmu.dolphin-emu
cd "/home/$username"
wget https://downloads.romspedia.com/roms/Legend%20of%20Zelda%2C%20The%20-%20The%20Wind%20Waker%20%28USA%29.7z
wget https://www.mediafire.com/file/uijj3i3349h8j2j/gba_bios.zip/file

#RPCS3 Emu
flatpak install -y flathub net.rpcs3.RPCS3
cd "$builddir" || exit
wget http://dus01.ps3.update.playstation.net/update/ps3/image/us/2023_0228_05fe32f5dc8c78acbcd84d36ee7fdc5b/PS3UPDAT.PUP

#Brave Browser
flatpak install -y flathub com.brave.Browser
#MineCraft
flatpak install -y flathub com.mojang.Minecraft
#Bedrock Edition
flatpak install -y flathub io.mrarm.mcpelauncher
#Discord
flatpak install -y flathub com.discordapp.Discord
#Wallpaper downloader
flatpak install -y flathub es.estoes.wallpaperDownloader
#Bible applications
flatpak install -y flathub org.xiphos.Xiphos
#Github Desktop 
flatpak install -y flathub io.github.shiftey.Desktop
#MakeMkv
flatpak install -y flathub com.makemkv.MakeMKV
#Thunderbird Mailclient
flatpak install -y flathub org.mozilla.Thunderbird
#Chatterino
flatpak install -y chatterino
#VSCodium
flatpak install -y flathub com.vscodium.codium
#LibreOffice
flatpak install -y flathub org.libreoffice.LibreOffice
#Gnome Extensions
flatpak install -y flathub org.gnome.Extensions
flatpak install -y flathub com.mattjakeman.ExtensionManager