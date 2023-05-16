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
chown -R "$username:$username" "/home/$username"

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
'breeze'
'celluloid' # video players
'cups' #Common Unix Printing System
'curl'
'dialog'
'dosfstools'
'flex'
'fuse3'
'gcc'
'git-core'
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
'ntp'
'okular'
'os-prober'
'p7zip'
'patch'
'pkgconf' 
'python3-pip'
'qemu-kvm'
'libvirt-clients' #Dependecy for quemu
'bridge-utils' #Dependecy for quemu
'rsync'
'flatpak'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'vulkan-tools'
'wget'
'zip'
'g++'
'libx11-dev'
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
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo dnf remove firefox-esr
#Fonts
#Requirements
sudo rpm -i http://mirror.stream.centos.org/9-stream/AppStream/x86_64/os/Packages/xorg-x11-fonts-Type1-7.5-33.el9.noarch.rpm
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
sudo dnf makecache
sudo dnf install fontawesome-fonts.noarch
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d "/home/$username/.fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d "/home/$username/.fonts"
mv dotfonts/fontawesome/otfs/*.otf "/home/$username/.fonts/"
chown "$username:$username" "/home/$username/.fonts/*"
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

#Automatic updates
sudo dnf install -y dnf-automatic

#Drivers
wget https://repo.radeon.com/amdgpu-install/22.40.3/rhel/9.1/amdgpu-install-5.4.50403-1.el9.noarch.rpm
#sudo dnf install -y --accept-eula ./amdgpu-install-5.4.50403-1.el9.noarch.rpm --opencl=rocr,legacy --vulkan=amdvlk,pro

#Qemu
sudo dnf makecache --refresh
sudo dnf install  edk2-ovmf -y
 sudo dnf install qemu-kvm qemu-img libvirt virt-manager virt-install virt-viewer libvirt-client -y
 sudo systemctl start libvirtd*
 sudo systemctl enable libvirtd

Flatpaks=(
'Flathub com.github.tchx84.Flatseal' #Flatpak addon
'flathub com.brave.Browser' #BraveBrowser
'flathub com.spotify.Client'
'flathub com.discordapp.Discord'
'flathub io.github.shiftey.Desktop'
'flathub com.makemkv.MakeMKV'
'flathub org.libreoffice.LibreOffice' #Newer version than in repo
'flathub org.mozilla.Thunderbird' #Email client
'org.inkscape.Inkscape' #Vector Graphics Editor
'flathub com.vscodium.codium' #Free/Libre Open Source Software Binaries of VS Code
)

for PKG in "${Flatpaks[@]}"; do
    echo "INSTALLING: ${PKG}"
    flatpak install -y "$Flatpaks"