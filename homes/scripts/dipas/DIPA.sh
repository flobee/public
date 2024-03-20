#!/bin/bash

# shellcheck disable=SC2016

# {{{ INTRO / README
#
# DIPA.sh - (D)eep (I)nstall and (P)roject (A)ssistant (Sh)ellscript
#
# for the DIPAS - 'Digitales Partizipationssystem' project; Hamburg/ Germany
# [DIPAS](https://dipas.org)
#
# Project development and enviroment assistant.
#
# Inspired from the `dipash_toolkit.sh`, now a complete rewrite to improve
# maintainance, bash learning for some specific cases... here is one of the
# solutions for development and bring up your enviroment.
#
# @autor Florian Blasel
# @version 2.5.0
#
###
#
# README FIRST:
#
# Requirements:
# bash ± 5.1.* (lower versions not tested, probably it will work nowadays)
#
# What this script does:
# It is an interactiv script which shows you a menu to select tasks where you
# can create your enviroment until some daily bussiness tasks you may need if
# you dont know all the special shell commands.
#
# Install:
# PUT this script to your PATH or create a symlink of this file to your PATH
# and make it executable (chmod +x ./DIPA.sh) Otherwise call it like:
# `bash /path/to/DIPA.sh` or just `./DIPA.sh`. Other calls like from `zsh` or
# `sh ./DIPA.sh` may fail if you use a different interactiv shell than `bash`
# as your default shell. E.g.: `zsh` is very pupular because of it's power for
# simple things inside but its another script dialect which causes this script
# to fail in some details.
#
# When using the "setup"/ "configure this script" task to setup this program
# (will asking you some questions) it stores the config at the real location of
# this script (if a symlink) to `.DIPAS.sh.config`. Every time you use this tool
# it loads this config (if exists) so that you dont need to care anymore.
# Otherwise our default settings will take affect. No futher requests will be
# made (in most cases).
#
# Happy Development! See or hear from you from the know channels... ;)
#
# Hint: Enable 'fold'ing in you vimrc for improved reading of this file.
### }}}

# its: ANSI Regular & Hand Made & (c) Florian Blasel
BANNER_INTRO_PRE=$(
    cat <<'BANNER_INTRO'

              ███████████████████████████████████████████
              █                                         █
              █                                         █
                                                        █
    ██████   ██  ██████   █████      ███████  ██   ██   █
    ██   ██  ██  ██   ██ ██   ██     ██       ██   ██   █
    ██   ██  ██  ██████  ███████     ███████  ███████   █
    ██   ██  ██  ██      ██   ██          ██  ██   ██   █
    ██████   ██  ██      ██   ██  █  ███████  ██   ██   █
                                                        █
              █          VERSION_STRING   █
              █    ██████████████████████████████████████
              █   █
              █  █     Digitales Partizipationssystem
              █ █      DIPAS - dipas.org
              ██       Hamburg / Germany
              █
        (D)eep (I)nstall and (P)roject (A)ssistant (Sh)ellscript
        For devlopment tasks: DIPA.sh

BANNER_INTRO
);

# {{{ Script basics

DEBUG=0;
# Using Semver but for visual reasons: no two chars lenght of major, minor,
# bugfix version: Just N.N.N, where N means only 1 digit!
VERSION='2.5.0';
VERSION_STRING="DIPA.sh - Mode Version ${VERSION}";


# set -x enables a mode of the shell where all executed commands are printed
# to the terminal. In your case it's clearly used for debugging, which is a
# typical use case for set -x: printing every command as it is executed may
# help you to visualize the control flow of the script if it is not functioning
# as expected. set +x disables it. E.g: [ "$DEBUG" = 'true' ] && set -x
if [ $DEBUG = 1 ]; then set -x; else set +x; fi;

SCRIPT_DIRECTORY_REAL="$(dirname "$(readlink -f "$0")")";
SCRIPT_FILENAME=$(basename "$0");

if [ -z "$BASH" ]; then
   echo "Please run this script '$0' with bash";
   echo "Call it like './${SCRIPT_FILENAME}' or 'bash ${SCRIPT_FILENAME}";
   exit 1;
fi

# End Script basics }}}


# {{{ General functions

# Color functions
# 'ct_' prefix = color text
# 'ctb_' prefix = color text bright
# 'cb_' prefix = text color background
#
# Options and example:
# E.g: echo -e "my text $(ct_red "red mark") to know..."
function ct_black() { echo -e "\033[30m$1\033[0m"; }
function ct_red()   { echo -e "\033[31m$1\033[0m"; }
function ct_green() { echo -e "\033[32m$1\033[0m"; }
function ct_yellow(){ echo -e "\033[33m$1\033[0m"; } # mostly dark orange, mark_warn()
function ct_blue()  { echo -e "\033[34m$1\033[0m"; }
function ct_purple(){ echo -e "\033[35m$1\033[0m"; }
function ct_cyan()  { echo -e "\033[36m$1\033[0m"; }
function ct_grey()  { echo -e "\033[37m$1\033[0m"; }
function ct_white() { echo -e "\033[38m$1\033[0m"; }

function ctb_black() { echo -e "\033[90m$1\033[0m"; }
function ctb_red()   { echo -e "\033[91m$1\033[0m"; }
function ctb_green() { echo -e "\033[92m$1\033[0m"; }
function ctb_yellow(){ echo -e "\033[93m$1\033[0m"; }
function ctb_blue()  { echo -e "\033[94m$1\033[0m"; }
function ctb_purple(){ echo -e "\033[95m$1\033[0m"; }
function ctb_cyan()  { echo -e "\033[96m$1\033[0m"; }
function ctb_grey()  { echo -e "\033[97m$1\033[0m"; }
function ctb_white() { echo -e "\033[98m$1\033[0m"; }
# color helpers: marker/icons
function mark_ok()   { echo -e "$(ctb_green "\xE2\x9C\x94")"; }
function mark_fail() { echo -e "$(ctb_red "\xE2\x9C\x96")"; }
# color helpers: text
function txt_ok()   { echo -e "$(ct_green "$1")"; }
function txt_warn()  { echo -e "$(ct_yellow "$1")"; }
function txt_err()   { echo -e "$(ctb_red "$1")"; }


# trim string
# @param string $1 Input string to be trimmed
function trim() {
   echo "$1" | xargs;
}

