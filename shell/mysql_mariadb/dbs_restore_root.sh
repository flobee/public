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
# take care when modify/copy stuff manually a leave it without 
#

if [ ! -d $1 ]; then
    echo 'No database root directory given';
    exit 1;
fi

DBDIR=$1;
DBNAME='someDBname';


DBLIST=`ls ${DBDIR}`

for DBNAME in ${DBLIST} ; 
do
    if [ ! -d "${DBDIR}/${DBNAME}" ]; then
        echo "Not a directory. Invalid source found (a file?): '${DBDIR}/${DBNAME}'";
        exit 1;
    fi

    echo "Restore: '${DBNAME}'";
    echo "myloader --overwrite-tables --database "${DBNAME}" --directory "${DBDIR}/${DBNAME}" ";
    
done
