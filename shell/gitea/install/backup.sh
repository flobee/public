#!/bin/sh

# ---------------------------------------------------------------------
# Basic includes for all scripts
# ---------------------------------------------------------------------
DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
. ${DIR_OF_FILE}/shellFunctions.sh
sourceConfigs "${DIR_OF_FILE}" "config.sh-dist" "config.sh"
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
# backup handling
# ---------------------------------------------------------------------

echo '# backup sources';

if [ ! -d "${PATH_BACKUPS}" ]; then
    mkdir -p "${PATH_BACKUPS}";
fi

echo '# pls delete old backups, probably:'
ls -alh ${PATH_BACKUPS}/gitea-${DIRNAME_REPOSITORIES}-*;
ls -alh ${PATH_BACKUPS}/gitea-${DIRNAME_GITEA}-*;

echo '# creating backups, pls. wait...';
tar -czf ${PATH_BACKUPS}/gitea-${DIRNAME_REPOSITORIES}-${TIMENOW}.tgz ${PATH_REPOSITORIES}/;
tar -czf ${PATH_BACKUPS}/gitea-${DIRNAME_GITEA}-${TIMENOW}.tgz ${PATH_GITEA}/;
echo "# Backups created: gitea-${DIRNAME_REPOSITORIES}-${TIMENOW}.tgz, gitea-${DIRNAME_GITEA}-${TIMENOW}.tgz";
echo