# confirm command.
# confirm means: do the next thing and this is return code 0
# only 'Y', 'n' or 'N' possible.
# $1 string Request message
# returns 0 for "yes confirm the request", 1 for 'do (n)otting'/ else case
function confirmCommand() {
    local opts="y/N";
    local defstr="" def="";
    # if [ "$2" != "" ]; then
    #     def="${2:0:1}";
    #     defstr=" (def:${2:0:1})";
    # fi

    while true; do
        read -r -n 1 -p "${1:-Continue?} [$opts]$defstr: " ANSWER
        case $ANSWER in
            # '')
            #     return 1; # 1 do nothing
            #     ;;
            [nN])
                echo; return 1; # 1 = do nothing/ else case
                ;;
            [jJyY])
                echo; return 0; # 0 = confirmed/ do something
                ;;
            *)
                txt_warn "Invalid input. One of $opts. (yYjJ=Yes, nN=No, def=No)";
        esac
    done
}


# The regular bash eval works by jamming all its arguments into a string then
# evaluating the string. This function treats its arguments as individual
# arguments to be passed to the command being run.
# https://stackoverflow.com/a/39458935
function eval_command() {
  "$@";
}

# @param string $1 Command to be checked
function checkCommandAvailable() {

    if ! command -v "$1" &> /dev/null; then
        txt_warn "Command '$1' not available.";
        return 1;
    fi

    return 0;
}


# Shows a help item. Format template
# $1 string menu item index
# $2 string menu item subject/headline
# $3 string menu item help message
function menuhelpitem() {
    echo
    echo "---"
    echo "Help: $2 (1 $1)";
    echo "Description:";
    echo
    echo "$3";
}

# Help menu
# $1 = second param (123) eg from '1 123' for a concrete help menu entry
#      (if exists, available)
function menuhelp () {
    tput reset;
    local txt="";
    local txtbanner="${BANNER_INTRO}";
    local ln=$((ln+$(($(echo "${BANNER_INTRO}" | wc -l)+1))));
    local l=$(($(tput lines)+0));


    if [ "$1" = "" ]; then
        # txt+="${BANNER_INTRO}";
        # { } | less -R
        #echo "Menu  : '${MENU_NAM[1]}'";
        #echo "Action: '${MENU_KEY[1]}'";
        #echo "---";

        # general help info
        txt+="---\n"
        txt+="Help: General help.\n"
        txt+="Description:\n"
        txt+="\n"
        txt+="Enter: '1' for this help. Enter: '1 <num>' for help of menu number <num>.\n"
        txt+="E.g: '1 123<enter>\n"
        txt+="\n"
        txt+="If the help text is longer than your terminal, then you can scroll up/down.\n";
        txt+=" - Search in the text, enter: /keyword<enter>\n";
        txt+=" - Press Ecs to leave search\n";
        txt+=" - Press 'q' to quit and come back to menu\n";
        txt+="\n"

        # list of help topics
        txt+="Available help topics:\n";
        txt+="<1 num>\tHlp Name\n";
        for key in "${!MENU_NAM[@]}"; do
            if [ "${MENU_HLP[$key]}" != "" ]; then
                # txt+=$(printf '1 %s\\t%s  %s\\n' "$key" "$(mark_ok) " "${MENU_NAM[$key]}");
                txt+="1 $key\t$(mark_ok) ${MENU_NAM[$key]}\n";
            else
                # txt+=$(printf '1 -\\t%s  %s\\n' "$(mark_fail) " "${MENU_NAM[$key]}");
                txt+="1 -\t$(mark_fail) ${MENU_NAM[$key]}\n";
            fi
        done

    elif [ "${MENU_HLP[$1]}" ]; then
        txt+=$(menuhelpitem "$1" "${MENU_NAM[$1]}" "${MENU_HLP[$1]}");
    else
        txt+=$(menuhelpitem "$1" "${MENU_NAM[$1]}" "$(txt_err "Sry. Help for menu '$1' not exists")");
    fi

    ln=$((ln+$(echo -e "$txt" | wc -l)));
    if [ $ln -gt $l ]; then
        { echo "$txtbanner";
        echo -e "$txt"; } | less -R
    else
        echo "$txtbanner";
        echo -e "$txt";
    fi
}


# End General functions }}}


# {{{ Promotion functions and variables for this program

BANNER_INTRO="${BANNER_INTRO_PRE/VERSION_STRING/${VERSION_STRING}}";

# End promotion }}}


# Custom program functions {{{

function do_exit() {
   echo
   echo "Have a good day! ;) Exiting...";
   echo

   exit;
}


# Check if DIPAS ROOT PATH exists
# @returns int 1=not exists/missing, 0=exists/ok
function do_checkDipasExists() {
    if [ ! -d "${DIPAS_BASE_ROOT_PATH}/" ]; then
        echo
        ctb_yellow "DIPAS project seems to be not installed.";
        return 1;
    else
        return 0;
    fi
}


# @param string $1 optional action to pipe in
function goto_containerPhp_do() {
   if [ "$1" = "" ]; then
      docker exec -it dipas_php /bin/bash
   else
      docker exec -it dipas_php /bin/bash -c "$1"
   fi
}


# @param string $1 optional action to pipe in
function goto_containerVue_do() {
   if [ "$1" = "" ]; then
      docker exec -it dipas_vue /bin/bash
   else
      docker exec -it dipas_vue /bin/bash -c "$1"
   fi

}


# @param string $1 optional action to pipe in
function goto_containerDb_do() {
    if [ "$1" = "" ]; then
        docker exec -it dipas_postgres /bin/bash
    else
        docker exec -it dipas_postgres /bin/bash -c "$1"
    fi
}

# containerVueRunLint
function do_codeCSCheck() {
    echo "Run Vue lint + CS checks...";
    goto_containerVue_do "npm run lint";

    txt_warn "Run PHP lint + CS checks... not implemented :-(";
    #goto_containerPhp_do "cd /app/htdocs/drupal/tests; ./runCSCheck.sh";
}

# containerVueRunLintFix
function do_codeCSFix() {
    echo "Run Vue lint + CS fixes...";
    goto_containerVue_do 'npm run lint:fix';

    txt_warn "Run PHP lint + CS fixes... not implemented :-(";
    #goto_containerPhp_do "cd /app/htdocs/drupal/tests; ./runCSFix.sh";
}


function do_codeTestAll() {
    # do_testEnviroment
    do_codeTestJsVue
    do_codeTestPhp
}

# containerVueRunTest
function do_codeTestJsVue() {
    echo "Run Js/Vue tests...";
    goto_containerVue_do 'npm run test:unit';
}


function do_codeTestPhp() {
    txt_warn "Run PHP tests... not implemented :-(";
    #goto_containerPhp_do "cd /app/htdocs/drupal/tests; ./runTests.sh";
}


