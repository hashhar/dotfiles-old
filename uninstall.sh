#!/usr/bin/env sh

#modules=$(find . -maxdepth 1 -type d \! -path "./.git" \! -path "\." -printf '%f\n')
#
#for module in ${modules}; do
#	stow -D ${module}
#	if [ "${module}" == "bash" ]; then
#		sudo stow -D --target=/root ${module}
#	fi
#done

# git submodule init
# git submodule update

# Bash (for current user and root user)
echo "BASH"
stow -D bash
sudo stow -D -t /root bash

# BitDay wallpapers
echo "BitDay"
stow -D BitDay
crontab -l > cron.install
sed -i '/BitDay/d' cron.install
cat << EOF >> cron.install
# BitDay wallpaper rotation
0        *         *       *       *       ${HOME}/.config/BitDay/change.sh
@reboot                                    ${HOME}/.config/BitDay/change.sh
EOF
sed -n '/BitDay/!p' cron.install > cron.backup
printf "\nNOTE: You may have to manually restore your crontab, a backup has been saved to cron.backup in the current directory.\n\n"

# Cava
echo "CAVA"
stow -D cava

# Curl
echo "CURL"
stow -D curl

# Fonts
echo "FONTS"
mkdir -p ${HOME}/.fonts
stow -D fonts
fc-cache -f

# Git
echo "GIT"
stow -D git

# i3
echo "I3"
stow -D i3

# irssi
echo "IRSSI"
stow -D irssi

# Latex
echo "LaTeX"
stow -D latex

# Custom binary scripts
echo "MAGIC-BIN"
mkdir -p ${HOME}/.local/bin
stow -D magic-bin

# MPD
echo "MPD"
mkdir -p ${HOME}/.config/mpd
stow -D mpd

# MPDRIS2
echo "MPDRIS2"
stow -D mpDris2

# Mutt
echo "MUTT"
stow -D mutt

# Nano syntax highlight files
echo "NANO"
stow -D nano

# ncmpcpp
echo "NCMPCPP"
mkdir -p ${HOME}/.ncmpcpp
stow -D ncmpcpp

# neofetch
echo "NEOFETCH"
stow -D neofetch

# Neovim and Vim
echo "VIM"
mkdir -p ${HOME}/.config/nvim
if [ -e ${HOME}/.vim ]; then
    rm ${HOME}/.vim
fi
if [ -e ${HOME}/.vimrc ]; then
    rm ${HOME}/.vimrc
fi
stow -D neovim

# Redshift GTK
echo "REDSHIFT"
stow -D redshift

# Tmux
echo "TMUX"
stow -D tmux
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Weechat
echo "WEECHAT"
mkdir -p ${HOME}/.weechat
stow -D weechat

# Xresources
echo "XRESOURCES"
stow -D Xresources

# Supporting stuff
# FASD
cwd="$(pwd)"
cd "${HOME}/.local/git/fasd/"
sudo PREFIX=/usr/local/stow/fasd make
sudo PREFIX=/usr/local/stow/fasd make install
cd /usr/local/stow
sudo stow -D fasd
cd "${cwd}"
