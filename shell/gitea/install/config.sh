#!/bin/sh

#
# --- Paths and settings you may want to change: -----------------------
#

USER=git;

PORT=3001;

PATH_HOME='/home/git';                      # home of $USER

PATH_BACKUPS="$PATH_HOME/backups"           # path for backups

PATH_GITEA="$PATH_HOME/tea";                # gitea in /home/git/tea/

PATH_REPOSITORIES="$PATH_HOME/repositories" # repos in /home/git/repositories/

GITEA_INSTALLER_URL='https://raw.githubusercontent.com/flobee/public/master/shell/gitea/INSTALL_gitea_README.md.sh';

# not yet
#GITEA_INSTALLER_SCRIPT="${PATH_HOME}/gitea_install_update.sh";

# not yet
#ACTION_DROPSCRIPTDEF='N';                   # this script to be droped at the
#                                            # remote side after execution; default: N (no)

ACTION_BACKUPDEF='Y';                       # default value for creation backups first: Y|N

# To install as a service set to 1 otherwise something different e.g 0
INSTALL_AS_SERVICE=1

ACTION_ASKQUESTIONS='Y';                    # Ask or just use the config defaults (Y|N)? N for automisations

ACTION_TYPE='I';                            # Type of installation: I|U
                                            # I = Install (new installation) also possible for updates
                                            #     to detect OS changes
                                            # U = just updates (fast, maybe dont work on OS changes)

# gitea download urls as var GITEA_BIN_URL to be installed by the installer
#GITEA_BIN_URL=https://dl.gitea.io/gitea/1.4.2/gitea-1.4.2-linux-amd64
#GITEA_BIN_URL=https://dl.gitea.io/gitea/1.12.3/gitea-1.12.3-linux-amd64
#GITEA_BIN_URL=https://github.com/go-gitea/gitea/releases/download/v1.12.3/gitea-1.12.3-linux-amd64
#GITEA_BIN_URL=https://dl.gitea.io/gitea/1.15.6/gitea-1.15.6-linux-amd64
GITEA_BIN_URL=https://github.com/go-gitea/gitea/releases/download/v1.15.6/gitea-1.15.6-linux-amd64

# --- internals ---

DIRNAME_REPOSITORIES=`basename "${PATH_REPOSITORIES}"`

DIRNAME_GITEA=`basename "${PATH_GITEA}"`

TIMENOW=`date +'%Y%m%d-%H%M%S'`;

GITEA_BIN_BASENAME=`basename "$GITEA_BIN_URL"`;

DIR_OF_FILE="$(dirname $(readlink -f "$0"))";
# basis functions
. ${DIR_OF_FILE}/shellFunctions.sh;
