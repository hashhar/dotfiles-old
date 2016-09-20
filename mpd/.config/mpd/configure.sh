#!/usr/bin/env bash

# Disable mpd as a system daemon
sudo systemctl stop mpd
sudo systemctl mask mpd

sudo systemctl stop mpd.socket
sudo systemctl mask mpd.socket

# Add a desktop file in ~/.config/autostart to start mpd on login as current user
mkdir -p "$HOME/.config/autostart"
cat << 'EOF' > "$HOME/.config/autostart/mpd.desktop"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Music Player Daemon
Comment=Server for playing audio files
Exec=mpd
StartupNotify=false
Terminal=false
Hidden=false
EOF

sudo apt install mpdscribble

if [ -d "$HOME/.mpdscribble" ]
then
    echo "MPD Scribble configuration exists. Will not overwrite."
else
    mkdir "$HOME/.mpdscribble"
    sudo cp /etc/mpdscribble.conf "$HOME/.mpdscribble/mpdscribble.conf"
    sudo chown "$USER" "$HOME/.mpdscribble/mpdscribble.conf"
fi

sudo systemctl stop mpdscribble
sudo systemctl mask mpdscribble

# Add a desktop file in ~/.config/autostart to start mpdscribble on login as current user
mkdir -p "$HOME/.config/autostart"
cat << EOF > "$HOME/.config/autostart/mpdscribble.desktop"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=MPD Scribble
Comment=Scrobbles files from MPD to Last.fm
Exec=mpdscribble --log ${HOME}/.mpdscribble/log --conf ${HOME}/.mpdscribble/mpdscribble.conf
StartupNotify=false
Terminal=false
Hidden=false
EOF
