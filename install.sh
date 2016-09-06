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
stow -R cava

# Curl
stow -R curl

# Fonts
stow -R fonts
fc-cache -f

# i3
stow -R i3

# irsii
stow -R irsii

# Custom binary scripts
stow -R magic-bin

# MPD
stow -R mpd

# Nano syntax highlight files
stow -R nano

# ncmpcpp
stow -R ncmpcpp

# neofetch
stow -R neofetch

# Neovim and Vim
stow -R neovim

# Redshift GTK
stow -R redshift

# Tmux
stow -R tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Weechat
stow -R weechat

# Supporting stuff
# FASD
cwd="$(pwd)"
cd "${HOME}/.local/git/fasd/"
sudo PREFIX=/usr/local/stow/fasd make
sudo PREFIX=/usr/local/stow/fasd make install
cd /usr/local/stow
sudo stow -R fasd
cd "${cwd}"
