#!/bin/bash
echo "Reading config...." >&2
source ./config.cfg
echo "Config for the backup user: $mysql_user" >&2
echo "Config for the backup password: $mysql_passwd" >&2
echo "Config for the backup destination_folder: $dest" >&2

timestamp=$(date +"%F")

mkdir -p $dest

#MYSQL DUMP SESSION

databases=`$mysql --user=$mysql_user --password=$mysql_passwd -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`

for db in $databases; do
  mysqldump --opt --routines --triggers --events --skip-lock-tables --force --user=$mysql_user --password=$mysql_passwd --databases $db | gzip > "$dest/$db-$timestamp.gz"
done

