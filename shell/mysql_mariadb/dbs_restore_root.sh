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
# if there is something special, e.g a backup file this script will exit! so
# take care when modify/extract stuff manually. Keep the directorys untouched!
#
# SECURITY WARNING: Use this script only in you private hood e.g. using remote
# connections or a private network. Otherwise your users can see your credentials
# eg. via the process list! I opened a ticket for this issue already.
# To be checked: 
# https://gist.github.com/scy/6781836
# https://stackoverflow.com/questions/2241063/bash-script-to-setup-a-temporary-ssh-tunnel/15198031#15198031

if [ -f "$1" ]; then
    source $1;
else
    echo 'Usage: <script> <config> <dbs directory> [opt flag: show only commands, dont execute]';

    source $(dirname $0)"/dbs_request_credentials.sh";

    _RST_OPT_DROP='true';
    read -p "Delete/ drop database befor restore: (true|false, default: '$_RST_OPT_DROP'): " RST_OPT_DROP
    RST_OPT_DROP=${RST_OPT_DROP:-$_RST_OPT_DROP}

    if [ "$2" = "" ] ; then
        _RST_OPT_DIR='/dir/to/databases';
    else
        _RST_OPT_DIR=$2;
    fi

    read -p "Directory of databases to restore: (current: '$_RST_OPT_DIR'): " RST_OPT_DIR
    RST_OPT_DIR=${RST_OPT_DIR:-$_RST_OPT_DIR}
fi


if [ ! -d "$2" ] && [ "${RST_OPT_DIR}" = "" ] ; then
    echo 'Usage: <script> <config> <dbs directory> [opt flag: show only commands, dont execute]';
    echo 'No databases root directory given';
    exit 1;
fi



MYDUMPER_CONN="-u ${MYSQL_USER} -p ${MYSQL_PASS} -h ${MYSQL_HOST} --port=${MYSQL_PORT}"
MYSQL_CONN="-u${MYSQL_USER} -p${MYSQL_PASS} -h${MYSQL_HOST} --port=${MYSQL_PORT}"

DBDIR=$2;

DBLIST=`ls ${DBDIR}`

for DBNAME in ${DBLIST} ; 
do
    if [ ! -d "${DBDIR}/${DBNAME}" ]; then
        echo "Not a directory. Invalid source found (a file?): '${DBDIR}/${DBNAME}'";
        exit 1;
    fi

    if [ "$3" = "" ]; then

        if [ "${RST_OPT_DROP}" = "true" ] ; then
            echo "Drop DB: '${DBNAME}'"
            mysql ${MYSQL_CONN} -ANe'DROP DATABASE `'"${DBNAME}"'`'
        fi

        echo "Restore: '${DBNAME}'"
        myloader ${MYDUMPER_CONN} --overwrite-tables --database "${DBNAME}" --directory "${DBDIR}/${DBNAME}"

    else
        if [ "${RST_OPT_DROP}" = "true" ] ; then
            echo "mysql ${MYSQL_CONN} -ANe'DROP DATABASE \`${DBNAME}\`'"
        fi
        echo "myloader ${MYDUMPER_CONN} --overwrite-tables --threads 8 --database "${DBNAME}" --directory "${DBDIR}/${DBNAME}" "
    fi

done