# containerDatabaseImport
function do_dbImport() {

    do_checkDipasExists || return 1;
    do_dockerServicesCheck || return 2;

    echo "Check if '${DIPAS_DB_DUMP_SUBPATH}/' exists...";
    if [ ! -d "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/" ]; then
        mkdir "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/" || \
            txt_warn "Error creating '${DIPAS_DB_DUMP_SUBPATH}'. Check permissions. Abort" && return 1;
    fi

    local _IMPORT_FILE="${DIPAS_DB_DUMP_IMPORT}";
    local check=0;

    echo
    echo "Import file from path 'DIPAS_ROOT/${DIPAS_DB_DUMP_SUBPATH}/':";

    if [ ! -f "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/${DIPAS_DB_DUMP_IMPORT}" ]; then
        txt_warn "Default: '${DIPAS_DB_DUMP_IMPORT}' not found. A selection is required!";
        _IMPORT_FILE="";
    fi

    echo
    echo "Possible files (sql|gz dump files):";
    echo '---';
    cd "${DIPAS_DB_DUMP_SUBPATH}" || return 3;
    ls *.{gz,sql} 2> /dev/null;
    cd "${DIPAS_BASE_ROOT_PATH}" || return 4;
    echo '---';

    if [ -n "${_IMPORT_FILE}" ]; then
        echo "Enter file to import (or press <enter> to use: '${_IMPORT_FILE}'): ";
    else
        echo "Enter file to import: ";
    fi
    read IMPORT_FILE;
    IMPORT_FILE=${IMPORT_FILE:-$_IMPORT_FILE};

    #echo "imp file: '${IMPORT_FILE}'";
    if [ ! -f "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/${IMPORT_FILE}" ]; then
        txt_warn "File '${IMPORT_FILE}' not found. Abort";

        return 5;
    else
        # handle import

        local fext="${IMPORT_FILE##*\.}";
        local dbDumpFile="${DIPAS_DB_DUMP_SUBPATH}/${IMPORT_FILE}";

        # go to container and execute checks and commands

        # Progress variant (pv)
        # goto_containerPhp_do "if [ ! command -v pv &> /dev/null ]; then
        #     echo \"'pv' command not available. Pls use a different import.\";
        #     exit 1;
        #     fi
        # ";
        local checkPVAvailable="command -v pv >/dev/null 2>&1 \
            || { echo >&2 \"Ooops missing...\"; exit 1; }";
        if ! goto_containerPhp_do "$checkPVAvailable"; then
            txt_warn "Command 'pv' not available. Cannot import. Abort";
            return 6;
        fi

        # drop db first
        goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} \
            && psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME} < /root/dropdb.sql > /dev/null 2>&1
        ";

        if [ "${fext}" = "gz" ] || [ "${fext}" = "tgz" ] ; then
            echo 'Import gz dump. Please wait...';
            goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} \
                && pv --progress --name 'DB Import progress' -tea \"${dbDumpFile}\" \
                | zcat \
                | psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME}  > /dev/null 2>&1
            ";

        elif [ "${fext}" = "sql" ] ; then
            echo 'Import sql dump. Please wait...';
            goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} && \
                pv --progress --name 'DB Import progress' -tea \"${dbDumpFile}\" \
                | psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME} > /dev/null 2>&1
            ";
        else
            echo "Dont know to handle the input file  '${dbDumpFile}'. Missing extension (gz|tgz|sql)";

            return 6;
        fi

        echo
        echo "$(mark_ok) Import of '${dbDumpFile}' complete";
    fi

    return $check;
}


# extended containerDatabaseImport
function do_dbImport_extended() {

    do_dbImport || return $?;

    echo "Runs: 'composer install' to bind dependencies (if changed)...";
    goto_containerPhp_do "cd /app/htdocs; composer install";

    echo "Runs: 'drush ucrt admin' ...";
    goto_containerPhp_do "cd /app/htdocs; \
        php -d memory_limit=512M ./vendor/bin/drush ucrt admin > /dev/null";

    echo "Runs: 'drush upwd admin admin' ...";
    goto_containerPhp_do "cd /app/htdocs; \
        php -d memory_limit=512M ./vendor/bin/drush upwd admin admin > /dev/null";

    echo "Runs: 'drush urol siteadmin admin'...";
    goto_containerPhp_do "cd /app/htdocs; \
        php -d memory_limit=512M ./vendor/bin/drush urol siteadmin admin > /dev/null";

    echo -e "$(mark_ok) Drupal credentials done! Login with admin/admin";

    # bring up the rest...
    echo "Runs: 'drush cim -y' ...";
    goto_containerPhp_do "cd /app/htdocs; \
        php -d memory_limit=512M ./vendor/bin/drush cim -y";

    echo "Runs: 'drush cim -y' to veryfiy...";
    goto_containerPhp_do "cd /app/htdocs; \
        php -d memory_limit=512M ./vendor/bin/drush cim -y";

    echo "Runs: 'drush cr' (Rebuild all caches)...";
    goto_containerPhp_do "cd /app/htdocs; \
        php -d memory_limit=512M ./vendor/bin/drush cr";

    echo "Runs: 'drush en dipas_dev' enable dipas dev module...";
    goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush en dipas_dev";

    echo "Runs: 'drush locale:import de /app/config/de.po' import de.po file...";
    goto_containerPhp_do "cd /app/htdocs; \
        php -d memory_limit=512M ./vendor/bin/drush locale:import de /app/config/de.po";

    echo "Runs: 'drush en dipas_statistics' enable dipas statistics module...";
    goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush en dipas_statistics";

    echo "Runs: 'drush dipas-dev:fix-domain-entries' Fix domain entrys for development...";
    goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush dipas-dev:fix-domain-entries --port=8080";
}


# extended containerDatabaseExport
function do_dbExport() {
    do_checkDipasExists || return 1;
    do_dockerServicesCheck || return 2;

    # dipas root dir as base path, then:
    local dmp="${DIPAS_DB_DUMP_SUBPATH}/${DIPAS_DB_DUMP_EXPORT}";
    local fext="${DIPAS_DB_DUMP_EXPORT##*\.}";

    echo
    echo "Export DB...";

    if [ "${fext}" = "gz" ] || [ "${fext}" = "tgz" ] ; then
        echo 'Export gz sql dump. Please wait...';
        goto_containerPhp_do "PGPASSWORD=${DIPAS_DB_PASSWORD} \
            pg_dump --username ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} ${DIPAS_DB_NAME} \
            | pv --progress -N dumpfile -tea | gzip -9 > ${dmp}
        ";

    elif [ "${fext}" = "sql" ] ; then
        echo 'Export sql dump. Please wait...';
        goto_containerPhp_do "PGPASSWORD=${DIPAS_DB_PASSWORD} \
            pg_dump --username ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} ${DIPAS_DB_NAME} \
            | pv --progress -N dumpfile -tea > ${dmp}
        ";
    else
        txt_warn "Dont know to handle the export filename '${dmp}'. Check config";

        return 1;
    fi

    echo
    echo "$(mark_ok) Exported to '${DIPAS_BASE_ROOT_PATH}/${dmp}'"
}


