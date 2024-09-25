#!/bin/bash

#
#              ███████████████████████████████████████████
#              █                                         █
#              █                                         █
#                                                        █
#    ██████   ██  ██████   █████      ███████  ██   ██   █
#    ██   ██  ██  ██   ██ ██   ██     ██       ██   ██   █
#    ██   ██  ██  ██████  ███████     ███████  ███████   █
#    ██   ██  ██  ██      ██   ██          ██  ██   ██   █
#    ██████   ██  ██      ██   ██  █  ███████  ██   ██   █
#                                                        █
#              █                                         █
#              █    ██████████████████████████████████████
#              █   █
#              █  █     Digitales Partizipationssystem
#              █ █      DIPAS - dipas.org
#              ██       Hamburg / Germany
#              █
#
#        [D]eep [I]nstall and [P]roject [A]ssistant [Sh]ellscript
#        For development tasks: DIPA.sh
#
################################################################################
# {{{ ### INTRO / README #######################################################
################################################################################
#
# DIPA.sh - [D]eep [I]nstall and [P]roject [A]ssistant [Sh]ellscript
#
# For the DIPAS - 'Digitales Partizipationssystem' project; Hamburg/ Germany
# [DIPAS](https://dipas.org)
#
# Project development and enviroment assistant.
#
# Inspired from the `dipas_toolkit.sh`, now a complete rewrite to improve
# maintainance, bash learning for some specific cases... here is one of the
# solutions for development and bring up your enviroment.
#
# @autor Florian Blasel
# @version 2.7.4
# @since 2024-01
#
#####
#
# README FIRST:
#
# Requirements:
# bash ± 5.1.* (lower versions not tested, probably it will work nowadays 2024+)
#
# What this script does:
# It is an interactiv bash script which shows you a menu to select tasks where
# you can create your enviroment until some daily bussiness tasks you may need
# if you dont know all the special shell commands.
#
# Install:
# PUT this script to your PATH or create a symlink of this file to your PATH
# and make it executable. Otherwise call it like:
# `bash /path/to/DIPA.sh` or just `./DIPA.sh`. Other calls like from `zsh` or
# `sh ./DIPA.sh` may fail if you use a different interactiv shell than `bash`
# as your default shell. E.g.: `zsh` is very pupular because of it's power for
# simple things inside but its another script dialect which causes this script
# to fail in some details.
#
# When using the "Setup custom config" task to setup this program (will asking
# you some questions about configuration variables) it stores the config at the
# real location of this script (if a symlink) to `.DIPAS.sh.config`. Every time
# you use this tool it loads this config (if exists) so that you dont need to
# care anymore.
# Otherwise the script default settings will take affect.
#
# Happy development and the usage of this script!
#
# Hint: Enable 'fold'ing in you vimrc for improved reading of this file.
# " Enable folding by fold markers
# set foldmethod=marker
# " Autoclose folds, when moving out of them
# set foldclose=all

### }}}


################################################################################
# {{{ ### Script basics ########################################################
################################################################################

DEBUG=0;
# Using Semver but for visual reasons: no two chars lenght of major, minor,
# bugfix versions: Just N.N.N, where N means only 1 digit!
VERSION='2.7.4';
VERSION_STRING="DIPA.sh - Mode Version ${VERSION}";


# set -x enables a mode of the shell where all executed commands are printed
# to the terminal. It's used for debugging, which is a typical use case for
# printing every command as it is executed as expected. set +x disables it.
if [ $DEBUG = 1 ]; then
    set -x;
else
    set +x;
fi;

SCRIPT_DIRECTORY_REAL="$(dirname "$(readlink -f "$0")")";
SCRIPT_FILENAME_REAL="$(basename "$(readlink -f "$0")")";
SCRIPT_FILENAME_CURRENT=$(basename "$0");

if [ -z "$BASH" ]; then
   echo "Please run this script '$0' with bash";
   echo "Call it like:"
   echo "   cd \"$SCRIPT_DIRECTORY_REAL\"";
   echo "   ./${SCRIPT_FILENAME_REAL}";
   echo "   # or from PATH";
   echo "   ${SCRIPT_FILENAME_CURRENT}";

   exit 1;
fi

USER="${USER:-$LOGNAME}";

# End Script basics }}}



################################################################################
# {{{ ### Script general functions #############################################
################################################################################

# Color functions
#
# Standard colors which nearly work on every shell.
#
# 'ct_' prefix = color text
# 'ctb_' prefix = color text bright/bold
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

function ctb_black() { echo -e "\033[90m$1\033[0m"; } # mostly grey
function ctb_red()   { echo -e "\033[91m$1\033[0m"; }
function ctb_green() { echo -e "\033[92m$1\033[0m"; }
function ctb_yellow(){ echo -e "\033[93m$1\033[0m"; }
function ctb_blue()  { echo -e "\033[94m$1\033[0m"; }
function ctb_purple(){ echo -e "\033[95m$1\033[0m"; }
function ctb_cyan()  { echo -e "\033[96m$1\033[0m"; }
function ctb_grey()  { echo -e "\033[97m$1\033[0m"; }
function ctb_white() { echo -e "\033[98m$1\033[0m"; }

# color helpers: text
function txt_ok()   { echo -e "$(ct_green "$1")"; }
function txt_warn()  { echo -e "$(ct_yellow "$1")"; }
function txt_err()   { echo -e "$(ctb_red "$1")"; }

# color helpers: marker/icons
function mark_ok()   { echo -e "$(ctb_green "\xE2\x9C\x94") "; }
function mark_fail() { echo -e "$(ctb_red "\xE2\x9C\x96") "; }


###
# trim string.
#
# @param string $1 Input string to be trimmed
function trim() {
   echo "$1" | xargs;
}


###
# confirm a command.
#
# confirm means: do the next thing and this returns code 0
# only 'YyjJ', 'nN' are possible.
#
# $1 string Request message
#
# returns 0 for "yes" to confirm the request", 1 for 'do (n)othing'/ else case
function confirmCommand() {
    local opts="y/N";
    local defstr=""
    # local def="";
    # if [ "$2" != "" ]; then
    #     def="${2:0:1}";
    #     defstr=" (def:${2:0:1})";
    # fi

    while true; do
        read -r -n 1 -p "${1:-Continue?} [$opts]$defstr: " ANSWER
        case $ANSWER in
            [nN])
                echo; return 1; # 1 = do nothing/ else case
                ;;
            [jJyY])
                echo; return 0; # 0 = confirmed/ do something
                ;;
            *)
                txt_warn "Invalid input. One of $opts. (yYjJ=Yes, nN=No)";
        esac
    done
}


###
# The regular bash eval works by jamming all its arguments into a string then
# evaluating the string. This function treats its arguments as individual
# arguments to be passed to the command being run.
# https://stackoverflow.com/a/39458935
function eval_command() {
    "$@";
}


###
# @param string $1 Command to be checked
function checkCommandAvailable() {
    if ! command -v "$1" &> /dev/null; then
        txt_warn "Command '$1' not available.";

        return 1;
    fi

    return 0;
}


###
# $1 int string Exit code
# $2 string Exit massage
function checkExitCode() {
    local code=$1;
    local mesg=$2;
    if [ "$code" -lt 129 ] && [ "$code" -gt 0 ] ; then
        txt_err "$code $mesg";

        return "$code";
    fi

    return 0;
}


###
# Shows a help item. Format template.
#
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


###
# Help menu.
#
# $1 = second param (123) eg from '1 123' for a concrete help menu entry
#      (if exists/ available)
function menuhelp () {
    tput reset;
    local txt="";
    local txtbanner="${BANNER_INTRO}";
    local ln=$((ln+$(($(echo "${BANNER_INTRO}" | wc -l)+1))));
    local l=$(($(tput lines)+0));

    if [ "$1" = "" ]; then
        txt+="---\n"
        txt+="Help: General help.\n"
        txt+="Description:\n"
        txt+="\n"
        txt+="Enter: '1' for this help. Enter: '1 <num>' for help of menu number <num>.\n"
        txt+="E.g: '1 123<enter>\n"
        txt+="\n"
        txt+="If the help text is longer than your terminal, then you can scroll up/down.\n";
        txt+=" - Search in the text, enter: /keyword<enter>\n";
        txt+=" - Press Esc to leave search\n";
        txt+=" - Press 'q' to quit and come back to menu\n";
        txt+="\n"

        txt+="Available help topics:\n";
        txt+="<1 num>\tHlp  Name\n";
        for key in "${!MENU_NAM[@]}"; do
            if [ "${MENU_HLP[$key]}" != "" ]; then
                txt+=" 1  $key\t$(mark_ok)   ${MENU_NAM[$key]}\n";
            else
                txt+=" 1  -\t$(mark_fail)   ${MENU_NAM[$key]}\n";
            fi
        done

    elif [ "${MENU_HLP[$1]}" ]; then
        txt+=$(menuhelpitem "$1" "${MENU_NAM[$1]}" "${MENU_HLP[$1]}");
    else
        txt+=$(menuhelpitem "$1" "${MENU_NAM[$1]}" "$(txt_err "Sry. Help for menu '$1' not exists")");
    fi

    ln=$((ln+$(echo -e "$txt" | wc -l)));
    if [ $ln -gt $l ]; then
        { echo -e "$txtbanner";
        echo -e "$txt"; } | less -R
    else
        echo -e "$txtbanner";
        echo -e "$txt";
    fi
}

