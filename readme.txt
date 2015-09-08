####mysql backup script

INSTALLATION

1.:

Go to root directory of the script, recommended /usr/local/bin/
cd /usr/local/bin/

2.:

Clone latest release from github

https://github.com/domonz/mysql_config_backup.git

git create directory  mysql_config_backup


3.
Create config file:

The configuration file must be within the library and File names must match config.cfg and syntax below,

#####
mysql_user="root"	# recommended root user, this is the best dump trigers, events, and options, or mysql schema database
mysql_passwd=""
dest="/var/backups/mysql" # recommended /var/backups/mysql
####


4.:
run script with options

sh mysql_backup_dump_opt.sh


-d - make only mysql dump to the MYSQL_DUMP inside the "dest" directory 

-i - make only innodbbackup to the MYSQL_INNOBACKUP inside the "dest" directory 

You can use both one command 

sh mysql_backup_dump_opt.sh -d -i


You can schedule mysql backup cron.

Warning!!!!
THIIS SCRIPT NOT DELETE BACKUPS!!!!

