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
echo "BASH"
stow -R bash
sudo stow -R -t /root bash

# BitDay wallpapers
echo "BitDay"
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
echo "CAVA"
stow -R cava

# Curl
echo "CURL"
stow -R curl

# Fonts
echo "FONTS"
mkdir -p ${HOME}/.fonts
stow -R fonts
fc-cache -f

# Git
echo "GIT"
stow -R git

# i3
echo "I3"
stow -R i3

# irssi
echo "IRSSI"
mkdir -p ${HOME}/.irssi
stow -R irssi

# Custom binary scripts
echo "MAGIC-BIN"
mkdir -p ${HOME}/.local/bin
stow -R magic-bin

# MPD
echo "MPD"
mkdir -p ${HOME}/.config/mpd
stow -R mpd

# Mutt
echo "MUTT"
mkdir -p ${HOME}/.mutt
stow -R mutt

# Nano syntax highlight files
echo "NANO"
mkdir -p ${HOME}/.nano
stow -R nano

# ncmpcpp
echo "NCMPCPP"
mkdir -p ${HOME}/.ncmpcpp
stow -R ncmpcpp

# neofetch
echo "NEOFETCH"
mkdir -p ${HOME}/.config/neofetch
stow -R neofetch

# Neovim and Vim
echo "VIM"
mkdir -p ${HOME}/.config/nvim
if [ ! -e ${HOME}/.vim ]; then
    ln -s ${HOME}/.config/nvim ${HOME}/.vim
fi
if [ ! -e ${HOME}/.vimrc ]; then
    ln -s ${HOME}/.config/nvim/init.vim ${HOME}/.vimrc
fi
stow -R neovim

# Redshift GTK
echo "REDSHIFT"
stow -R redshift

# Tmux
echo "TMUX"
stow -R tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Weechat
echo "WEECHAT"
mkdir -p ${HOME}/.weechat
stow -R weechat

# Xresources
echo "XRESOURCES"
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
