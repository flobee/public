#!/bin/bash

# restore backup'ed databases used with mydumper
#
# Install "mydumper" (apt-get install mydumper)
# use "myloader" to restore stuff, eg:
# myloader -u ${MYSQL_USER} -p ${MYSQL_PASS} -h ${MYSQL_HOST} \
#   --port=${MYSQL_PORT} ${MYSQL_SOCK} --overwrite-tables --threads 4 \
#   --database ${DBNAME}  --directory "${OUTDIR}/${DBNAME}"
#
#
# we need the root path of all backup'ed databases, eg:
# /nfs/backup/dbs/myhost/ (which contains a list of directorys created by mydumper)
# if there if something special, e.g a backup file this script will exit! so 
# take care when modify/copy stuff manually. Keep the directorys untouched
#


if [ ! -d "$2" ]; then
    echo 'Usage: <script> <config> <dbs directory> [opt flag: show only commands, dont execute]';
    echo 'No database root directory given';
    exit 1;
fi

if [ -f "$1" ]; then
    source $1;
else
    echo 'Usage: <script> <config> <dbs directory> [opt flag: show only commands, dont execute]';

    source $(dirname $0)"/dbs_request_credentials.sh";
fi

MYDUMPER_CONN="-u ${MYSQL_USER} -p ${MYSQL_PASS} -h ${MYSQL_HOST} --port=${MYSQL_PORT}"

DBDIR=$2;

DBLIST=`ls ${DBDIR}`

for DBNAME in ${DBLIST} ; 
do
    if [ ! -d "${DBDIR}/${DBNAME}" ]; then
        echo "Not a directory. Invalid source found (a file?): '${DBDIR}/${DBNAME}'";
        exit 1;
    fi

    if [ "$3" = "" ]; then 
        echo "Restore: '${DBNAME}'"
        myloader ${MYDUMPER_CONN} --overwrite-tables --database "${DBNAME}" --directory "${DBDIR}/${DBNAME}"
    else 
        echo "myloader ${MYDUMPER_CONN} --overwrite-tables --database "${DBNAME}" --directory "${DBDIR}/${DBNAME}" "
    fi

done
