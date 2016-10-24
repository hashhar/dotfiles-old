#!/bin/sh

usage() {
	cat << 'EOF'
mediawiki-backup.sh mediawiki_root [backup_destination_path] [database_name] [username] [password]
Example: mediawiki-backup.sh /var/www/html/mediawiki /var/backup/mediawiki coolwiki johndoe password
All of the arguments except mediawiki_root are optional and default to the following values:
backup_destination_path: ~/backup
database_name: my_wiki
username: root
password: password
EOF
}

if [ "$#" -lt 1 ]; then
	usage
	exit 1
fi

# $1 - mediawiki root
# $2 - backup destination
# $3 - database name
# $4 - username
# $5 - password

mkdir -p "${2='~/backup'}"
FNAME=$(date +%Y-%m-%d)
#mysqldump -u "${4='root'}" --password="${5='password'}" "${3='my_wiki'}" --add-drop-table -B > "/tmp/mediawiki-${FNAME}.sql" 2>/dev/null
php maintenance/sqlite.php --backup-to "/tmp/mediawiki-${FNAME}.sqlite"
cd $1 && \
	git archive --format=zip --output="$2/mediawiki-${FNAME}.zip" HEAD && \
	zip --quiet -r "$2/mediawiki-${FNAME}.zip" "/var/www/html/mediawiki-images"
#zip --quiet -r "$2/mediawiki-${FNAME}.zip" "$1" "/tmp/mediawiki-${FNAME}.sqlite"
mv "/tmp/mediawiki-${FNAME}.sqlite" "$2"

cd "$2"
BUPS=$(find "$2" -maxdepth 1 -type f -iname "mediawiki-*")
for bup in $BUPS; do
	NUMBUPS=$(find "$2" -maxdepth 1 -type f -iname "mediawiki-*" | wc -l)
	if [ "$NUMBUPS" -gt 10 ]; then
		if [ "x$bup" != "x" ]; then
			rm "${bup}"
		fi
	fi
done
