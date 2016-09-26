#!/usr/bin/env sh

#modules=$(find . -maxdepth 1 -type d \! -path "./.git" \! -path "\." -printf '%f\n')
#
#for module in ${modules}; do
#	stow -R ${module}
#	if [ "${module}" == "bash" ]; then
#		sudo stow -R --target=/root ${module}
#	fi
#done

git submodule init
git submodule update

# Bash (for current user and root user)
stow -R bash
sudo stow -R -t /root bash

# BitDay wallpapers
stow -R BitDay
crontab -l > cron.install
sed -i '/BitDay/d' cron.install
cat << EOF >> cron.install
# BitDay wallpaper rotation
0        *         *       *       *       ${HOME}/.config/BitDay/change.sh
@reboot                                    ${HOME}/.config/BitDay/change.sh
EOF
crontab cron.install
#rm cron.backup

# Cava
mkdir -p ${HOME}/.config/cava
stow -R cava

# Curl
stow -R curl

# Fonts
mkdir -p ${HOME}/.fonts
stow -R fonts
fc-cache -f

# Git
stow -R git

# i3
mkdir -p ${HOME}/.i3
stow -R i3

# irsii
mkdir -p ${HOME}/.irsii
stow -R irssi

# Custom binary scripts
mkdir -p ${HOME}/.local/bin
stow -R magic-bin

# MPD
mkdir -p ${HOME}/.config/mpd
stow -R mpd

# Mutt
mkdir -p ${HOME}/.mutt
stow -R mutt

# Nano syntax highlight files
mkdir -p ${HOME}/.nano
stow -R nano

# ncmpcpp
mkdir -p ${HOME}/.ncmpcpp
stow -R ncmpcpp

# neofetch
mkdir -p ${HOME}/.config/neofetch
stow -R neofetch

# Neovim and Vim
mkdir -p ${HOME}/.config/nvim
if [ ! -e ${HOME}/.vim ]; then
    ln -s ${HOME}/.config/nvim ${HOME}/.vim
fi
if [ ! -e ${HOME}/.vimrc ]; then
    ln -s ${HOME}/.config/nvim/init.vim ${HOME}/.vimrc
fi
stow -R neovim

# Redshift GTK
stow -R redshift

# Tmux
stow -R tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Weechat
mkdir -p ${HOME}/.weechat
stow -R weechat

# Xresources
stow -R Xresources

# Supporting stuff
# FASD
cwd="$(pwd)"
cd "${HOME}/.local/git/fasd/"
sudo PREFIX=/usr/local/stow/fasd make
sudo PREFIX=/usr/local/stow/fasd make install
cd /usr/local/stow
sudo stow -R fasd
cd "${cwd}"
