#!/bin/bash

# Download gitea bin
# Paths/ settings you may want to change: see config.sh

DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/config.sh

if [ "${GITEA_BIN_URL}" = "" ] ; then
    if [ "$1" != "" ]; then
        GITEA_BIN_URL=$1;
    else
        echo "GITEA_BIN_URL not set. Exit"
        exit 1;
    fi
fi

DOWNLOAD_NOW=0;

if [ "${ACTION_ASKQUESTIONS}" = "Y" ]; then
    CONFIRMCOMMAND=${ACTION_ASKQUESTIONS};
    echo "Download sources now? (defaut: '${ACTION_ASKQUESTIONS}')";
    confirmCommand "${ACTION_ASKQUESTIONS}";
    if [ "$?" = 0 ] && [ ${CONFIRMCOMMAND} = "Y" ]; then
        DOWNLOAD_NOW=1;
    fi
fi

if [ "${ACTION_ASKQUESTIONS}" = "N" ]; then
    DOWNLOAD_NOW=1;
fi


if [ "${DOWNLOAD_NOW}" = "1" ]; then
    wget --output-document="/tmp/${GITEA_BIN_BASENAME}" "${GITEA_BIN_URL}" || rm "/tmp/${GITEA_BIN_BASENAME}"
    wget --output-document="/tmp/${GITEA_BIN_BASENAME}.sha256" "${GITEA_BIN_URL}.sha256" || rm "/tmp/${GITEA_BIN_BASENAME}.sha256"
fi

if [ ! -f "/tmp/${GITEA_BIN_BASENAME}" ] ; then
    echo "Download error";
    exit 1;
fi

if [ ! -f "/tmp/${GITEA_BIN_BASENAME}.sha256" ] ; then
    echo "Download checksum file error";
    exit 1;
fi

echo "Download checksum check...";
cd /tmp;
if [ `sha256sum --status -c "${GITEA_BIN_BASENAME}.sha256"` ]; then
    echo 'Checksum error';
    exit 1;
else
    echo "OK";
fi
