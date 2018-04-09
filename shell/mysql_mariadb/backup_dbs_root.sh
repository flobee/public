#!/bin/bash

# backup each database in a seperated directory
#
# Install mydumper (apt-get install mydumper)
# use myloader to restore stuff, eg: 
# myloader -u ${MYSQL_USER} -p ${MYSQL_PASS} -h ${MYSQL_HOST} \
#   --port=${MYSQL_PORT} ${MYSQL_SOCK} --overwrite-tables --threads 4 \
#   --database ${DBNAME}  --directory "${OUTDIR}/${DBNAME}"
#
#
# first parameter as directory prefix which will creates:
# eg: <script> /tmp/somepath will result in
# /tmp/somepath/<database-name>/<sql files of tables and schemas>
# otherwise location to an individual config including the parameters: 
#   MYSQL_USER, MYSQL_PASS, MYSQL_PORT, MYSQL_HOST, OUTDIR
#


# pipe individual setups to the script for cron jobs
CONFFILE=$1

if [ -d "$CONFFILE" -o "$CONFFILE" = "" ]; then
    OUTDIR=$CONFFILE
    _OUTDIR='.'
    if [ "$CONFFILE" = "" ]; then
        read -p "Enter base directory (default: './'): " OUTDIR
        OUTDIR=${OUTDIR:-$CONFFILE}
    fi
    # Edit default credentials
    _MYSQL_USER='root';
    _MYSQL_PASS='';
    _MYSQL_PORT='3306';
    _MYSQL_HOST='localhost';
    # depending on your setup, eg. synology mariadb5 and 10 need a socket or you 
    # get only v5 even if the port if different
    _MYSQL_SOCK=''; #'-S /run/mysqld/mysqld10.sock'; # set to '' to not use socket connection

    read -p "Enter MYSQL USER (default: '$_MYSQL_USER'): " MYSQL_USER
    MYSQL_USER=${MYSQL_USER:-$_MYSQL_USER}

    read -p "Enter MYSQL_PASS (default: '$_MYSQL_PASS'): " MYSQL_PASS
    MYSQL_PASS=${MYSQL_PASS:-$_MYSQL_PASS}

    read -p "Enter MYSQL_HOST (default: '$_MYSQL_HOST'): " MYSQL_HOST
    MYSQL_HOST=${MYSQL_HOST:-$_MYSQL_HOST}

    read -p "Enter MYSQL_PORT (default: '$_MYSQL_PORT'): " MYSQL_PORT
    MYSQL_PORT=${MYSQL_PORT:-$_MYSQL_PORT}

    read -p "Enter MYSQL SOCKET (eg: /run/mysqld/mysqld.sock; default: '$_MYSQL_SOCK'): " MYSQL_SOCK
    MYSQL_SOCK=${MYSQL_SOCK:-$_MYSQL_SOCK}
else 
    source $CONFFILE
    if [ ! -d "$OUTDIR" ]; then
        mkdir "$OUTDIR"
    fi
fi

MYSQL_CONN="-u${MYSQL_USER} -p${MYSQL_PASS} -h${MYSQL_HOST} --port=${MYSQL_PORT} ${MYSQL_SOCK}"
MYDUMPER_CONN="-u ${MYSQL_USER} -p ${MYSQL_PASS} -h ${MYSQL_HOST} --port=${MYSQL_PORT} ${MYSQL_SOCK}"



# Collect all database names except for
# mysql, information_schema, and performance_schema and phpmyadmin
SQL="SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN"
SQL="${SQL} ('mysql','information_schema','performance_schema', 'phpmyadmin')"

HASH=`date +"%Y-%m-%d_%_H%M%S"`;
DBLISTFILE=/tmp/${HASH}DatabasesToDump.txt
mysql ${MYSQL_CONN} -ANe"${SQL}" > ${DBLISTFILE}

DBLIST=""
for DB in `cat ${DBLISTFILE}` ; 
do
    DBLIST="${DBLIST} ${DB}" ; 
done


echo "dump output to '${OUTDIR}/<database-name>/<sql-files>.sql'";
echo "backup dbs: ${DBLIST}";

echo "job starts in 3 sec... to abort press CNTL + C";
sleep 3;

MYSQLDUMP_OPTIONS="--routines --triggers --events --lock-all-tables --rows 1000000 --statement-size 100000"
# mysqldump ${MYSQL_CONN} ${MYSQLDUMP_OPTIONS} --databases ${DBLIST} --no-data > "${OUTDIR}.schema.sql"
# mysqldump ${MYSQL_CONN} ${MYSQLDUMP_OPTIONS} --no-create-info --databases ${DBLIST} > "${OUTDIR}.data.sql"

for DBNAME in `cat ${DBLISTFILE}` ;
do
    echo "Dumping: '${DBNAME}' to '${OUTDIR}/${DBNAME}'"
    mydumper ${MYDUMPER_CONN} ${MYSQLDUMP_OPTIONS} --database "${DBNAME}" --outputdir "${OUTDIR}/${DBNAME}"
    # mysqldump ${MYSQL_CONN} ${MYSQLDUMP_OPTIONS} ${DBNAME} > "${OUTDIR}.${DBNAME}.sql"
done


# clean up
rm $DBLISTFILE
