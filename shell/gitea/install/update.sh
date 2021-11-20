#!/bin/sh

# Paths/ settings you may want to change: see config.sh

DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/config.sh

# Download gitea bin
sh ${DIR_OF_FILE}/download.sh

echo '# install binary';
cp -f "/tmp/${GITEA_BIN_BASENAME}" "${PATH_GITEA}/gitea"
chmod +x "${PATH_GITEA}/gitea"

systemctl stop gitea

systemctl start gitea

. ${DIR_OF_FILE}/z_after_install_update.sh
