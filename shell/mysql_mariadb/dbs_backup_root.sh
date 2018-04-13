#!/bin/bash

# Backup each database in a seperated directory of a MySql/MariaDB server
#
# Install "mydumper" (apt-get install mydumper)
# use "myloader" to restore stuff, eg:
# myloader -u ${MYSQL_USER} -p ${MYSQL_PASS} -h ${MYSQL_HOST} \
#   --port=${MYSQL_PORT} ${MYSQL_SOCK} --overwrite-tables --threads 4 \
#   --database ${DBNAME}  --directory "${OUTDIR}/${DBNAME}"
#
#
# First parameter as directory or as config file prefix.
# As, with given directory (manual backup), will create:
# eg: "<script> /tmp/somepath" will result in:
# /tmp/somepath/<database-name>/<sql files of tables and schemas> and you will 
# be ask for settings.
# or, otherwise location to an individual config including the parameters:
#   MYSQL_USER, MYSQL_PASS, MYSQL_PORT, MYSQL_HOST, OUTDIR
# to be run as cron job.
# If you only want to run this script in cron you can alter the shebang to (a)sh
# or dash
#
# SECURITY WARNING: Use this script only in you private hood e.g. using remote 
# connections/ private network. Otherwise your users can see your credentials 
# eg. via the process list! I opened a ticket for this issue already.
# To be checked: 
# https://gist.github.com/scy/6781836
# https://stackoverflow.com/questions/2241063/bash-script-to-setup-a-temporary-ssh-tunnel/15198031#15198031


# pipe individual setups to the script for cron jobs (if a config file, else 
# used as datadir)
CONFFILE=$1

if [ -d "$CONFFILE" -o "$CONFFILE" = "" ]; then
    OUTDIR=$CONFFILE
    _OUTDIR='.'
    if [ "$CONFFILE" = "" ]; then
        read -p "Enter base directory (default: './'): " OUTDIR
        OUTDIR=${OUTDIR:-$CONFFILE}
    fi
    source $(dirname $0)"/dbs_request_credentials.sh";
else 
    source $CONFFILE
    if [ ! -d "$OUTDIR" ]; then
        # do not -p if the path belongs to a network fs
        mkdir "$OUTDIR"
    fi
fi

# pre setup the connections
MYSQL_CONN="-u${MYSQL_USER} -p${MYSQL_PASS} -h${MYSQL_HOST} --port=${MYSQL_PORT} ${MYSQL_SOCK}"
MYDUMPER_CONN="-u ${MYSQL_USER} -p ${MYSQL_PASS} -h ${MYSQL_HOST} --port=${MYSQL_PORT} ${MYSQL_SOCK}"


# Collect all database names except for mysql, information_schema,
# performance_schema and phpmyadmin
SQL="SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN"
SQL="${SQL} ('mysql','information_schema','performance_schema', 'phpmyadmin')"

HASH=`date +"%Y%m%d%H%M%S"`;
DBLISTFILE="/tmp/${HASH}DatabasesToDump.txt"
mysql ${MYSQL_CONN} -ANe"${SQL}" > "${DBLISTFILE}"

DBLIST=""
for DB in `cat ${DBLISTFILE}` ; 
do
    DBLIST="${DBLIST} ${DB}" ; 
done


echo "Backup goes to: '${OUTDIR}/<database-name>/<sql-files>.sql'";
echo "List of DBs to backup: ${DBLIST}";
echo
echo "Job starts in 3 sec... to abort press CTRL + C";
sleep 3;

# Depending on you backup strategy you may want improved speed or less backup size.
# For speed play with the number of threads (def: 4) statement-size and rows size,
# For limited file sizes you may use "--compress" but in limited backup time intervals
MYSQLDUMP_OPTIONS="--routines --triggers --events --threads 8 --compress --lock-all-tables --rows
3000000 --statement-size 100000"
# mysqldump ${MYSQL_CONN} ${MYSQLDUMP_OPTIONS} --databases ${DBLIST} --no-data > "${OUTDIR}.schema.sql"
# mysqldump ${MYSQL_CONN} ${MYSQLDUMP_OPTIONS} --no-create-info --databases ${DBLIST} > "${OUTDIR}.data.sql"

for DBNAME in `cat ${DBLISTFILE}` ;
do
    echo "Dumping: '${DBNAME}' to '${OUTDIR}/${DBNAME}'"
    mydumper ${MYDUMPER_CONN} ${MYSQLDUMP_OPTIONS} --database "${DBNAME}" --outputdir "${OUTDIR}/${DBNAME}"
    # mysqldump ${MYSQL_CONN} ${MYSQLDUMP_OPTIONS} ${DBNAME} > "${OUTDIR}/${DBNAME}.sql"
done


# clean up
rm $DBLISTFILE

exit 0;