# End Script general functions }}}



################################################################################
# {{{ ### YOUR program functions ###############################################
################################################################################

###
# do no operation
function do_noop() {
    return 0;
}


###
# Do exit the program.
function do_exit() {
   echo "$BANNER_OUTRO";
   echo

   exit;
}


###
# Check if DIPAS ROOT PATH exists.
#
# @returns int 1=not exists/missing, 0=exists/ok
function do_checkDipasExists() {
    if [ ! -d "${DIPAS_BASE_ROOT_PATH}/" ]; then
        echo
        ctb_yellow "DIPAS project seems to be NOT installed.";

        return 1;
    else
        return 0;
    fi
}


###
# @param string $1 optional action to pipe in
function goto_containerPhp_do() {
    if [ "$1" = "" ]; then
        docker exec -it dipas_php /bin/bash;
    else
        docker exec -it dipas_php /bin/bash -c "$1";
    fi

    checkExitCode "$?" "Container not available?"
}


###
# @param string $1 optional action to pipe in
function goto_containerVue_do() {
    if [ "$1" = "" ]; then
        docker exec -it dipas_vue /bin/bash;
    else
        docker exec -it dipas_vue /bin/bash -c "$1";
    fi

    checkExitCode "$?" "Container not available?"
}


# @param string $1 optional action to pipe in
function goto_containerDb_do() {
    if [ "$1" = "" ]; then
        docker exec -it dipas_postgres /bin/bash;
    else
        docker exec -it dipas_postgres /bin/bash -c "$1";
    fi

    checkExitCode "$?" "Container not available?"
}


function goto_containerPhp_doComposerInstall() {
    echo
    echo "Runs: 'composer install' to bind dependencies (if changed)...";
    goto_containerPhp_do "cd /app/htdocs; composer install";
}


function goto_containerPhp_doDrushCr() {
    echo
    echo "Runs: 'drush cr' (Rebuild all caches)...";
    goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush cr";
}


function goto_containerPhp_doDrushCim() {
    local cmdPhpMem512Drush="";
    cmdPhpMem512Drush="php -d memory_limit=${DIPAS_EXTS_CFG_PHP_MEMLIMIT} /app/htdocs/vendor/bin/drush";

    echo
    echo "Runs: 'drush cim -y'...";
    goto_containerPhp_do "${cmdPhpMem512Drush} cim -y";

    echo
    echo "Runs: 'drush cim -y' to veryfiy...";
    goto_containerPhp_do "${cmdPhpMem512Drush} cim -y";
}


function goto_containerPhp_doDrushUpdb() {
    echo
    echo "Runs: 'drush updb -y'...";
    goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush updb -y";
    echo "Runs: 'drush updb -y' to veryfiy prev. run...";
    goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush updb -y";
}


function goto_containerPhp_doDrushCimUpdbCr() {
    goto_containerPhp_doDrushCim
    goto_containerPhp_doDrushUpdb
    goto_containerPhp_doDrushCr;
}


# Import translation file
function goto_containerPhp_doDrushImpTrans() {
    echo
    echo "Runs: 'drush locale:import de /app/config/de.po' import de.po file...";
    goto_containerPhp_do "cd /app/htdocs; ./vendor/bin/drush locale:import de /app/config/de.po";
}


function goto_containerPhp_doDrushFixDomainEntries() {
    echo
    echo "Fix domain entrys for development:";
    local cmdFixDomains="${cmdPhpMem512Drush} dipas-dev:fix-domain-entries \
        --host=${DIPAS_XEXT_PHP_FIXDOMAIN_HOST} \
        --port=${DIPAS_XEXT_PHP_FIXDOMAIN_PORT}";
    echo -n "Runs: Fix domain entrys ";
    echo "--host=${DIPAS_XEXT_PHP_FIXDOMAIN_HOST} --port=${DIPAS_XEXT_PHP_FIXDOMAIN_PORT}";
    goto_containerPhp_do "$cmdFixDomains";
}


function do_codeCSCheck() {
    echo "Run Vue lint + CS checks...";
    goto_containerVue_do "npm run lint";

    txt_warn "Run PHP lint + CS checks... not implemented :-(";
    #goto_containerPhp_do "cd /app/htdocs/drupal/tests; ./runCSCheck.sh";
}