# devEnvironmentCheckIfDockerIsRunning
# devEnvironmentCheckIfContainersExists
function do_dockerServicesCheck() {
    local check=0;
    do_dockerServiceCheckIsUp || check=1;
    do_dockerContainerCheckExists  || check=1;

    return $check;
}


# devEnvironmentCheckIfDockerIsRunning
function do_dockerServiceCheckIsUp() {
    FILE=/var/run/docker.pid;
    if [ -f "$FILE" ]; then
        echo -e "$(mark_ok) Docker service is running";

        return 0;
    else
        echo -e "$(mark_fail) $(txt_warn "Docker service is NOT running")";
        echo -e "Please start the docker service with $(ct_grey 'sudo service docker start')";

        return 1;
    fi
}

# devEnvironmentCheckIfContainersExists
function do_dockerContainerCheckExists() {
    local check=0;
    #  php
    if [ "$( docker container inspect -f '{{.State.Running}}' dipas_php )" = "true" ]; then
        echo -e "$(mark_ok) PHP Container is running";
    else
        echo -e "$(mark_fail) $(txt_warn "PHP Container is not running")";
        check=1;
    fi
    # apache
    if [ "$( docker container inspect -f '{{.State.Running}}' dipas_apache )" = "true" ]; then
        echo -e "$(mark_ok) Apache Container is running";
    else
        echo -e "$(mark_fail) $(txt_warn "Apache Container is not running")";
        check=1;
    fi
    # DB
    if [ "$( docker container inspect -f '{{.State.Running}}' dipas_postgres )" = "true" ]; then
        echo -e "$(mark_ok) Postgres Container is running";
    else
        echo -e "$(mark_fail) $(txt_warn Postgres Container is not running)";
        check=1;
    fi
    # DB PGADMIN
    if [ "$( docker container inspect -f '{{.State.Running}}' dipas_pgadmin )" = "true" ]; then
        echo -e "$(mark_ok) PG Admin Container is running"
    else
        echo -e "$(mark_fail) $(txt_warn "PG Admin Container is not running")";
        check=1;
    fi
    # FRONTEND DIPAS
    if [ "$( docker container inspect -f '{{.State.Running}}' dipas_vue )" = "true" ]; then
        echo -e "$(mark_ok) DIPAS Frontend Container is running";
    else
        echo -e "$(mark_fail) $(txt_warn "DIPAS Frontend Container is not running")";
        check=1;
    fi
    # nginx proxy
    if [ "$( docker container inspect -f '{{.State.Running}}' dipas_glue_nginx )" = "true" ]; then
        echo -e "$(mark_ok) DIPAS Proxy Container is running";
    else
        echo -e "$(mark_fail) $(txt_warn "DIPAS Proxy Container is not running")";
        check=1;
    fi

    return $check;
}

# dockerComposeRestart
function do_dockerContainerRestart() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }

    echo "Stop containers...";
    docker-compose down 2> /dev/null;
    echo "Start containers...";
    docker-compose up --detach;
}

# dockerComposeStart
function do_dockerContainerStart() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }

    echo "Start containers...";
    docker-compose up --detach;
}

# dockerComposeStop
function do_dockerContainerStop() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }

    echo "Stop containers...";
    docker-compose down
}


# dockerBuildContainer
function do_dockerContainerBuild() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }
    echo "Building containers. This may take some time...";
    docker-compose build --no-cache
}


function do_setupConfig() {
   # global variables to ask for:
   # see menu help info

    #local check=0;
    local failmesg="Required value. Please install it. Abort!";

    checkCommandAvailable "git" || { txt_err "$failmesg"; return 1; }

    declare -A PRG_GLOBALS
    # ignore the order of entrys here.
    PRG_GLOBALS=(
        [DIPAS_BASE_ROOT_PATH]="$DIPAS_BASE_ROOT_PATH"
        [DIPAS_DB_DUMP_SUBPATH]="$DIPAS_DB_DUMP_SUBPATH"

        [DIPAS_DB_NAME]="$DIPAS_DB_NAME"
        [DIPAS_DB_HOST]="$DIPAS_DB_HOST"
        [DIPAS_DB_USERNAME]="$DIPAS_DB_USERNAME"
        [DIPAS_DB_PASSWORD]="$DIPAS_DB_PASSWORD"
        [DIPAS_DB_DUMP_IMPORT]="$DIPAS_DB_DUMP_IMPORT"
        [DIPAS_DB_DUMP_EXPORT]="$DIPAS_DB_DUMP_EXPORT"

        [DIPAS_REPO_DOCKER_URL]="$DIPAS_REPO_DOCKER_URL"
        [DIPAS_REPO_DOCKER_BRANCH]="$DIPAS_REPO_DOCKER_BRANCH"
        [DIPAS_REPO_DOCKER_BRANCHDEFAULT]="$DIPAS_REPO_DOCKER_BRANCHDEFAULT"
        [DIPAS_REPO_DIPAS_URL]="$DIPAS_REPO_DIPAS_URL"
        [DIPAS_REPO_DIPAS_BRANCH]="$DIPAS_REPO_DIPAS_BRANCH"
        [DIPAS_REPO_DIPAS_BRANCHDEFAULT]="$DIPAS_REPO_DIPAS_BRANCHDEFAULT"
        [DIPAS_REPO_USERNAME]="$DIPAS_REPO_USERNAME"
    );

    ### bash 4.0 and a sort(1) with -z
    ## Sort a little better to request changes
    #
    local prg_sorted=()
    while IFS= read -rd '' key; do
        prg_sorted+=( "$key" )
    done < <(printf '%s\0' "${!PRG_GLOBALS[@]}" | sort -z)
    # for key in "${prg_sorted[@]}"; do
    #     printf '%s \t\t\t %s\n' "$key" "${PRG_GLOBALS[$key]}"
    # done

    #for itemKey in "${!PRG_GLOBALS[@]}"; do
    for itemKey in "${prg_sorted[@]}"; do
        echo
        echo "Config: '$(ct_yellow "$itemKey")' = '$(ct_green "${PRG_GLOBALS[$itemKey]}")'";
        echo -n "Enter new value or <enter> for no change: ";
        read TMP_VAR;

        eval "${itemKey}=\"${TMP_VAR:-${PRG_GLOBALS[$itemKey]}}\"";
    done

    echo
    echo "---";
    if confirmCommand "Save the config to be used from now on?"; then

        typeset -p "${prg_sorted[@]}" > "${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.config";

        echo
        echo "$(mark_ok) Config saved to:";
        echo "  '${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.config'";
        echo
        echo "This config will be used from now on.";
    else
        echo
        txt_warn "Config not saved but changes are now activ!...";
        echo "...until you exit the program or choose 'setup' again from";
        echo "menu to change the values.";
    fi
    # if changed, cd to
    cd "$DIPAS_BASE_ROOT_PATH";
}


 # delete config and exit on success
