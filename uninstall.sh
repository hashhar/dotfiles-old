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
stow -D bash
sudo stow -D -t /root bash

# BitDay wallpapers
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
mkdir -p ${HOME}/.config/cava
stow -D cava

# Curl
stow -D curl

# Fonts
mkdir -p ${HOME}/.fonts
stow -D fonts
fc-cache -f

# Git
stow -D git

# i3
mkdir -p ${HOME}/.i3
stow -D i3

# irsii
mkdir -p ${HOME}/.irsii
stow -D irsii

# Custom binary scripts
mkdir -p ${HOME}/.local/bin
stow -D magic-bin

# MPD
mkdir -p ${HOME}/.config/mpd
stow -D mpd

# Nano syntax highlight files
mkdir -p ${HOME}/.nano
stow -D nano

# ncmpcpp
mkdir -p ${HOME}/.ncmpcpp
stow -D ncmpcpp

# neofetch
mkdir -p ${HOME}/.config/neofetch
stow -D neofetch

# Neovim and Vim
mkdir -p ${HOME}/.config/nvim
if [ -e ${HOME}/.vim ]; then
    rm ${HOME}/.vim
fi
if [ -e ${HOME}/.vimrc ]; then
    rm ${HOME}/.vimrc
fi
stow -D neovim

# Redshift GTK
stow -D redshift

# Tmux
stow -D tmux
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Weechat
mkdir -p ${HOME}/.weechat
stow -D weechat

# Xresources
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
