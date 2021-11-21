#!/bin/sh

# ---------------------------------------------------------------------
# Paths/ settings you may want to change: see config.sh
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
# Basic includes for all scripts
# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/shellFunctions.sh
sourceConfigs "${DIR_OF_FILE}" "config.sh-dist" "config.sh"
# ---------------------------------------------------------------------

# Download gitea bin
sh ${DIR_OF_FILE}/download.sh "$1"
if [ "$?" != 0 ]; then
    exit 1;
fi

echo '# install binary';
cp -f "/tmp/${GITEA_BIN_BASENAME}" "${PATH_GITEA}/gitea"
chmod +x "${PATH_GITEA}/gitea"

systemctl stop gitea

systemctl start gitea

. ${DIR_OF_FILE}/z_after_install_update.sh