function do_setupReset() {
    if [ -f "${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.config" ]; then
        echo
        if confirmCommand "Please confirm removing your custom config"; then
            rm "${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.config";
            echo
            echo "$(mark_ok) Setup/ custom config '.DIPA.sh.config' was removed.";
            echo "  Please start this script again.";
            do_exit;
        else
            echo
            echo "Skipping...";
        fi
    else
        echo
        txt_warn "No config found for a reset."
        echo "Everything is fine at our side. Using default config values.";
    fi
}

######### TODO
### still in todo with real DB
# devEnvironmentCreate
function do_installDipas() {

    checkCommandAvailable "git"

    # ?? for complet purge and reinstall? Good idea? no|yes ?
    # rm ~/projects/DIPAS/*
    echo
    if do_checkDipasExists ;then
        ctb_yellow "DIPAS installation exists.";
        txt_warn "DANGER: This asks you to delete all existing code.";
        echo "This is not a good idea if you haven't checked if you still";
        echo "have some open branches or some git stashes you may need later.";
        echo
        txt_warn "Please check carefully branches and stashes before you go on.";
        echo "Path: '${DIPAS_BASE_ROOT_PATH}'";
        echo
        txt_warn "DELETE ALL OF THE CODE? There is no undo!";

        if confirmCommand "Please confirm"; then
            # confirmed (0): y selected...
            echo -n "Will delete existing code now... ";
            rm "${DIPAS_BASE_ROOT_PATH}/*"; # TODO this fails probably: -rf missing
            echo "Done!";
        else
            echo "Skip deletion of code";
        fi
    else
        echo "Good, we can go on...";
    fi

    echo
    echo "Installing DIPAS code and enviroment configs to '${DIPAS_BASE_ROOT_PATH}'. ";
    confirmCommand "Please confirm" || {
        echo "Return to menu...";
        return 0; # return to menu;
    }

    echo -n "Creating DIPAS ROOT PATH '${DIPAS_BASE_ROOT_PATH}'... ";
    if ! mkdir -p "${DIPAS_BASE_ROOT_PATH}"; then
        txt_err "Error creating the path. Check permissions. Abort";

        return 1;
    fi
    echo "Done";

    cd "${DIPAS_BASE_ROOT_PATH}" || {
        echo "Failed to cd '${DIPAS_BASE_ROOT_PATH}' path. Abort";

        return 2;
    }

    echo -n "Creating a share/transfer directory for data i/o eg. db dumps... ";
    if ! mkdir -p "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}"; then
        txt_err "Error creating the directory. Check permissions. Abort";

        return 3;
    fi
    echo "Done";

    ### Get code

    # repo docker

    if [ -d "${DIPAS_BASE_ROOT_PATH}/docker/.git" ]; then
        txt_warn "Not cloning 'docker' repo. Already exists.";
    else
        local urlDocker="${DIPAS_REPO_DOCKER_URL/UNKNOWN@/${DIPAS_REPO_USERNAME}}";
        echo "Cloning docker repo from '${urlDocker}'...";
        if ! git clone "${urlDocker}" docker; then
            txt_err "Error cloning url. Check url or permissions. Abort";

            return 4;
        fi

        cd docker || {
            txt_warn "Clon repo failed? Check url or permissions. Abort";

            return 5;
        };

        echo "Checkout branch '${DIPAS_REPO_DOCKER_BRANCH:-${DIPAS_REPO_DOCKER_BRANCHDEFAULT}}'";
        git checkout "${DIPAS_REPO_DOCKER_BRANCH:-${DIPAS_REPO_DOCKER_BRANCHDEFAULT}}";
    fi

    # end repo docker

    cd "${DIPAS_BASE_ROOT_PATH}" || {
        txt_warn "Error changing to path '${DIPAS_BASE_ROOT_PATH}'. Please check. Abort";
        # other process in the background? permisions problem? This should not happen.
        return 6;
    };

    ## repo dipas

    if [ -d "${DIPAS_BASE_ROOT_PATH}/repository/.git" ]; then
        txt_warn "Not cloning DIPAS code repo. Already exists.";
    else
        local urlDipas="${DIPAS_REPO_DIPAS_URL/UNKNOWN@/${DIPAS_REPO_USERNAME:-""}}";
        echo "Cloning the DIPAS repository from '${urlDipas}'...";
        if ! git clone "${urlDipas}" repository; then
            txt_err "Error cloning url. Check url or permissions. Abort";

            return 7;
        fi

        cd repository || {
            txt_warn "Error changing to path './repository'. Please check. Abort";
            # other process in the background? permisions problem? This should not happen.

            return 8;
        };
        echo "Checkout branch '${DIPAS_REPO_DIPAS_BRANCH:-${DIPAS_REPO_DIPAS_BRANCHDEFAULT}}'";
        git checkout "${DIPAS_REPO_DIPAS_BRANCH:-${DIPAS_REPO_DIPAS_BRANCHDEFAULT}}";
    fi
    # end repo dipas

    cd "${DIPAS_BASE_ROOT_PATH}" || {
        txt_warn "Error changing to path '${DIPAS_BASE_ROOT_PATH}'. Please check. Abort";
        # other process in the background? permisions problem? This should not happen.

        return 9;
    };

    echo
    echo "$(mark_ok) The code loaded and prepared now.";
    echo

    local TEXT_FINISHING=$(
        cat <<'BANNER_INTRO'
General or first install:

1. get repos/ code in place
2. build the docker container (see menu)
3. start the containers (see menu)
4. Configure drupal settings (check docs)
    4.1. Import a database or follow the docs e.g 'INSTALL.md')
    4.2. and run update tasks (see menu:'DB Import + BE upds')

Most of them are already in the menu available.

BANNER_INTRO
);

    echo "${TEXT_FINISHING}";
    echo
    echo "If you have access to 'sudo' command and if you are already in the";
    echo "group 'docker' you can go on to build the docker containers now.";
    echo

    if confirmCommand "Start build process for the docker containers?"; then

        if ! do_dockerContainerBuild; then
            echo
            txt_err "Build error. Check output carefully.";
        else
            echo
            if ! do_dockerContainerStart; then
                echo
                echo "$(mark_fail) Starting containers failed.";
                echo "Check output carefully. Check build and docker configs";
            else
                echo
                echo "${TEXT_FINISHING}";
                echo
                echo "1. $(mark_ok) The code is prepared now.";
                echo "2. $(mark_ok) Build done. The environment is prepared now."
                echo "3. $(mark_ok) Containers are started."
            fi
        fi
    fi
    echo

    #
    # TODO is this internal or is it a public case?
    #

    # 1. get repos/ code in place                           done
    # 2. build the docker container (see menu)              done
    # 3. start the containers (see menu)                    done
    # 4. Configure drupal settings (check docs)
    #       cp htdocs/vue/.env.example htdocs/vue/.env ?
    #       run composer install ?
    # db auth?
    # import db extended
    # fix db auth

    echo "Copy htdocs/vue/.env.example -> htdocs/vue/.env";
    cp "${DIPAS_BASE_ROOT_PATH}/repository/htdocs/vue/.env.example" \
        "${DIPAS_BASE_ROOT_PATH}/repository/htdocs/vue/.env";

    cd "${DIPAS_BASE_ROOT_PATH}/repository/htdocs/drupal/sites/default/" || {
        txt_warn "cd to a path failed";
    };

    if [ -f "settings.local.php" ] && [ -f "services.local.yml" ];then
        echo "Drupal configs already set: 'settings.local.php', 'services.local.yml'";
    else
        cp example.settings.local.php settings.local.php
        cp example.services.local.yml services.local.yml

        echo "drupal configs are copied: 'settings.local.php' and 'services.local.yml'";
    fi
    echo "Please edit db or proxy setting in 'settings.local.php'";
    if confirmCommand "Confirm 'settings.local.php' is set correctly"; then
        echo 'Yes selected... you checked the files already!';

        echo "With a verfied 'settings.local.php', php/drupal/vue dependencies";
        echo "can be installed now (composer install)";
        echo "This will also drop the db and installs the default site and resets";
        echo "the admin user to admin/admin";
        if confirmCommand "Run 'composer install'?"; then
            goto_containerPhp_do "cd /app/htdocs; composer install";
            # todo correct?
            #goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush site:install -y";
            # todo correct?
            #goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush upwd admin admin";
        else
            echo "Skip 'composer install'";
        fi
    else
        txt_warn 'No selected. Skip...';
    fi
    echo
    echo "Make sure the configs are verified before using drupal!";

    cd "${DIPAS_BASE_ROOT_PATH}" || txt_warn "cd to root path failed";

    echo
    echo "$(mark_ok) So far: 'SYS: Install DIPAS enviroment' done";
    echo
    echo "${TEXT_FINISHING}";

}


