#!/usr/bin/env sh

find . -maxdepth 1 -type d \! -path "./.git" \! -path "\." \! -path "./ascii" -printf '%f\n' | sort > /tmp/modules.txt

sed -n "s/^stow\ -R\ \([a-zA-Z0-9-]\+\)$/\1/p" install.sh | sort > /tmp/installer_modules.txt

sed -n "s/^stow\ -D\ \([a-zA-Z0-9-]\+\)$/\1/p" uninstall.sh | sort > /tmp/uninstaller_modules.txt

diff /tmp/modules.txt /tmp/installer_modules.txt
if [ $? -eq 0 ]; then
  printf '%s\n' 'Installer is up to date.'
else
  printf '==============================\nINSTALLER NEEDS TO BE UPDATED.\n==============================\n'
fi

diff /tmp/modules.txt /tmp/uninstaller_modules.txt
if [ $? -eq 0 ]; then
  printf '%s\n' 'Uninstaller is up to date.'
else
  printf '==============================\nUNINSTALLER NEEDS TO BE UPDATED.\n==============================\n'
fi
