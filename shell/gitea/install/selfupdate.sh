#!/bin/sh

# ---------------------------------------------------------------------
# self update script
# updates all scripts required for this program
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# Basic includes for all scripts
# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/shellFunctions.sh
sourceConfigs "${DIR_OF_FILE}" "config.sh-dist" "config.sh"
# ---------------------------------------------------------------------

# all old files (may still exists) to be removed
FILE_LIST_OLD='';
# all new files to download
FILE_LIST_NEW='backup.sh config.sh-dist config.sh.example-for-your-setup download.sh pre-install.sh install.sh README.md runner.sh shellFunctions.sh update.sh z_after_install_update.sh selfupdate.sh';

EXECUTABLES='selfupdate.sh runner.sh';

for FILE in ${FILE_LIST_OLD};
do
    rm "${DIR_OF_FILE}/${FILE}"
done;

for FILE in ${FILE_LIST_NEW};
do
    wget --quiet --show-progress --output-document="${DIR_OF_FILE}/${FILE}.new" "${GITEA_INSTALLER_BASEURL}/${FILE}" || rm "${DIR_OF_FILE}/${FILE}.new"
    if [ ! -f "${DIR_OF_FILE}/${FILE}.new" ]; then
        echo "Download failt for: '${DIR_OF_FILE}/${FILE}'. Pls check the source url";
    else
        mv "${DIR_OF_FILE}/${FILE}.new" "${DIR_OF_FILE}/${FILE}";
    fi
done;

for FILE in ${EXECUTABLES};
do
    chmod +x "${DIR_OF_FILE}/${FILE}"
done;


if [ -f "${DIR_OF_FILE}/config.sh" ]; then
    echo '+ ---------------------------------------------------------------------';
    echo "| Custom 'config.sh' found"
    echo "| Please compare your custom 'config.sh' with 'config.sh-dist' first"
    echo "| befor you go on";
    echo '+ ---------------------------------------------------------------------';
fi

echo 'Script updates (selfupdate) complete';

echo "You can run '${DIR_OF_FILE}/runner.sh' now";