# End Custom program functions }}}


# {{{ Menu init
declare -a MENU_KEY
declare -a MENU_NAM
_IDX=0;
# End Menu init }}}


# {{{ Menu config

# Limits!: MENU_NAM MAX 30 chars!

((_IDX=_IDX+1)); # 1
MENU_NAM[_IDX]="Help"; # Dont do it in menu, like: ❓
MENU_KEY[_IDX]="exec:menuhelp";
MENU_HLP[_IDX]="General help info... and to show all help";

((_IDX=_IDX+1)); # 2
MENU_NAM[_IDX]="Exit or 'q' for quit";
MENU_KEY[_IDX]="exec:do_exit";
MENU_HLP[_IDX]="Exit the program
Press CTRL+C for 'exit' or select '$_IDX' from the menu";

((_IDX=_IDX+1)); # 3
MENU_NAM[_IDX]="Code: CS Check";
MENU_KEY[_IDX]="exec:do_codeCSCheck";
MENU_HLP[_IDX]="Run the coding style checks for all available parts (e.g: js/vue, php....)";

((_IDX=_IDX+1)); # 4
MENU_NAM[_IDX]="Code: CS Fix";
MENU_KEY[_IDX]="exec:do_codeCSFix";
MENU_HLP[_IDX]="Run the coding style fixer for all available parts (e.g: js/vue, php....)";

((_IDX=_IDX+1)); # 5
MENU_NAM[_IDX]="Code: Test (all)";
MENU_KEY[_IDX]="exec:do_codeTestAll";
MENU_HLP[_IDX]="Execute all available tests.
Currently only some Vue tests exists... more to come....";

((_IDX=_IDX+1)); # 6
MENU_NAM[_IDX]="Code: Test (Js/Vue)";
MENU_KEY[_IDX]="exec:do_codeTestJsVue";
MENU_HLP[_IDX]="Executes all available Js/Vue tests.";

((_IDX=_IDX+1)); # 7
MENU_NAM[_IDX]="Code: Test (php)";
MENU_KEY[_IDX]="exec:do_codeTestPhp";
MENU_HLP[_IDX]="Execute all available PHP/dupal tests.
$(txt_err "No tests available")";

((_IDX=_IDX+1)); # 8
MENU_NAM[_IDX]="Goto docker: PHP";
MENU_KEY[_IDX]="exec:goto_containerPhp_do";
MENU_HLP[_IDX]="Enter the php docker container to do individual actions e.g:
DB dumps, 'composer install' 'drush abc xyz' and so on....";

((_IDX=_IDX+1)); # 9
MENU_NAM[_IDX]="Goto docker: Vue";
MENU_KEY[_IDX]="exec:goto_containerVue_do";
MENU_HLP[_IDX]="Enter the Vue docker container to do individual actions e.g:
'npm run lint', 'npm run test:unit' or 'npm run lint:fix'...";

((_IDX=_IDX+1)); # 10
MENU_NAM[_IDX]="Goto docker: DB";
MENU_KEY[_IDX]="exec:goto_containerDb_do";
MENU_HLP[_IDX]="Enter the postgre database docker container to do individual actions";




# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="PHP: Drush Clear Cache";
# MENU_KEY[_IDX]="exec:containerPHPDrushClearCache";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="PHP: Drush Config Import";
# MENU_KEY[_IDX]="exec:containerPHPDrushConfigImport";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="PHP: Drush Apply DB Updates";
# MENU_KEY[_IDX]="exec:containerPHPDrushApplyDbUpdates";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="PHP: Drush Change Password";
# MENU_KEY[_IDX]="exec:containerPHPDrushUpdatePassword";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="PHP: Composer Install";
# MENU_KEY[_IDX]="exec:containerPHPComposerInstall";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="EDIT: Open VSCode";
# MENU_KEY[_IDX]="exec:editorOpenVSCode";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="EDIT: Open Codium";
# MENU_KEY[_IDX]="exec:editorOpenVSCodium";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="SYS: Check Outdated Packages";
# MENU_KEY[_IDX]="exec:devEnvironmentCheckOutdatedPackages";
# MENU_HLP[_IDX]="Checks if there are outdated packages. This is usful for upgrading the core
# software. Mostly a task for the product owners for a next release
# ";


