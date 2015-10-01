#!/bin/bash
echo "Reading config...." >&2
source ./config.cfg
echo "Config for the backup user: $mysql_user" >&2
echo "Config for the backup password: $mysql_passwd" >&2
echo "Config for the backup destination_folder: $dest" >&2
echo "Config for the backup mysql_host: $mysql_host" >&2

timestamp=$(date +"%F")

#mkdir -p $dest/MYSQL_DUMP

#MYSQL DUMP SESSION

#databases=`mysql --user=$mysql_user -p$mysql_passwd -e "SHOW DATABASES;"`

#for db in $databases; do
  #mysqldump --opt --routines --triggers --events --skip-lock-tables --force --user=$mysql_user --password=$mysql_passwd --databases $db | gzip > "$dest/MYSQL_DUMP/$db-$timestamp.gz"
#done

#INNODB SESSION
#mkdir -p $dest/MYSQL_INNOBACKUP
#innobackupex --stream=tar --user=$mysql_user --password=$mysql_passwd --defaults-file=/etc/mysql/my.cnf ./ | gzip -c -9 > $dest/MYSQL_INNOBACKUP/full.$timestamp.tar.gz


while getopts ":di" opt; do
  case $opt in
    d)
      mkdir -p $dest/MYSQL_DUMP
        databases=`mysql --user=$mysql_user -p$mysql_passwd -e "SHOW DATABASES;"`

			for db in $databases; do
  				mysqldump --opt --routines --triggers --events --skip-lock-tables --force --host=$mysql_host--user=$mysql_user --password=$mysql_passwd --databases $db | gzip > "$dest/MYSQL_DUMP/$db-$timestamp.gz"
			done
	cd $dest/MYSQL_DUMP
	ls -tQ | tail -n+7 | xargs rm
    			
    ;;
    i)
     mkdir -p $dest/MYSQL_INNOBACKUP
	 innobackupex --stream=tar --host=$mysql_host --user=$mysql_user --password=$mysql_passwd --defaults-file=/etc/mysql/my.cnf ./ | gzip -c -9 > $dest/MYSQL_INNOBACKUP/full.$timestamp.tar.gz
	 cd $dest/MYSQL_INNOBACKUP
	 ls -tQ | tail -n+7 | xargs rm
    ;;   
     \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done