# containerVueRunLintFix
function do_codeCSFix() {
    echo "Run Vue CS fixes (lint fixes)...";
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
    cd "${DIPAS_BASE_ROOT_PATH}" || return 0;
    do_checkDipasExists || return 1;
    do_dockerServicesCheck || return 2;

    echo
    echo -n "Check if '${DIPAS_DB_DUMP_SUBPATH}/' exists... ";
    if [ ! -d "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/" ]; then
        mkdir "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/" || {
            txt_warn "Error creating '${DIPAS_DB_DUMP_SUBPATH}'. Check permissions. Abort";

            return 1;
        }
    fi
    echo "ok";

    local _IMPORT_FILE="${DIPAS_DB_DUMP_IMPORT}";
    local check=0;

    echo "Import file from path 'DIPAS ROOT/${DIPAS_DB_DUMP_SUBPATH}/':";

    if [ ! -f "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/${DIPAS_DB_DUMP_IMPORT}" ]; then
        txt_warn "Default: '${DIPAS_DB_DUMP_IMPORT}' not found. A selection is required!";
        _IMPORT_FILE="";
    fi

    echo "Possible files (sql|gz dump files) in '${DIPAS_DB_DUMP_SUBPATH}':";
    echo '-->--';
    cd "${DIPAS_DB_DUMP_SUBPATH}" || {

        return 3;
    }
    ls ./*.{gz,sql} 2> /dev/null;
    cd "${DIPAS_BASE_ROOT_PATH}" || {

        return 4;
    }
    echo '--<--';

    if [ -n "${_IMPORT_FILE}" ]; then
        echo "Enter file to import (or press <enter> to use: '${_IMPORT_FILE}'): ";
    else
        echo "Enter file to import: ";
    fi
    read -r IMPORT_FILE;
    IMPORT_FILE=${IMPORT_FILE:-$_IMPORT_FILE};

    if [ ! -f "${DIPAS_BASE_ROOT_PATH}/${DIPAS_DB_DUMP_SUBPATH}/${IMPORT_FILE}" ]; then
        txt_warn "File '${IMPORT_FILE}' not found. Abort";

        return 5;
    else
        # handle import

        local fext="${IMPORT_FILE##*\.}";
        local dbDumpFile="${DIPAS_DB_DUMP_SUBPATH}/${IMPORT_FILE}";

        # go to container and execute checks and commands

        local cmdPvCheckAvailable="command -v pv >/dev/null 2>&1 || {
            echo >&2 \"Ooops missing...\"; exit 1;
        }";
        local cmdPvStatus=0; # 0: ok, 1:fail
        if ! goto_containerPhp_do "$cmdPvCheckAvailable"; then
            txt_warn "Command 'pv' not available. Can not show import progress";
            cmdPvStatus=1;
        fi

        # drop db first
        goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} \
            && psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME} < /root/dropdb.sql > /dev/null 2>&1
        ";

        if [ "${fext}" = "gz" ] || [ "${fext}" = "tgz" ] ; then
            echo 'Import gz dump. Please wait...';

            if [ "$cmdPvStatus" -eq 0 ]; then
                goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} && \
                    pv --progress --name 'DB Import progress' -tea \"${dbDumpFile}\" \
                    | zcat | \
                    psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME}  > /dev/null 2>&1
                ";
            else
                goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} && \
                    zcat \"${dbDumpFile}\" | \
                    psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME}  > /dev/null 2>&1
                ";
            fi

        elif [ "${fext}" = "sql" ] ; then
            echo 'Import sql dump. Please wait...';

            if [ "$cmdPvStatus" -eq 0 ]; then
                goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} && \
                    pv --progress --name 'DB Import progress' -tea \"${dbDumpFile}\" \
                    | psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME} > /dev/null 2>&1
                ";
            else
                # psql  < /x.sql > /dev/null 2>&1
                goto_containerPhp_do "export PGPASSWORD=${DIPAS_DB_PASSWORD} && \
                    psql -U ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} -d ${DIPAS_DB_NAME} \
                        < ${dbDumpFile} > /dev/null 2>&1
                ";
            fi
        else
            echo "Dont know to handle the input file '${dbDumpFile}'. Missing extension (gz|tgz|sql)";

            return 7;
        fi

        echo
        echo "$(mark_ok) Import of '${dbDumpFile}' complete";
    fi

    return $check;
}


# extended containerDatabaseImport
# DB Import + BE upds
function do_dbImport_extended() {
    local cmdPhpMem512Drush="";
    cmdPhpMem512Drush="php -d memory_limit=${DIPAS_EXTS_CFG_PHP_MEMLIMIT} /app/htdocs/vendor/bin/drush";

    local skipImport=0;

    goto_containerPhp_doComposerInstall;

    if ! confirmCommand "Skip DB import? And run BE updates only?"; then
        skipImport=0; # no
        echo
        # do import db
        do_dbImport || {
            return $?;
        }

        # Update credentials after a db import

        echo
        echo "Runs: 'drush ucrt admin'..."; # Create a user account.
        goto_containerPhp_do "${cmdPhpMem512Drush} ucrt admin";

        echo
        echo "Runs: 'drush upwd admin admin'...";
        goto_containerPhp_do "${cmdPhpMem512Drush} upwd admin admin";

        echo
        echo "Runs: 'drush urol siteadmin admin'...";
        goto_containerPhp_do "${cmdPhpMem512Drush} urol siteadmin admin";

        echo
        echo -e "$(mark_ok) Drupal credentials done! Login with admin/admin";
    else
        skipImport=1;
    fi

    # bring up the rest...
    echo
    echo "Runs: 'drush cim -y'...";
    goto_containerPhp_do "${cmdPhpMem512Drush} cim -y";

    echo
    echo "Runs: 'drush cim -y' to veryfiy...";
    goto_containerPhp_do "${cmdPhpMem512Drush} cim -y";

    goto_containerPhp_doDrushUpdb;

    goto_containerPhp_doDrushCr;

    echo
    echo "Runs: 'drush en dipas_dev' enable dipas dev module...";
    goto_containerPhp_do "${cmdPhpMem512Drush} en dipas_dev";

    echo
    echo "Runs: 'drush en dipas_statistics' enable dipas statistics module...";
    goto_containerPhp_do "${cmdPhpMem512Drush} en dipas_statistics";

    # only if new db is in, we need translations and fix domain entrys.
    if  [ $skipImport -eq 0 ]; then

        goto_containerPhp_doDrushImpTrans

        goto_containerPhp_doDrushFixDomainEntries
    fi

    echo
    echo "'$SCRIPT_CURRENT_MENUENAME' done";
}


function do_dbExport() {
    echo "Running pre-checks first...";
    do_checkDipasExists || {
        echo
        txt_warn "DIPAS installation not found. Abort";

        return 1;
    }
    do_dockerServicesCheck || {
        echo
        txt_warn "DIPAS docker container down. Abort";

        return 2;
    }

    local cmdPvCheckAvailable="command -v \"pv\" &> /dev/null";
    local cmdPvStatus=0; # 0: ok, 1:fail
    if ! goto_containerPhp_do "$cmdPvCheckAvailable"; then
        txt_warn "Command 'pv' not available. Can not show import progress";
        cmdPvStatus=1;
    fi
    echo "Pre-checks done.";

    echo
    echo "Existing files (sql|gz dump files). You can choose a file to replace";
    echo "or enter your own export filename:";
    echo '---';
    cd "${DIPAS_DB_DUMP_SUBPATH}" || {

        return 3;
    }
    ls ./*.{gz,sql} 2> /dev/null;
    cd "${DIPAS_BASE_ROOT_PATH}" || {

        return 4;
    }
    echo '---';
    local uid=""; uid="$(id -u "$USER")";
    local _EXPORT_FILE="${DIPAS_DB_DUMP_EXPORT}";
    if [ -n "${_EXPORT_FILE}" ]; then
        echo "Enter file to export (or press <enter> to use: '${_EXPORT_FILE}'): ";
    else
        echo "Enter file to export: ";
    fi
    read -r EXPORT_FILE;
    EXPORT_FILE=${EXPORT_FILE:-$_EXPORT_FILE};

    echo "Export DB...";
    local dmp="${DIPAS_DB_DUMP_SUBPATH}/${EXPORT_FILE}";
    local fext="${EXPORT_FILE##*\.}";

    if [ "${fext}" = "gz" ] || [ "${fext}" = "tgz" ] ; then
        echo 'Export gzip sql dump. Please wait...';

        if [ "$cmdPvStatus" -eq 0 ]; then
            goto_containerPhp_do "PGPASSWORD=${DIPAS_DB_PASSWORD} \
                pg_dump --username ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} ${DIPAS_DB_NAME} \
                | pv --progress -N dumpfile -tea | gzip -9 > ${dmp}";
        else
            goto_containerPhp_do "PGPASSWORD=${DIPAS_DB_PASSWORD} \
                pg_dump --username ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} ${DIPAS_DB_NAME} \
                | gzip -9 > ${dmp}";
        fi

    elif [ "${fext}" = "sql" ] ; then
        echo 'Export sql dump. Please wait...';

        if [ "$cmdPvStatus" -eq 0 ]; then
            goto_containerPhp_do "PGPASSWORD=${DIPAS_DB_PASSWORD} \
                pg_dump --username ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} ${DIPAS_DB_NAME} \
                | pv --progress -N dumpfile -tea > ${dmp}";
        else
            goto_containerPhp_do "PGPASSWORD=${DIPAS_DB_PASSWORD} \
                pg_dump --username ${DIPAS_DB_USERNAME} -h ${DIPAS_DB_HOST} ${DIPAS_DB_NAME} > ${dmp}";
        fi
    else
        txt_warn "Dont know to handle the export filename '${dmp}'. Check config";

        return 5;
    fi
    # fix file perms
    goto_containerPhp_do "chown ${uid}:${uid} ${dmp}";

    echo
    echo "$(mark_ok) Exported to '${DIPAS_BASE_ROOT_PATH}/${dmp}'"
}


# Plural checks if services are available.
function do_dockerServicesCheck() {
    local check=0;
    do_dockerServiceCheckIsUp || check=1;
    do_dockerContainerCheckExists || check=1;

    return $check;
}


# plural version for service and containers
function do_dockerServicesStart() {
    do_dockerServiceStart;
    do_dockerContainerStart;
}


# plural version for service and containers
function do_dockerServicesStop() {
    do_dockerContainerStop;
    do_dockerServiceStop;
}


function do_dockerServiceStart() {
    if ! do_dockerServiceCheckIsUp; then
        sudo service docker start;
        if ! checkExitCode "$?" "Service failure"; then
            txt_warn "$(mark_fail) Service docker start failt";

            return 1;
        fi
    fi

    echo "$(mark_ok) Service docker start successful";
    return 0;
}


function do_dockerServiceStop() {
    if confirmCommand "Stop docker system service? sudo required..."; then
        if sudo service docker stop; then
            echo "$(mark_ok) Stopped";

            return 0;
        else
            txt_warn "$(mark_fail) Stop failt";

            return 1;
        fi
    fi

    return 0;
}


function do_dockerShutdown() {
    do_dockerContainerStop;
    do_dockerServiceStop;
}


function do_dockerServiceCheckIsUp() {
    FILE=/var/run/docker.pid;
    if [ -f "$FILE" ]; then
        echo -e "$(mark_ok) Docker service is running";

        return 0;
    else
        echo -e "$(mark_fail) $(txt_warn "Docker service is NOT running")";
        echo -e "Please start the docker service with '$(ct_grey 'sudo service docker start')'";

        return 1;
    fi
}


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


function do_dockerContainerRestart() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }

    echo "Stop containers...";
    $SCRIPT_CMD_DOCKERCOMPOSE down 2> /dev/null;
    echo "Start containers...";
    $SCRIPT_CMD_DOCKERCOMPOSE up --detach;
}


function do_dockerContainerStart() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }

    echo "Start containers...";
    $SCRIPT_CMD_DOCKERCOMPOSE up --detach;
}


function do_dockerContainerStop() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }

    echo "Stop containers...";
    $SCRIPT_CMD_DOCKERCOMPOSE down
}


function do_dockerContainerBuild() {
    cd "${DIPAS_BASE_ROOT_PATH}/docker/" || {
        txt_warn "cd to path: '${DIPAS_BASE_ROOT_PATH}/docker/' failt";
    }
    echo "Building containers. This may take some time...";
    $SCRIPT_CMD_DOCKERCOMPOSE build --no-cache
}


function do_setupConfig() {
   # global variables to ask for:
   # see menu help info

    local failmesg="Required value. Please install. Abort!";

    checkCommandAvailable "git" || {
        txt_err "$failmesg";

        return 1;
    }

    ### bash 4.0 and a sort(1) with -z
    ## Sort a little better to request changes depending on var names
    local prg_sorted=()
    while IFS= read -rd '' key; do
        prg_sorted+=( "$key" )
    done < <(printf '%s\0' "${!PRG_GLOBALS[@]}" | sort -z)

    echo
    echo "Your current config:";
    for itemKey in "${prg_sorted[@]}"; do
        echo "Key: '$(ct_yellow "$itemKey")', value: '$(ct_green "${PRG_GLOBALS[$itemKey]}")'";
    done

    echo
    echo "Enter 'q' to quit the setup at any time you dont want to change";
    echo "values anymore. Previous entrys are 'activ' until you restart ";
    echo "this script (CTRL+C).";

    # request changes
    for itemKey in "${prg_sorted[@]}"; do
        echo
        echo "Config: '$(ct_yellow "$itemKey")' = '$(ct_green "${PRG_GLOBALS[$itemKey]}")'";
        echo -n "Enter new value or <enter> for no change: ";
        read -r TMP_VAR;
        if [ "${TMP_VAR}" = "q" ];then
            return 0;
        fi
        eval "${itemKey}=\"${TMP_VAR:-${PRG_GLOBALS[$itemKey]}}\"";
    done

    echo
    echo "---";
    echo "Can save config to \"${SCRIPT_CONFIGFILE_CURRENT}\"";
    if confirmCommand "Save the config to be used for this session?"; then
        typeset -p "${prg_sorted[@]}" > "${SCRIPT_CONFIGFILE_CURRENT}";
        echo
        echo "$(mark_ok) Config saved to:";
        echo "  '${SCRIPT_CONFIGFILE_CURRENT}'";
        echo
        echo "This config will be currently used.";
    else
        echo
        txt_warn "Config not saved but changes are now activ!...";
        echo "...until you exit the program or choose 'setup' again from";
        echo "menu to change the values.";
    fi
    cd "$DIPAS_BASE_ROOT_PATH" || {
        txt_warn "Oops cd to dipas root path '$DIPAS_BASE_ROOT_PATH' failt.";
    }
}


# delete config and exit on success
function do_setupReset() {
    echo
    echo "Delete \"${SCRIPT_CONFIGFILE_CURRENT}\"?";
    if [ -f "${SCRIPT_CONFIGFILE_CURRENT}" ]; then
        echo
        if confirmCommand "Please confirm removing your custom config"; then
            rm "${SCRIPT_CONFIGFILE_CURRENT}";
            echo
            echo "$(mark_ok) Setup/ custom config '${SCRIPT_CONFIGFILE_CURRENT}'";
            echo "was removed. Please start this script again.";
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


# system core requirements: sudo, docker, code repositories...
function do_installEnviroment() {
    local haveSudo=0 inSudoer=0 haveDocker=0 inDocker=0 haveDockerCompose=0 haveGit=0; # 1 means: NO!
    local pkgList="";

    echo
    echo "Checking required commands to be available...";
    checkCommandAvailable "sudo" || { haveSudo=1; }
    checkCommandAvailable "docker" || { haveDocker=1; }
    checkCommandAvailable "$SCRIPT_CMD_DOCKERCOMPOSE" || { haveDockerCompose=1; }
    checkCommandAvailable "git" || { haveGit=1; }
    id -nG "$USER" | grep -qw  "sudo" || { inSudoer=1; }
    id -nG "$USER" | grep -qw  "docker" || { inDocker=1; }

    if [ $haveSudo -eq 0 ] &&
        [ $inSudoer -eq 0 ] &&
        [ $haveDocker -eq 0 ] &&
        [ $inDocker -eq 0 ] &&
        [ $haveDockerCompose -eq 0 ] &&
        [ $haveGit -eq 0 ]
    then
        echo
        echo "Core software exists an is available. Asuming this is not the"
        echo "first install case. Skip core install process...";

        return 0;
    else
        echo
        txt_warn "If you have 'root' access you can go on! Otherwise your system";
        txt_warn "administrator must go on with the core requirements to";
        txt_warn "install the enviroment packages.";
        echo
        echo "This will ask you several times for a password to go on. Stay tuned!";

        if confirmCommand "First install? Try to install required services?"; then

            if [ $haveSudo -eq 1 ]; then
                echo
                echo "After install: Logout and come back so the settings are activ.";
                echo "At this step the program can exit but logout must be done by you.";
                echo
                echo "1/2 installing 'sudo' command to improve less requests for root privileges";
                echo "for the future...";

                su -c "apt install sudo";

                echo
                txt_warn "Add user '$USER' to sudo'er list...";
                su -c "/usr/sbin/adduser $USER sudo";

                if id -nG "$USER" | grep -qw  "sudo"; then
                    inSudoer=0;
                    echo
                    txt_warn "At this step the program can exit but logout must be done by you.";
                    echo
                    txt_warn "Come back again to finish the setup/ install process.";
                    echo

                    exit;
                else
                    echo "Not in group for sudo'ers. Logout and try again.";

                    exit;
                fi
            fi

            if [ $inSudoer -eq 1 ]; then
                echo
                txt_warn "Command 'sudo' available but you are not in the list already..."
                txt_warn "Add user '$USER' to sudo'er list...";
                su -c "/usr/sbin/adduser $USER sudo";
                echo
                txt_warn "At this step the program can exit but logout must be done by you.";
                txt_warn "Come back again to finish the setup/ install process.";

                exit;
            fi

            # sudo and in sudoers done...
            echo
            txt_warn "You are already a sudo'er.";
            echo "2/2 installing docker packages now...";
            pkgList="$SCRIPT_PKGLIST_FOR_DOCKER";
            # shellcheck disable=SC2086
            sudo apt install $pkgList;

            if [ $inDocker -eq 1 ]; then
                echo "Add user '$USER' to docker group...";
                sudo adduser "$USER" docker || {
                    txt_warn "Abort. Error adding user to docker group";

                    return 1;
                }
            fi

            echo
            txt_warn "Installation of core packages done. Setup proxy settings if needed now!";
            echo
            txt_warn "Logout and come back again to be sure your rights are set and active now!"
            echo

            exit;
        fi
    fi
}


function do_installDipas() {

    do_installEnviroment;

    # Todo for complet purge and reinstall? Good idea? no|yes ?
    # rm ~/projects/DIPAS/*

    echo
    if do_checkDipasExists ;then
        ctb_yellow "DIPAS installation exists.";

        # txt_warn "DANGER: This asks you to delete all existing code.";
        # echo "This is not a good idea if you haven't checked if you still";
        # echo "have some open branches or some git stashes you may need later.";
        # echo
        # txt_warn "Please check carefully branches and stashes before you go on.";
        # echo "Path: '${DIPAS_BASE_ROOT_PATH}'";
        # echo
        # txt_warn "DELETE ALL OF THE CODE? There is no undo!";

        # if confirmCommand "Please confirm"; then
        #     # confirmed (0): y selected...
        #     echo -n "Will delete existing code now... ";
        #     #rm "${DIPAS_BASE_ROOT_PATH}/.... no good idea here!
        #     echo "Done!";
        # else
        #     echo "Skip deletion of code";
        # fi
    else
        echo "Good, we can go on...";
    fi

    echo
    echo "Installing DIPAS code and enviroment configs to '${DIPAS_BASE_ROOT_PATH}'. ";
    confirmCommand "Please confirm" || {
        echo "Return to menu...";

        return 0;
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
        txt_warn "Not cloning 'docker' repo. Exists. Leaving untouched.";
    else
        local urlDocker="";
        if [ "${DIPAS_REPO_USERNAME}" = "" ]; then
            urlDocker="${DIPAS_REPO_DOCKER_URL/UNKNOWN@/${DIPAS_REPO_USERNAME}}";
        else
            urlDocker="${DIPAS_REPO_DOCKER_URL/UNKNOWN/${DIPAS_REPO_USERNAME}}";
        fi

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
        txt_warn "Not cloning DIPAS code repo. Exists. Leaving untouched.";
    else
        local urlDipas="";
        if [ "${DIPAS_REPO_USERNAME}" = "" ]; then
            urlDipas="${DIPAS_REPO_DIPAS_URL/UNKNOWN@/${DIPAS_REPO_USERNAME}}";
        else
            urlDipas="${DIPAS_REPO_DIPAS_URL/UNKNOWN/${DIPAS_REPO_USERNAME}}";
        fi

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
    local TEXT_FINISHING="";
    TEXT_FINISHING=$(
        cat <<'INSTALLHINTS'
General or first install:

1. get repos/ code, branches in place or do manually
2. build the docker container (see menu)
3. start the containers (see menu)
4. Configure drupal settings (check docs)
    4.1. Import a database or follow the docs e.g 'INSTALL.md')
    4.2. and run update tasks (see menu:'DB Import + BE upds')

INSTALLHINTS
);

    echo "${TEXT_FINISHING}";
    echo
    echo "If you have access to 'sudo' command and if you are already in the";
    echo "group 'docker' you can go on to build the docker containers now.";
    echo

    do_dockerServiceCheckIsUp || {
        if confirmCommand "Try starting docker service now?"; then
            do_dockerServiceStart || {
                echo
                txt_warn "Failt. Abort.";

                return 10;
            }
            echo "$(mark_ok) Docker service started";
        else
            txt_warn "Abort.";

            return 10;
        fi
    }

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

    #vue
    echo "Copy htdocs/vue/.env.example -> htdocs/vue/.env";
    cp "${DIPAS_BASE_ROOT_PATH}/repository/htdocs/vue/.env.example" \
        "${DIPAS_BASE_ROOT_PATH}/repository/htdocs/vue/.env";

    # drupal/php
    echo "Handle settings in: 'repository/htdocs/drupal/sites/default/'";
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
        echo
        echo 'Yes selected... you checked the files already!';

        echo "With a verfied 'settings.local.php', php/drupal/vue dependencies";
        echo "can be installed now (composer install)";
        if confirmCommand "Run 'composer install'?"; then
            goto_containerPhp_doComposerInstall;
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

    echo
    # mk upload paths available
    cd "${DIPAS_BASE_ROOT_PATH}/repository/htdocs/drupal/sites/default" || {
        txt_warn "cd to 'repository/htdocs/drupal/sites/default' failed";
    }
    #if confirmCommand "Create and modify upload paths with correct permissions?"; then
        if [ ! -d "./files/dipas" ]; then
            mkdir -p "./files/dipas";
        fi

        if [ ! -d "./files/languages" ]; then
            mkdir "./files/languages";
        fi

        if [ ! -d "./files/translations" ]; then
            mkdir "./files/translations";
        fi
        sudo chown -R daemon:daemon ./files;
    #fi

    #####


    cd "${DIPAS_BASE_ROOT_PATH}" || txt_warn "cd to dipas root failed (L:$LINENO)";

    echo
    echo "$(mark_ok) So far: 'SYS: Install DIPAS enviroment' done";
    echo
    echo "${TEXT_FINISHING}";
    echo
    echo "Your TO-DOs now:";
    echo "4.1 and 4.2: Import a database or check the docs to go on.";
    echo
    echo "--- break ---";
    echo
    echo "You may want to install also the DIPAS navigator which uses the DIPAS";
    echo "backend. If all previous actions works fine, you may agree to go on,";
    echo "otherwise check previous TODOs or errors first and come back again";
    echo "or select from the menu";
    if confirmCommand "Confirm to start installing DIPAS navigator..."; then
        do_installDipasNavigator || {
            echo
            txt_warn "Failt. Abort. (L:$LINENO)";

            return 11;
        }
    fi
}


# @returns int Zero on success or a code > 0 (zero)
function do_installDipasNavigator() {
    local urlDipasNavigator="";
    local branch="${DIPAS_XEXT_REPO_DIPASnavigator_BRANCH:-${DIPAS_XEXT_REPO_DIPASnavigator_BRANCHDEFAULT}}";

    echo "Installing DIPAS navigator...";

    if [ -d "${DIPAS_BASE_ROOT_PATH}/dipas-navigator/.git" ]; then
        txt_warn "Not cloning DIPAS navigator repo. Exists. Leaving untouched.";
    else
        if [ "${DIPAS_REPO_USERNAME}" = "" ]; then
            urlDipasNavigator="${DIPAS_XEXT_REPO_DIPASnavigator_URL/UNKNOWN@/${DIPAS_REPO_USERNAME}}";
        else
            urlDipasNavigator="${DIPAS_XEXT_REPO_DIPASnavigator_URL/UNKNOWN/${DIPAS_REPO_USERNAME}}";
        fi

        echo "Cloning the DIPAS navigator from '${urlDipasNavigator}'...";
        if ! git clone "${urlDipasNavigator}" dipas-navigator; then
            txt_err "Error cloning url. Check url or permissions. Abort";

            return 12;
        fi
    fi

    cd "dipas-navigator" || {
        txt_warn "Error changing to path './dipas-navigator'. Please check. Abort";
        # other process in the background? permisions problem? This should not happen.

        return 13;
    };

    if confirmCommand "Checkout branch '${branch}'"; then
        git checkout "${branch}";
    fi

    echo
    echo "Copy 'src/example.config.local.js' to 'src/config.local.js'...";
    if [ -f "src/config.local.js" ]; then
        txt_warn "File 'src/config.local.js' exists.";
        if confirmCommand "Confirm to overwrite..."; then
            cp src/example.config.local.js src/config.local.js;
        fi
    else
        cp src/example.config.local.js src/config.local.js;
    fi
    echo "done";


    echo
    echo "Copy 'example.vue.config.local.js' to 'vue.config.local.js'";
    echo -e "Edit the file 'vue.config.local.js' at '$(txt_warn "drupal: {")' section.";
    echo "E.g: Port 8080, baseHost: localhost";
    if [ -f "vue.config.local.js" ]; then
        txt_warn "File 'vue.config.local.js' exists.";
        if confirmCommand "Confirm to overwrite..."; then
            cp example.vue.config.local.js vue.config.local.js
        fi
    else
        cp example.vue.config.local.js vue.config.local.js
    fi
    echo -e "$(mark_ok) Code installation done";
    echo
    echo "Make sure current required node version is available for this project.";
    echo -e "Required node version (from current config): '$(txt_warn "$DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM")'";
    echo "Or ask in the team.";
    echo
    echo "Setup DIPAS navigator now? 'nvm' should be available but can be done later";

    if [ -f ".nvmrc" ]; then
        echo -e "'$(txt_warn ".nvmrc")' file found.";
        echo "Configured version: '$DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM '";
        echo "Found version currently in .nvmrc file: '$(cat .nvmrc)'";
    else
        echo -e "Add $(txt_warn ".nvmrc") to current project?";
    fi
    if confirmCommand "Add/ Update .nvmrc file?"; then
        # echo -n "echo '$DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM' > .nvmrc ... ";
        echo $DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM > .nvmrc;
        echo -e "$(mark_ok) done";
    fi

    cd "$DIPAS_BASE_ROOT_PATH/dipas-navigator" || { echo "cd failed"; };

    echo
    # shellcheck disable=SC1091
    if [ "${NVM_DIR}" != "" ]; then
        txt_warn "'nvm' command found. I'll make it tmp. available from .nvmrc";
        . "${NVM_DIR}/nvm.sh";
        echo "Running 'nvm install'";
        nvm install;

        txt_warn "After closing this session 'nvm' shows probably a different version!";

        echo
        if confirmCommand "Run 'npm install' now?"; then
            echo -n "nvm version: $(nvm --version); ";
            echo -n "npm version: $(npm --version); ";
            echo "node version: $(node --version)";
            npm install;
        fi
    else
        echo "nvm not found. Do it manually!";
    fi

    echo
    echo "When using/ working with DIPAS navigator: Go to";
    echo "cd '$DIPAS_BASE_ROOT_PATH/dipas-navigator'";
    echo "Run 'nvm use' or 'nvm install' to get the required version.";
    echo "Run 'npm install' to make dependencies available";

    cd "$DIPAS_BASE_ROOT_PATH" || {
        txt_warn "Error changing to path '${DIPAS_BASE_ROOT_PATH}'. Please check";
    }
    echo
    echo -e "$(mark_ok) Setup complete.";

    return 0;
}


# End YOUR program functions }}}



################################################################################
# {{{ ### Promotion for this program ###########################################
################################################################################

# its: ANSI Regular & Hand Made
BANNER_INTRO_PRE=$(
    cat <<'BANNER_INTRO'

              ███████████████████████████████████████████
              █                                         █
              █                                         █
                                                        █
    ██████   ██\033[0m  \033[36m██████   █████      ███████  ██   ██\033[0m   █
    ██   ██  ██\033[0m  \033[36m██   ██ ██   ██     ██       ██   ██\033[0m   █
    ██   ██  ██\033[0m  \033[36m██████  ███████     ███████  ███████\033[0m   █
    ██   ██  ██\033[0m  \033[36m██      ██   ██          ██  ██   ██\033[0m   █
    ██████   ██\033[0m  \033[36m██      ██   ██  █  ███████  ██   ██\033[0m   █
                                                        █
              █          VERSION_STRING   █
              █    ██████████████████████████████████████
              █   █
              █  █     Digitales Partizipationssystem
              █ █      DIPAS - dipas.org
              ██       Hamburg / Germany
              █
        [D]eep [I]nstall and [P]roject [A]ssistant [Sh]ellscript
        For development tasks: DIPA.sh

BANNER_INTRO
);

BANNER_INTRO="${BANNER_INTRO_PRE/VERSION_STRING/${VERSION_STRING}}";

# Umpf TL:DR: 1 - 26 DEC!
BANNER_OUTRO_PRE_XMS=$(
    cat <<'BANNER_OUTRO_DEC'

                     .-"``"-.
                    /______; \
                   {_______}\|
                   (/ a a \)(_)
                   (.-.).-.)
      _______ooo__(    ^    )____________
     /             '-.___.-'             \
    |  Have a wonderful Christmas season  |
    |           and a good day            |
     \___________________________________/
                   |_  |  _|
                   \___|___/
                   {___|___}
                    |_ | _|
                    /-'Y'-\
                   (__/ \__)

BANNER_OUTRO_DEC
);

# North earth : ~21 Mar - ~20Jun
BANNER_OUTRO_PRE_SPR=$(
    cat <<'BANNER_OUTRO_SPR'

          ,
      /\^/`\
     | \/   |         SPRING IS IN THE AIR!
     \ \    /                                          _ _
      '\\//'                                         _{ ' }_
        ||                DON'T PANIC               { `.!.` }
        ||  ,                                         {_,_}
    |\  ||  |\                                          |
    | | ||  | |         Have a good day               (\|  /)
    | | || / /                                         \| //
     \ \||/ / \\   `   /       ´      `   \\   o //     |//
      `\\//`   \\   \./    \\ /    ///     \\ o //   \\ |/ /
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

BANNER_OUTRO_SPR
);

#  ~21 Juni | Jul | Aug | ~ 20Sep
BANNER_OUTRO_PRE_SUM=$(
    cat <<'BANNER_OUTRO_SUM'
      SUMMER TIME             .
                         .    |    .
                          \   |   /
                      '.   \  '  /   .'
                        '. .'```'. .'
    <>.............:::::::`.......`:::::::................<>
    <>:                                see you the beach :<>
    <>:                              and have a good day :<>
    <><><><><><><><><><><><><><><><><><><><><><><><><><><><>

BANNER_OUTRO_SUM
);

# Bug to be shown at 24.12 and 31.12 - 1.1
BANNER_OUTRO_PRE_BUG=$(
    cat <<'BANNER_OUTRO_BUG'
                         _ ._  _ , _ ._
                       (_ ' ( `  )_  .__)
                     ( (  (    )   `)  ) _)
                    (__ (_   (_ . _) _) ,__)
                        `~~`\ ' . /`~~`
                        ,::: ;   ; :::,
                       ':::::::::::::::'
    +--------------c42-----/_ __ _\----------------------+
    |    BAD, BAD, BUG HERE. CHECK THE DATE AND TIME     |
    |     HAPPY XMAS and a HAPPY NEW YEAR, DARLING !     |
    +----------------------------------------------------+

BANNER_OUTRO_BUG
);


BANNER_OUTRO_PRE_DEF=$(
    cat <<'EOTXT'
          _\|/_
          (o o)
 +---- oOO-{_}-OOo----+
 |   Have a good day  |
 / ------------------ \

EOTXT
);


function getBannerOutro() {
    local banner="$BANNER_OUTRO_PRE_DEF";

    case $(date +%m-%d) in
        # north hemisphere lazy strict and nearby
        #
        # BANNER_OUTRO_PRE_SPR # spring    # North earth : ~21 Mar - ~20Jun
        # BANNER_OUTRO_PRE_SUM # summer    # ~21 Juni | Jul | Aug | ~ 20Sep
        # BANNER_OUTRO_PRE_XMS # xmas time # Upf TL;DR: 1 - 26 DEC!
        # BANNER_OUTRO_PRE_BUG #           # Bug to be shown at 24-26.12 and 31.12 - 1.1

        03-2[1-9] | 03-3* | 04-[0123]* | 05-[0123]* | 06-[01]* | 06-20)
            banner="$BANNER_OUTRO_PRE_SPR";
            ;;
        06-2[1-9] | 06-3* | 07-[0123]* | 08-[0123]* | 09-[01]* | 09-20)
            banner="$BANNER_OUTRO_PRE_SUM";
            ;;
        # 09-2[2-9] | 09-3* | 1[012]-[01]* | 12-2[012])
        #     echo "autumn" ;;
        12-2[4-6] | 01-01 | 12-31)
            banner="$BANNER_OUTRO_PRE_BUG";
            ;;
        12-0[1-9] | 12-1[0-9] | 12-2[0-6]*)
            banner="$BANNER_OUTRO_PRE_XMS";
            ;;
        # 12-2[1-9] | 12-3* | 01-[0123]* | 02-[0123]* | 03-[1*|20)
        #     banner="wintertime";
        #     ;;
    esac

    echo "$banner";
}

BANNER_OUTRO="$(getBannerOutro)";


# End promotion }}}



################################################################################
# {{{ ### YOUR default configs #################################################
################################################################################

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
DIPAS_REPO_DOCKER_BRANCH="dev"
DIPAS_REPO_DOCKER_BRANCHDEFAULT="dev"

# Don't replace UNKNOWN here! REPO_USERNAME will be used
DIPAS_REPO_DIPAS_URL="https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/dipas_community.git";
DIPAS_REPO_DIPAS_BRANCH="dev";
DIPAS_REPO_DIPAS_BRANCHDEFAULT="dev";
# Username on vc system to clone repos for the install process.
# Optional if set in url
DIPAS_REPO_USERNAME="";

DIPAS_XEXT_PHP_FIXDOMAIN_HOST="localhost";
DIPAS_XEXT_PHP_FIXDOMAIN_PORT="8080";
# In some case like db imports php needs more memory limit.
DIPAS_EXTS_CFG_PHP_MEMLIMIT="512M";

# Don't replace UNKNOWN here! REPO_USERNAME will be used
DIPAS_XEXT_REPO_DIPASnavigator_URL="https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/dipas-navigator.git";
DIPAS_XEXT_REPO_DIPASnavigator_BRANCH="dev";
DIPAS_XEXT_REPO_DIPASnavigator_BRANCHDEFAULT="dev";
DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM="v10.24.1";

# Depeding on the versions of your OS (debian, Ubuntu, WSL) and included
# external packages (source.list), docker compose can come in different
# flavors. eg:
#  1. '/usr/bin/docker-compose' (debian 11, 12; Ubuntu 22.04; real OS's from origin)
#  2. '/usr/local/bin/docker-compose' (probably manual install, WSL, debian, Ubuntu, mixed)
#  3. 'docker compose' (builtin from docker.com which maybe dont work currently eg in WSL)
SCRIPT_CMD_DOCKERCOMPOSE="/usr/local/bin/docker-compose";
# Depending on docker-compose this may vari.
#SCRIPT_PKGLIST_FOR_DOCKER="sudo docker.io docker-compose containerd git"; #debian11,12,Ubuntu2[0|2].04
SCRIPT_PKGLIST_FOR_DOCKER="sudo docker.io docker-compose containerd git";
SCRIPT_CONFIGFILE_CURRENT="${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.config";

###
# source config if exists to overwrite prev. defaults
if [ -f "${SCRIPT_CONFIGFILE_CURRENT}" ]; then
    # shellcheck source=/dev/null
    . "${SCRIPT_CONFIGFILE_CURRENT}";
fi

if [ -f "$1" ]; then
    # overload custom config
    echo "Custom config overload detected for '$1'";
    SCRIPT_CONFIGFILE_CURRENT="$1"; # TODO! real location? script dir? what if same name?
    # shellcheck source=/dev/null
    . "${SCRIPT_CONFIGFILE_CURRENT}";
fi

# ###
# # source custom modules if exists to add aditional functions/feature
# if [ -f "${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.modules" ]; then
#     # shellcheck source=/dev/null
#     . "${SCRIPT_DIRECTORY_REAL}/.DIPA.sh.modules";
# fi

################################################################################
# mapper for the configs to save custom configs
#
declare -A PRG_GLOBALS
# ignore the order of entrys here. a-z by var name counts in real.
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

    [DIPAS_XEXT_PHP_FIXDOMAIN_HOST]="$DIPAS_XEXT_PHP_FIXDOMAIN_HOST"
    [DIPAS_XEXT_PHP_FIXDOMAIN_PORT]="$DIPAS_XEXT_PHP_FIXDOMAIN_PORT"

    [DIPAS_EXTS_CFG_PHP_MEMLIMIT]="$DIPAS_EXTS_CFG_PHP_MEMLIMIT"

    [DIPAS_XEXT_REPO_DIPASnavigator_URL]="$DIPAS_XEXT_REPO_DIPASnavigator_URL"
    [DIPAS_XEXT_REPO_DIPASnavigator_BRANCH]="$DIPAS_XEXT_REPO_DIPASnavigator_BRANCH"
    [DIPAS_XEXT_REPO_DIPASnavigator_BRANCHDEFAULT]="$DIPAS_XEXT_REPO_DIPASnavigator_BRANCHDEFAULT"
    [DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM]="$DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM"

    [SCRIPT_CMD_DOCKERCOMPOSE]="$SCRIPT_CMD_DOCKERCOMPOSE"
    [SCRIPT_PKGLIST_FOR_DOCKER]="$SCRIPT_PKGLIST_FOR_DOCKER"
    [SCRIPT_CONFIGFILE_CURRENT]="$SCRIPT_CONFIGFILE_CURRENT"
);

# end YOUR default configs }}}



################################################################################
# {{{ ### YOUR Menu config #####################################################
################################################################################
#
# Limits:
#
# MENU_NAM max. 30 chars!
# MENU_KEY exec:abc -> invokes calling the function abc directly
#                      whithout 'exec:' prefix you need to implement the
#                      specials for that call
# MENU_HLP max 80 chars colmns width on output. max 120chars at code level!
# -------------------------->| <- 30
# ---------------------------------------------------------------------------->| <- 80

# init menu config

declare -a MENU_NAM
declare -a MENU_KEY
declare -a MENU_HLP
_IDX=0;

# menu config

((_IDX=_IDX+1)); # 1 help menu must stay at postion 1
MENU_NAM[_IDX]="Help"; # Dont do it in menu like: ❓ or using colors!
MENU_KEY[_IDX]="exec:menuhelp";
MENU_HLP[_IDX]="General help info... and to show all help";

((_IDX=_IDX+1)); # 2
MENU_NAM[_IDX]="Exit or 'q' for quit";
MENU_KEY[_IDX]="exec:do_exit";
MENU_HLP[_IDX]="Exit the program
Press CTRL+C, 'q' or select '$_IDX' from the menu to exit the program";

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
MENU_NAM[_IDX]="-----------------------";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 9
MENU_NAM[_IDX]="PHP: Composer Install";
MENU_KEY[_IDX]="exec:goto_containerPhp_doComposerInstall";

((_IDX=_IDX+1)); # 10
MENU_NAM[_IDX]="PHP: Drush Clear Cache (cr)";
MENU_KEY[_IDX]="exec:goto_containerPhp_doDrushCr";

((_IDX=_IDX+1)); # 11
MENU_NAM[_IDX]="PHP: Drush 2x cim + updb + cr";
MENU_KEY[_IDX]="exec:goto_containerPhp_doDrushCimUpdbCr";

((_IDX=_IDX+1)); # 12
MENU_NAM[_IDX]="PHP: Drush Import i18n (*.po)";
MENU_KEY[_IDX]="exec:goto_containerPhp_doDrushImpTrans";

((_IDX=_IDX+1)); # 13
MENU_NAM[_IDX]="PHP: Drush Fix domain entries";
MENU_KEY[_IDX]="exec:goto_containerPhp_doDrushFixDomainEntries";

((_IDX=_IDX+1)); # 14
MENU_NAM[_IDX]="-----------------------";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 15
MENU_NAM[_IDX]="Goto docker: PHP";
MENU_KEY[_IDX]="exec:goto_containerPhp_do";
MENU_HLP[_IDX]="Enter the php docker container to do individual actions e.g:
DB dumps, 'composer install' 'drush abc xyz' and so on....";

((_IDX=_IDX+1)); # 16
MENU_NAM[_IDX]="Goto docker: Vue";
MENU_KEY[_IDX]="exec:goto_containerVue_do";
MENU_HLP[_IDX]="Enter the Vue docker container to do individual actions e.g:
'npm run lint', 'npm run test:unit' or 'npm run lint:fix'...";

((_IDX=_IDX+1)); # 17
MENU_NAM[_IDX]="Goto docker: DB";
MENU_KEY[_IDX]="exec:goto_containerDb_do";
MENU_HLP[_IDX]="Enter the postgre database docker container to do individual actions";

((_IDX=_IDX+1)); # 18
MENU_NAM[_IDX]="-----------------------";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 19
MENU_NAM[_IDX]="SYS: DB Import";
MENU_KEY[_IDX]="exec:do_dbImport";
MENU_HLP[_IDX]="This does only handle the database import of a sql dump file.
All further actions needs to be made by hand.";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: DB Import + BE upds";
MENU_KEY[_IDX]="exec:do_dbImport_extended";
MENU_HLP[_IDX]="DB Import + Backend updates
Daily business:
You get a new DB. Import it and you want upgrading it to the latest changes of
the local 'drupal' installation to check for errors or for working on the
current (newer) code base.

This does the following actions:

- Checks if services are up to go on
- Request db file to import
- Resets db (backup before exists?)
- Runs: 'composer install' to bind php dependencies (if changed)
- Imports the db file

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

Fixes local domain entrys for development (here: default values):
- Runs: 'drush dipas-dev:fix-domain-entries --host=localhost --port=80'


... more to come if needed
";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: DB Export";
MENU_KEY[_IDX]="exec:do_dbExport";
MENU_HLP[_IDX]="Export/ backup current dipas database.
It will be stored in 'DIPAS ROOT PATH/transfer/dipas-dump-export.sql' if you
dont change the default settings or enter a custom export filename.
";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="-----------------------";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker services check";
MENU_KEY[_IDX]="exec:do_dockerServicesCheck"
MENU_HLP[_IDX]="Checks if docker service is running
and also if the docker containers exists and are activ";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker services start";
MENU_KEY[_IDX]="exec:do_dockerServicesStart"

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker services stop";
MENU_KEY[_IDX]="exec:do_dockerServicesStop"

((_IDX=_IDX+1));
MENU_NAM[_IDX]="-----------------------";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Docker containers build";
MENU_KEY[_IDX]="exec:do_dockerContainerBuild";
MENU_HLP[_IDX]="Initial install job.
Containers must be build (first time or on changes of the container setup)
to be able to run the docker containers.";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="SYS: Install DIPAS enviroment";
MENU_KEY[_IDX]="exec:do_installDipas";
MENU_HLP[_IDX]="Install DIPAS from scratch.

Make sure running 'setup custom config' first. Otherwise the script defaults
will be used.

First install:
Asking you for 'root' privileges to install required software if not already
available. Read carefully the output and make sure to logout after each step
if the program ask you for it so that settings will be activ for the next step.
When using 'wsl2' it mostly means your user password to become 'root'

'sudo', 'docker' and 'git' are the most important packages which must be
available. If all is already installed/ available the program skip's this first
install step.

!!! Details are in the help of 'setup custom config' from menu.!!!

You should be in the group of 'docker' and 'sudo' for this setup. This install
process will ask you to make it available. Otherwise: Admins: you need to know.

If docker is not activ by default run: 'sudo service docker start'
@see: 'Docker services start' in menu.

Then follow all requested qustions to install the enviroment and DIPAS code.
";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="-----------------------";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="CFG: Setup custom config";
MENU_KEY[_IDX]="exec:do_setupConfig";
MENU_HLP[_IDX]="Show and change custom config values.

This 'Setup' first shows the current config and then will request each
parameter for changes and to save them to a config file
current: (${SCRIPT_CONFIGFILE_CURRENT}')
for the usage of this program. If the config does not exists the script defaults
will be used and shown. Eg: user and passwords for DB or locations where all the
code, reositories will go to.

Make sure this script exists only once in your user account and you dont run
setup at the same time in e.g. two shells. Saving config may fail behind the
scene: If another running instance of this program or any other program
modifies the config, it will be overwritten at this point, losing any previous
changes made by the other program(s).

To restore back to our defaults just remove this config file or select
'Delete custom config' and start the script again.

Another option is to use custom configs, which are probably it the best usecase
for the DIPAS project and all its forks!

run: $(ct_yellow "DIPA.sh /path/to/other/project/.DIPA.sh.config"); to load and
work with that config.

Details of the config keys and usage:

# DIPAS root path for the installation
# e.g.: /home/${USER}/projects/DIPAS | '/www/dipas' (no tailing /)
$(ct_yellow "DIPAS_BASE_ROOT_PATH")

# Default db export/import filenames.
# The file extension is important here. For lower file sizes of the dumps use
# 'gz' for gzip compression. Each time you want to import or export the db you
# will be asked for an individual filename.
# def: $(ct_yellow "dipas-dump-export.sql.gz") and
# def: $(ct_yellow "dipas-dump-import.sql.gz")
$(ct_yellow "DIPAS_DB_DUMP_EXPORT")
$(ct_yellow "DIPAS_DB_DUMP_IMPORT")

# Subpath (after DIPAS ROOT PATH) for sharing data/files cross docker containers
# def: $(ct_yellow "transfer")
$(ct_yellow "DIPAS_DB_DUMP_SUBPATH")

# Hostname or ip address to connect to the db server. def: $(ct_yellow "database")
$(ct_yellow "DIPAS_DB_HOST")

# Name of DIPAS database. def: $(ct_yellow "dipas")
$(ct_yellow "DIPAS_DB_NAME")

# Password to connect to the db. def: $(ct_yellow "dipas")
$(ct_yellow "DIPAS_DB_PASSWORD")

# Username to connect to the db. def: $(ct_yellow "dipas")
$(ct_yellow "DIPAS_DB_USERNAME")


###
# Repos's: we have a 'dipas' and the 'docker' repository.

# Branch of the dipas repo to checkout/ or pull (updates). def: $(ct_yellow "''")
$(ct_yellow "DIPAS_REPO_DIPAS_BRANCH")

# Default branch of the dipas repo and to be used if
# '$(ct_yellow "DIPAS_REPO_DIPAS_BRANCH")' is empty. def: $(ct_yellow "dev")
$(ct_yellow "DIPAS_REPO_DIPAS_BRANCHDEFAULT")

# Url to the dipas repository.
# Don't replace UNKNOWN here! '$(ct_yellow "DIPAS_REPO_USERNAME")' will be used
# if not empty, otherwise 'UNKNOWN@' will be automatically removed.
# Optional: This can include credentials e.g: user:pass if
# '$(ct_yellow "DIPAS_REPO_USERNAME")' stays empty.
# def: $(ct_yellow "https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/dipas_community.git")
$(ct_yellow "DIPAS_REPO_DIPAS_URL")

# Branch of the docker repository for a development enviroment to checkout/ or
# pull (updates). def: $(ct_yellow "''")
$(ct_yellow "DIPAS_REPO_DOCKER_BRANCH")

# Default branch of the docker repo. def: $(ct_yellow "dev")
$(ct_yellow "DIPAS_REPO_DOCKER_BRANCHDEFAULT")

# Url to the docker repository for a development enviroment.
# Don't replace UNKNOWN here! '$(ct_yellow "DIPAS_REPO_USERNAME")' will be used
# if not empty, otherwise 'UNKNOWN@' will be automatically removed.
# Optional: This can include credentials e.g: user:pass if
# '$(ct_yellow "DIPAS_REPO_USERNAME")' stays empty.
# stays empty. def: $(ct_yellow "https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/docker_for_dipas.git")
$(ct_yellow "DIPAS_REPO_DOCKER_URL")

# Username for http authentication at the VC system. def: $(ct_yellow "''")
# Optional if set in url
$(ct_yellow "DIPAS_REPO_USERNAME")


###
# Configs for extensions:

# Hostname/ip and port where 'Verfahren' are located at the local development
# enviroment. def: $(ct_yellow "localhost") and def: $(ct_yellow "80")
$(ct_yellow "DIPAS_XEXT_PHP_FIXDOMAIN_HOST")
$(ct_yellow "DIPAS_XEXT_PHP_FIXDOMAIN_PORT")

###
# Configs in general:

# In some case like db imports php needs more memory limit.
# def: $(ct_yellow "512M") for 512 MB or 0 (zero) for no limit but depricated at this point
$(ct_yellow "DIPAS_EXTS_CFG_PHP_MEMLIMIT")

###
# DIPAS navigator

# Url to the DIPAS navigator repository for a development enviroment.
# Don't replace UNKNOWN here! '$(ct_yellow "DIPAS_REPO_USERNAME")' will be used
# if not empty, otherwise 'UNKNOWN@' will be automatically removed.
# Optional: This can include credentials e.g: user:pass if
# '$(ct_yellow "DIPAS_REPO_USERNAME")' stays empty.
# stays empty. def: $(ct_yellow "https://UNKNOWN@bitbucket.org/geowerkstatt-hamburg/dipas-navigator.git")
$(ct_yellow "DIPAS_XEXT_REPO_DIPASnavigator_URL")

# Branch of the DIPAS navigator repository for a development enviroment to checkout/ or
# pull (updates). def: $(ct_yellow "dev")
$(ct_yellow "DIPAS_XEXT_REPO_DIPASnavigator_BRANCH")

# Default branch of the DIPAS navigator repository. def: $(ct_yellow "dev")
$(ct_yellow "DIPAS_XEXT_REPO_DIPASnavigator_BRANCHDEFAULT")

# Node version to be used with nvm. def: $(ct_yellow "$DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM")
$(ct_yellow "DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM")

###
# SCRIPT configs e.g. to run special commands

# Depeding on the versions of your OS (debian, Ubuntu, WSL) and included
# external packages (source.list), docker compose can come in different
# flavors. eg:
#  1. '/usr/bin/docker-compose' (debian 11, 12; Ubuntu 22.04; real OS's from origin)
#  2. '/usr/local/bin/docker-compose' (probably manual install, WSL, debian, Ubuntu, mixed)
#  3. 'docker compose' (builtin from docker.com which maybe dont work currently eg in WSL)
# Current way: 2 (def: $(ct_yellow "/usr/local/bin/docker-compose")
$(ct_yellow "SCRIPT_CMD_DOCKERCOMPOSE");

# Depending on 'docker-compose' this may vari.
# Current test OS: debian 11,12,2204, def: $(ct_yellow "sudo docker.io docker-compose containerd git")
#SCRIPT_PKGLIST_FOR_DOCKER=\"sudo docker.io docker-compose containerd git\"; # debian 12
$(ct_yellow "SCRIPT_PKGLIST_FOR_DOCKER")


more to come...
";
# end CFG: Setup custom config

((_IDX=_IDX+1));
MENU_NAM[_IDX]="CFG: Delete custom config";
MENU_KEY[_IDX]="exec:do_setupReset";
MENU_HLP[_IDX]="This will delete your custom config, currently:
'${SCRIPT_CONFIGFILE_CURRENT}'
default: '.DIPA.sh.config' and exits the program.
Start DIPA.sh new and our default config values will be used.";

# ((_IDX=_IDX+1));
# MENU_NAM[_IDX]="-----------------------";
# MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="--- DIPAS_navigator ---";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="Install DIPAS_navigator";
MENU_KEY[_IDX]="exec:do_installDipasNavigator";
MENU_HLP[_IDX]="DIPAS navigator
Install the navigator. The Vue app uses the existing dipas drupal installation.
So you can checkout the navigator under the path where dipas exists. E.g:
'$DIPAS_BASE_ROOT_PATH'.

Keep docker up (min. db and drupal (docker_php) containers so this frontend
can use the backend. Make sure to checkout the current branch of the backend
for this project! Probably 'dev' like in '$DIPAS_BASE_ROOT_PATH/repository'

Make sure to read the help of 'Setup custom config' first and run that step.
The installer then will guide you to set the following steps:

    cd $DIPAS_BASE_ROOT_PATH
    git clone https://bitbucket.org/geowerkstatt-hamburg/dipas-navigator.git

    cd dipas-navigator

    # missing hints or documentation
    cp src/example.config.local.js src/config.local.js

    # Copy example file and edit the 'drupal: {' section.
    # Port 8080, baseHost: localhost
    cp example.vue.config.local.js vue.config.local.js

    # make sure current required node version is available for this project. Or ask in
    # the team. E.g:
    echo $DIPAS_XEXT_REPO_DIPASnavigator_NODEVERSION_NVM > .nvmrc
    nvm use

    cd $DIPAS_BASE_ROOT_PATH
";


# End YOUR Menu config }}}



################################################################################
# {{{ ### Action handling start ################################################
################################################################################

#
# THESE SHOULD BE THE LAST CODE LINES IN THIS SCRIPT
#

# tput reset;
# print banner once at startup
echo -e "${BANNER_INTRO}";
# ct_blue "${BANNER_INTRO}";

##
# program pre checks

echo
if ! do_checkDipasExists ;then
    txt_warn "Please run the 'Setup custom config' from menue to set some ";
    txt_warn "paths or credentials and save them or our script defaults will be used.";
    echo
    txt_warn "Run 'install DIPAS...' from menu to install DIPAS and to hide this message.";
    echo
    txt_warn "Further infomations are located in the help menu: Enter 1 to get help details";
    echo
else
    # this script to be run at this path as default and always to not conflict in paths!
    cd "${DIPAS_BASE_ROOT_PATH}" || {
        txt_err "DIPAS exists but cd to the path failed exception....";

        exit 1;
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
# COLUMNS=120;
select SCRIPT_CURRENT_MENUENAME in "${MENU_NAM[@]}"
do
    cd "${DIPAS_BASE_ROOT_PATH}" &> /dev/null || {
        echo
        echo "Menu selected: ${SCRIPT_CURRENT_MENUENAME} ($REPLY)";
        echo "Please run 'install' or 'setup' first.";
        echo "cd to dipas root path failt: '$DIPAS_BASE_ROOT_PATH'";
        echo
        cd "$(pwd)" || echo "cd pwd failt";
    }

    # trim input first
    REPLY="$(trim "$REPLY")";

    # Input can be '<int>' or '<int> <int>' eg for help menu in detail.
    MENU_INPUT_REGEX='^(([0-9])+|(([0-9]+ [0-9]+)$))$';
    MENU_INPUT_VALUE=$REPLY;
    if [[ $MENU_INPUT_VALUE =~ $MENU_INPUT_REGEX ]]
    then
        MENU_INPUT_VALUE_A=$(echo "$MENU_INPUT_VALUE" | cut -d ' ' -f 1)
        MENU_INPUT_VALUE_B=$(echo "$MENU_INPUT_VALUE" | cut -d ' ' -f 2)
        # if B not given it contains A, so clear it!
        if [ "$MENU_INPUT_VALUE_A" = "$MENU_INPUT_VALUE_B" ]; then
            MENU_INPUT_VALUE_B="";
        fi

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
        # Not the 'exec:...' case?
        # So check if the selected menu key exists and if special and needs to
        # be implemented here in a switch case stmt ... do it...
        # E.g: a "q" for quit

        case $REPLY in
        "q")
            do_exit
            ;;

        ### TODO to be removed! ############################################>>>>>
        "cr")
            # hidden feature
            goto_containerPhp_doDrushCr;
            ;;

        "cim")
            # hidden feature
            goto_containerPhp_doDrushCim;
            ;;

        "updb")
            # hidden feature
            goto_containerPhp_doDrushUpdb;
            ;;
        ### TODO to be removed! ###########################################<<<<<

        *)
            # All others which do not match
            echo "Ooops - Option '$REPLY' not implemented";
            # break
            ;;
        esac

        # fallback if not break'ed before
        #echo "Ooops - Option '$REPLY' not exists";
        #echo "Ooops - Option '$REPLY' not exists, exit"; break;
    fi
done

# End Action handling start }}}


# vim: ts=4 sw=4 et