((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: DB Import";
MENU_KEY[_IDX]="exec:do_dbImport";
MENU_HLP[_IDX]="This does only handle the database import of a sql dump file.
All further actions needs to be made by hand.";


((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: DB Import + BE upds";
MENU_KEY[_IDX]="exec:do_dbImport_extended";
MENU_HLP[_IDX]="Daily business:
You get a new DB. Import it and you want upgrading it to the latest changes of
the local 'drupal' installation to check for errors or for working on the
current (newer) code base.

This does the following actions:

- Checks if services are up to go on
- Request db file to import
- Resets db (backup before?)
- Imports the db file
- Runs: 'composer install' to bind php dependencies (if changed)

- Resets credential to the defaults: admin/admin
    - Runs: 'drush ucrt admin'
    - Runs: 'drush upwd admin admin'
    - Runs: 'drush urol siteadmin admin'

- Runs: 'drush cim -y' Imports configs from the config directory
- Runs: 'drush cim -y' To veryfiy prev. run
- Runs: 'drush updb -y' Apply any required db updates
- Runs: 'drush updb -y' To veryfiy prev. run
- Runs: 'drush cr' (Rebuild all caches)...
- Runs: 'drush en dipas_dev' enable dipas dev module
- Runs: 'drush locale:import de /app/config/de.po' Import the de.po file
- Runs: 'drush en dipas_statistics' Enables dipas statistics module
- Runs: 'drush dipas-dev:fix-domain-entries' Fixs local domain entrys for
        development

... more to come if needed
";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: DB Export";
MENU_KEY[_IDX]="exec:do_dbExport";
MENU_HLP[_IDX]="Export/ backup current dipas database.
It will be stored in 'DIPAS ROOT PATH/transfer/dipas-dump-export.sql' if you
dont change the default settings.
";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="SYS: DB Delete";
# MENU_KEY[_IDX]="exec:containerDatabaseDelete";
# MENU_HLP[_IDX]="";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Check services ON";
MENU_KEY[_IDX]="exec:do_dockerServicesCheck"
MENU_HLP[_IDX]="Checks if docker service is runing
and also if the docker containers exists and activ";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker containers restart";
MENU_KEY[_IDX]="exec:do_dockerContainerRestart";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker containers start";
MENU_KEY[_IDX]="exec:do_dockerContainerStart";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker containers stop";
MENU_KEY[_IDX]="exec:do_dockerContainerStop";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker containers build";
MENU_KEY[_IDX]="exec:do_dockerContainerBuild";


((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Install DIPAS enviroment";
MENU_KEY[_IDX]="exec:do_installDipas";
MENU_HLP[_IDX]="Install DIPAS from scratch.

Services/ docker container can be created, but:
Your user must be in group 'docker' and the system service must be already ON
or you have 'sudo' access to execute e.g: 'sudo service docker start'
";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="CFG: Setup custom config";
MENU_KEY[_IDX]="exec:do_setupConfig";
MENU_HLP[_IDX]="Show and change custom config values.

This 'Setup' will request some parameters to save them at a config file
(.DIPA.sh.config') for the usage of this program. If not exists our defaults
will be used. Eg: user and passwords for DB or locations where all the code,
reositories will be cloned and stored.

Make sure this script exists only once in your user account and you dont run
setup at the same time in e.g. two shells. Saving config may fail behinde the
scene: If another running instance of this program or any other program
modifies the config, it will be overwritten at this point, losing any previous
changes made by the other program(s).

To restore back to our defaults just remove this config file or select
'delete setup/ custom config' and start the script again.


# DIPAS root path for the installation e.g.: /home/${USER}/projects/DIPAS |
# '/www/dipas' (no tailing /)
DIPAS_BASE_ROOT_PATH

# Username to connect to the db
DIPAS_DB_USERNAME

# Users password for the connection
DIPAS_DB_PASSWORD

# Name of DIPAS database
DIPAS_DB_NAME

# Hostname or ip address to connect to the db server
DIPAS_DB_HOST

# Default db import/export filenames
DIPAS_DB_DUMP_IMPORT    dipas-dump-import.sql
DIPAS_DB_DUMP_EXPORT    dipas-dump-export.sql

# Subpath (after DIPAS ROOT PATH) for share data/files cross docker containers
DIPAS_DB_DUMP_SUBPATH   \"transfer\"

# Username on bitbucket to clone repos for the install process incl. the
# username for authentication at bitbucket. Optional (Use 'setup' to change
# if needed)
DIPAS_REPO_USERNAME

###
# Repos's: we have a 'docker' and the 'dipas' repositories.

# Don't replace UNKNOWN here! REPO_USERNAME will be used
DIPAS_REPO_DOCKER_URL   \"https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/docker_for_dipas.git\"

# Branch to checkout
DIPAS_REPO_DOCKER_BRANCH=\"DPS-1626-Base-Vue-Application-Cleanup\"
# DIPAS_REPO_DOCKER_BRANCHDEFAULT=\"dockerd9\" <- unknown,1st br to intro docker?
DIPAS_REPO_DOCKER_BRANCHDEFAULT=\"dev\"

# Don't replace UNKNOWN here! REPO_USERNAME will be used
DIPAS_REPO_DIPAS_URL=\"https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/dipas_community.git\";

# Branch to checkout.
DIPAS_REPO_DIPAS_BRANCH \"DPS-1626-Base-Vue-Application\"

# If checkout of branch fails. The default branch will be used:
DIPAS_REPO_DIPAS_BRANCHDEFAULT=\"dev\"
";
# end help text: CFG: Setup custom config


((_IDX=_IDX+1));
MENU_NAM[_IDX]="CFG: Delete setup custom config";
MENU_KEY[_IDX]="exec:do_setupReset";
MENU_HLP[_IDX]="This will delete your custom config '.DIPA.sh.config'
and exits the program.
Start DIPA.sh new and our default config values will be used.";


# End Menu config }}}


# {{{ Program default configs

DIPAS_BASE_ROOT_PATH="/home/${USER}/projects/DIPAS";
DIPAS_DB_NAME='dipas';
DIPAS_DB_HOST='database';
DIPAS_DB_USERNAME='dipas';
DIPAS_DB_PASSWORD='dipas';
# Import file extension can be .sql, .gz or .tgz
DIPAS_DB_DUMP_IMPORT='dipas-dump-import.sql.gz';
# Export file extension can be .sql, .gz or .tgz
DIPAS_DB_DUMP_EXPORT='dipas-dump-export.sql.gz';
DIPAS_DB_DUMP_SUBPATH="transfer";

# Don't replace UNKNOWN here! REPO_USERNAME will be used
DIPAS_REPO_DOCKER_URL="https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/docker_for_dipas.git"
DIPAS_REPO_DOCKER_BRANCH="DPS-1626-Base-Vue-Application-Cleanup"
DIPAS_REPO_DOCKER_BRANCHDEFAULT="dockerd9"

# Don't replace UNKNOWN here! REPO_USERNAME will be used
DIPAS_REPO_DIPAS_URL="https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/dipas_community.git";
DIPAS_REPO_DIPAS_BRANCH="DPS-1626-Base-Vue-Application";
DIPAS_REPO_DIPAS_BRANCHDEFAULT="dev";
# Username on bitbucket to clone repos for the install process. Optional
DIPAS_REPO_USERNAME="";

# source config if exists to overwrite prev. defaults
if [ -f "${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.config" ]; then
    # shellcheck source=/dev/null
    . "${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.config";
fi


# Program default/custom configs }}}


# {{{ Action handling start

#
# THESE SHOULD BE THE LAST CODE LINE IN THIS SCRIPT
#

tput reset;

# print banner once at startup
echo "${BANNER_INTRO}";


##
# program pre checks

echo
if ! do_checkDipasExists ;then
    txt_warn "Please run the 'setup' from menue to set some paths or";
    txt_warn "credentials (or our script defaults will be used).";
    echo
    txt_warn "Run 'install' from menu to install DIPAS and to hide this message.";
    echo
else
    # this script to be run at this path as default and always to not conflict in paths!
    cd "${DIPAS_BASE_ROOT_PATH}" || {
        txt_err "DIPAS exists but cd to the path failed exception...."; exit 1;
    };

    if [ ! -d "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}" ]; then
        # ownership (YOU) important to be writeable
        mkdir "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}";
    fi
fi
# end program pre checks



PS3="
--------------------------------------------------------------------------------
Press <enter> for menu, CTRL+C or 'q' for 'exit',
choose an action number: ";

# number of columns for the select stmt
#COLUMNS=120
select CURRENT_DIPASH_MENUENAME in "${MENU_NAM[@]}"
do
    export CURRENT_DIPASH_MENUENAME;

    # after a valid number, but menu above
    #echo "${BANNER}";

    # detect input
    #
    #current working but specials chars exit in error :-(
    # if [ "$REPLY" -gt 0 ] && [ "${MENU_KEY[$REPLY]}" != "" ]; then

    # trim input first
    REPLY="$(trim "$REPLY")";

    # Input can be '<int>' or '<int> <int>' eg for help menu in detail.
    MENU_INPUT_REGEX='^(([0-9])+|(([0-9]+ [0-9]+)$))$';
    MENU_INPUT_VALUE=$REPLY;
    if [[ $MENU_INPUT_VALUE =~ $MENU_INPUT_REGEX ]]
    then
        #echo "regex ok"
        #now check input...
        MENU_INPUT_VALUE_A=$(echo "$MENU_INPUT_VALUE" | cut -d ' ' -f 1)
        MENU_INPUT_VALUE_B=$(echo "$MENU_INPUT_VALUE" | cut -d ' ' -f 2)
        # if B not given it contains A, so clear it!
        if [ "$MENU_INPUT_VALUE_A" = "$MENU_INPUT_VALUE_B" ]; then
            MENU_INPUT_VALUE_B="";
        fi

        # echo
        # echo "$(ctb_purple "Name:") '${MENU_NAM[$MENU_INPUT_VALUE_A]}'";
        # echo "$(ctb_green "Call:") '${MENU_KEY[$MENU_INPUT_VALUE_A]}', id: '$MENU_INPUT_VALUE_A'";

        # Direct invocation: if key prefix is 'exec:' do an imperativ execution
        # https://stackoverflow.com/questions/85880/determine-if-a-function-exists-in-bash
        if [ "${MENU_KEY[$MENU_INPUT_VALUE_A]:0:5}" = "exec:" ]; then
            if [ "$(LC_ALL=C type -t "${MENU_KEY[$MENU_INPUT_VALUE_A]:5}")" ]; then
                # echo "Execute action: '${MENU_KEY[$MENU_INPUT_VALUE_A]:5}'";
                if [ "$MENU_INPUT_VALUE_B" = "" ]; then
                eval_command "${MENU_KEY[$MENU_INPUT_VALUE_A]:5}";
                else
                eval_command "${MENU_KEY[$MENU_INPUT_VALUE_A]:5}" "$MENU_INPUT_VALUE_B";
                fi
            else
                txt_err "Action not implemented: '${MENU_KEY[$MENU_INPUT_VALUE_A]}'";
            fi
        else
            txt_err "A direct call is not implemented.";
            txt_err "Missing 'exec:' prefix for '${MENU_KEY[$MENU_INPUT_VALUE_A]}'";
            txt_err "To do so implement a switch based on the action key";
        fi
    else
        # TODO: not the 'exec:'' case, so check if the selected menu key exists,
        # if special and needs to be implemented here in a switch case stmt ...
        # E.g: a "q" for quit

        case $REPLY in
        "q")
            do_exit
            ;;
        *)
            # All others which do not match
            echo "Ooops - Option '$REPLY' not implemented";
            break
            ;;
        esac

        # fallback if not break'ed before
        #echo "Ooops - Option '$REPLY' not exists";
        echo "Ooops - Option '$REPLY' not exists, exit"; break;
    fi

    # case $REPLY in
    #    1)
    #       echo "Selected itemVal #$REPLY means ${MENU_NAM[$REPLY]} '$itemVal'"
    #       ;;
    #    2)
    #       echo "Selected itemVal #$REPLY means '$itemVal'"
    #       ;;
    #    3)
    #       echo "Selected itemVal #$REPLY means '$itemVal'"
    #       ;;
    #    #4) echo "Selected itemVal #$REPLY means '$itemVal'";;
    #
    #    # if selection num > menu entrys: exit
    #    $((${#MENU_KEY[@]}+1)) )
    #       echo "Done! Exiting...";
    #       break;;
    #
    #    # $((${MENU_KEY[$REPLY]})) )
    #    #    echo x
    #    #    break;;
    #    #if [[ -n "${MENU_KEY[$REPLY]}" ]] then echo "$REPLY ${MENU_KEY[$REPLY]]} found"; fi
    #
    #    *)
    #       echo "Ooops - Option '$REPLY' not implemented, exit"; break;;
    # esac

done
# End Action handling start }}}


# vim: ts=4 sw=4 et
