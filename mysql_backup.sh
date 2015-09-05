#!/bin/sh
#
# MySQL bacula backup script
#
# Mon Apr  2 00:52:27 CEST 2012, Andrea Leofreddi, initial version
#

### Configuration >>>>

PATH=$PATH:/opt/csw/bin

BACKUP_HOME=/u01/backup

MYSQL_DATA=/u01/mysqldata
MYSQL_LOGS='mysql-bin*'

LOG_FILE=/tmp/mysql_backup.log

### Configuration <<<<

INDENT='    '

echo `date`: running $0 with args $@ >>$LOG_FILE

if [ "x$BACKUP_HOME" = x ]; then
	echo Missing environment variable BACKUP_HOME >&2

	exit 20
fi

if [ ! -r $BACKUP_HOME/etc/mysql_backup.conf ]; then
	echo Missing configuration file $BACKUP_HOME/etc/mysql_backup.conf >&2

	exit 21
fi

. $BACKUP_HOME/etc/mysql_backup.conf

set -- `/usr/bin/getopt cl: $*`

if [ $? != 0 ]
then
	echo Usage: $0 [-c] -l LEVEL >&2

       	exit 10
fi

CLEAN=0
LEVEL=none

for i in $*
do
	case "$i" in
	-c) CLEAN=1; shift;;
	-l) LEVEL=$2; shift 2;;
	--) shift; break;;
	esac
done

echo `date`:"${INDENT}"running \(level $LEVEL, clean mode $CLEAN\) >>$LOG_FILE

if [ $CLEAN = 0 -a $LEVEL = Full ]; then
	echo `date`:"${INDENT}"running full backup >>$LOG_FILE

	rm -f $BACKUP_HOME/tmp/mysql-full.dmp

	mysqldump \
		-u $USER \
		-p"$PASSWORD" \
		--flush-logs \
		--delete-master-logs \
		--master-data=2 \
		--add-drop-table \
		--single-transaction \
		-A \
	> $BACKUP_HOME/data/mysql-full.dmp ;

	if [ ! -r $BACKUP_HOME/data/mysql-full.dmp ]; then
		echo `date`:"${INDENT}"unable to dump mysql >>$LOG_FILE
		
		exit 30;
	fi

	echo `date`:"${INDENT}"full backup dump complete >>$LOG_FILE
elif [ $CLEAN = 0 -a $LEVEL = Incremental ]; then
	echo 'FLUSH LOGS;' | mysql -u $USER -p"$PASSWORD"

	LOGS=`cd $MYSQL_DATA; echo $MYSQL_LOGS`

	(cd $MYSQL_DATA; tar cfp - $LOGS) | (cd $BACKUP_HOME/data; tar xfp -)

	echo `date`:"${INDENT}"incremental backup dump complete >>$LOG_FILE
elif [ $CLEAN = 0 -a $LEVEL = Differential ]; then
	LOGS=`cd $MYSQL_DATA; echo $MYSQL_LOGS`

	(cd $MYSQL_DATA; tar cfp - $LOGS) | (cd $BACKUP_HOME/data; tar xfp -)

	touch $BACKUP_HOME/data/*

	echo `date`:"${INDENT}"differential backup dump complete >>$LOG_FILE
elif [ $CLEAN = 1 ]; then
	echo `date`:"${INDENT}"removing backup files >>$LOG_FILE

	rm -f $BACKUP_HOME/data/$MYSQL_LOGS $BACKUP_HOME/data/mysql-full.dmp
fi

exit 0
