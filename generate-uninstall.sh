#!/usr/bin/env sh

sed -e 's/stow -R/stow -D/g' install.sh > uninstall.sh.new
sed -e 's/cp .* \(.*\)/rm \1/g' uninstall.sh.new > uninstall.sh.bak && mv uninstall.sh.bak uninstall.sh.new
sed -e 's/ln \(.*\) \"\(.*\)\"/rm \"\2\"/g' uninstall.sh.new > uninstall.sh.bak && mv uninstall.sh.bak uninstall.sh.new
sed -e "s/crontab cron\.install/sed -n '\/BitDay\/!p' cron.install > cron.backup/g" uninstall.sh.new > uninstall.sh.bak && mv uninstall.sh.bak uninstall.sh.new
sed -e 's/\#rm cron\.backup/printf \"\\nNOTE: You may have to manually restore your crontab, a backup has been saved to cron.backup in the current directory\.\\n\\n\"/g' uninstall.sh.new > uninstall.sh.bak && mv uninstall.sh.bak uninstall.sh.new
sed -e 's/\.\/install/\.\/uninstall/g' uninstall.sh.new > uninstall.sh.bak && mv uninstall.sh.bak uninstall.sh.new
mv uninstall.sh.new uninstall.sh
chmod +x uninstall.sh
