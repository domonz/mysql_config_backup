#!/bin/bash
echo "Reading config...." >&2
source ./config.cfg
echo "Config for the backup user: $mysql_user" >&2
echo "Config for the backup password: $mysql_passwd" >&2
echo "Config for the backup destination_folder: $dest" >&2

timestamp=$(date +"%F")

#mkdir -p $dest/MYSQL_DUMP

#MYSQL DUMP SESSION

#databases=`mysql --user=$mysql_user -p$mysql_passwd -e "SHOW DATABASES;"`

#for db in $databases; do
  mysqldump --opt --routines --triggers --events --skip-lock-tables --force --user=$mysql_user --password=$mysql_passwd --databases $db | gzip > "$dest/MYSQL_DUMP/$db-$timestamp.gz"
#done

#INNODB SESSION
#mkdir -p $dest/MYSQL_INNOBACKUP
#innobackupex --stream=tar --user=$mysql_user --password=$mysql_passwd --defaults-file=/etc/mysql/my.cnf ./ | gzip -c -9 > $dest/MYSQL_INNOBACKUP/full.$timestamp.tar.gz


echo "OPTIND starts at $OPTIND"
while getopts ":di:" optname
  do
    case "$optname" in
      "dump")
        mkdir -p $dest/MYSQL_DUMP
        databases=`mysql --user=$mysql_user -p$mysql_passwd -e "SHOW DATABASES;"`

			for db in $databases; do
  				mysqldump --opt --routines --triggers --events --skip-lock-tables --force --user=$mysql_user --password=$mysql_passwd --databases $db | gzip > "$dest/MYSQL_DUMP/$db-$timestamp.gz"
			done
        ;;
      "innodb")
        mkdir -p $dest/MYSQL_INNOBACKUP
		innobackupex --stream=tar --user=$mysql_user --password=$mysql_passwd --defaults-file=/etc/mysql/my.cnf ./ | gzip -c -9 > $dest/MYSQL_INNOBACKUP/full.$timestamp.tar.gz
        ;;
      "?")
        echo "Unknown option $OPTARG"
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        ;;
      *)
      # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
    echo "OPTIND is now $OPTIND"
  done