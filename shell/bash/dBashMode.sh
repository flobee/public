#!/bin/bash

# shellcheck disable=SC2016

#        ██   ██████   █████  ███████ ██   ██    ███   ███  ██████  ██████  ███████
#        ██   ██   ██ ██   ██ ██      ██   ██    ████ ████ ██    ██ ██   ██ ██
#    ██████   ██████  ███████ ███████ ███████    ██ ███ ██ ██    ██ ██   ██ █████
#   ██   ██   ██   ██ ██   ██      ██ ██   ██    ██  █  ██ ██    ██ ██   ██ ██
#    █████ ██ ██████  ██   ██ ███████ ██   ██ ██ ██     ██  ██████  ██████  ███████

################################################################################
# {{{ ### INTRO / README #######################################################
################################################################################
#
# d.Bash Mode - BASH menu prototype shell script for trd party usage
#
# @autor Florian Blasel
# @version 1.0.0
# @since 2024-01
#
#####
#
# README FIRST:
#
# Requirements:
# bash ± 5.1.* (lower versions not tested, probably it will work nowadays)
#
# What this script does:
# It is an interactiv script which shows you a menu to select tasks you want
# to implement and execute.
#
# Install:
# PUT this script to your PATH or create a symlink of this file to your PATH
# and make it executable (chmod +x ./dBashMode.sh) Otherwise call it like:
# `bash /path/to/dBashMode.sh` or just `./dBashMode.sh`. Other calls like
# from `zsh` or `sh ./dBashMode.sh` may fail if you use a different
# interactiv shell than `bash` as your default shell. E.g.: `zsh` is very
# pupular because of it's power for simple things inside but its another
# script dialect which causes this script to fail in some details.
#
# When using the "setup"/ "configure task, this script, this program
# will asking you some questions, and it stores the config at the real location
# of this script (if a symlink) to `.${SCRIPT_FILENAME}.config`. Every time you
# use this tool it loads this config (if exists) so that you dont need to care
# anymore. Otherwise the script default settings will be used and no futher
# requests will be made (in most cases).
#
# Happy Development! See or hear from you from the know channels... ;)
#
# Hint: Enable 'fold'ing in you vimrc for improved reading of this file.
### }}}


################################################################################
# {{{ ### Script basics ########################################################
################################################################################

SCRIPT_DIRECTORY_REAL="$(dirname "$(readlink -f "$0")")";
SCRIPT_FILENAME=$(basename "$0");
DEBUG=0;

# set -x enables a mode of the shell where all executed commands are printed
# to the terminal. In your case it's clearly used for debugging, which is a
# typical use case for set -x: printing every command as it is executed may
# help you to visualize the control flow of the script if it is not functioning
# as expected. set +x disables it. E.g: [ "$DEBUG" = 'true' ] && set -x

if [ $DEBUG = 1 ]; then
    set -x;
else
    set +x;
fi;

if [ -z "$BASH" ]; then
   echo "Please run this script '$0' with the bash shell.";
   echo "Call it like (from PATH) '${SCRIPT_FILENAME}' or (from current ";
   echo "directory): './${SCRIPT_FILENAME}' or 'bash ~/path/${SCRIPT_FILENAME}";

   exit 1;
fi

# TODO check when it comes empty!!! eg in PATH?
if [ "$SCRIPT_FILENAME" = "" ]; then
    txt_warn "SCRIPT_FILENAME: $SCRIPT_FILENAME emtpy";
    txt_warn "\$0: $0";
    echo "check call, debug here";

    exit 1;
fi

# Using Semver but for visual reasons: no two chars lenght of major, minor,
# bugfix version: Just N.N.N, where N means only 1 digit!
VERSION='1.0.0';
VERSION_STRING="${SCRIPT_FILENAME} - Version ${VERSION}";

### End Script basics }}} ######################################################



################################################################################
# {{{ ### General functions ####################################################
################################################################################

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

function ctb_black() { echo -e "\033[90m$1\033[0m"; } # mostly grey
function ctb_red()   { echo -e "\033[91m$1\033[0m"; }
function ctb_green() { echo -e "\033[92m$1\033[0m"; }
function ctb_yellow(){ echo -e "\033[93m$1\033[0m"; }
function ctb_blue()  { echo -e "\033[94m$1\033[0m"; }
function ctb_purple(){ echo -e "\033[95m$1\033[0m"; }
function ctb_cyan()  { echo -e "\033[96m$1\033[0m"; }
function ctb_grey()  { echo -e "\033[97m$1\033[0m"; }
function ctb_white() { echo -e "\033[98m$1\033[0m"; }

# color helpers: marker/icons
function mark_ok()   { echo -e "$(ctb_green "\xE2\x9C\x94") "; }
function mark_fail() { echo -e "$(ctb_red "\xE2\x9C\x96") "; }
function mark_abort() { echo "⛔️"; }

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
    local defstr=""
    # local def="";
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
                txt_warn "Invalid input. One of $opts. (yYjJ=Yes, nN=No)";
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


# Help menu.
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
        { echo "$txtbanner";
        echo -e "$txt"; } | less -R
    else
        echo "$txtbanner";
        echo -e "$txt";
    fi
}


function do_setupConfig() {
   # global variables to ask for:
   # see menu help info

    declare -A PRG_GLOBALS
    # ignore the order of entrys here.
    PRG_GLOBALS=(
        [MOD_BASE_ROOT_PATH]="$MOD_BASE_ROOT_PATH"
        [MOD_DB_DUMP_SUBPATH]="$MOD_DB_DUMP_SUBPATH"

        [MOD_DB_NAME]="$MOD_DB_NAME"
        [MOD_DB_HOST]="$MOD_DB_HOST"
        [MOD_DB_USERNAME]="$MOD_DB_USERNAME"
        [MOD_DB_PASSWORD]="$MOD_DB_PASSWORD"
        [MOD_DB_DUMP_IMPORT]="$MOD_DB_DUMP_IMPORT"
        [MOD_DB_DUMP_EXPORT]="$MOD_DB_DUMP_EXPORT"

        [MOD_REPO_PROJECT_BRANCHCURRENT]="$MOD_REPO_PROJECT_BRANCHCURRENT"
        [MOD_REPO_PROJECT_BRANCHDEFAULT]="$MOD_REPO_PROJECT_BRANCHDEFAULT"
        [MOD_REPO_PROJECT_URL]="$MOD_REPO_PROJECT_URL"
        [MOD_REPO_PROJECT_USERNAME]="$MOD_REPO_PROJECT_USERNAME"

        [MOD_SSH_SERVER1_USER]="$MOD_SSH_SERVER1_USER"
        [MOD_SSH_SERVER1_HOST]="$MOD_SSH_SERVER1_HOST"
    );

    ### bash 4.0 and a sort(1) with -z
    ## Sort a little better to request changes
    #
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
    echo "Enter 'q' to quit the setup";

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
    if confirmCommand "Save the config to be used from now on?"; then
        typeset -p "${prg_sorted[@]}" > "${SCRIPT_DIRECTORY_REAL}/.${SCRIPT_FILENAME}.config";
        echo
        echo "$(mark_ok) Config saved to:";
        echo "  '${SCRIPT_DIRECTORY_REAL}/.${SCRIPT_FILENAME}.config'";
        echo
        echo "This config will be used from now on.";
    else
        echo
        txt_warn "Config not saved but changes are now activ!...";
        echo "...until you exit the program or choose 'setup' again from";
        echo "menu to change the values.";
    fi
    cd "$MOD_BASE_ROOT_PATH" || {
        txt_warn "Oops cd to base root path '$MOD_BASE_ROOT_PATH' failt.";
    }
}


# delete config and exit on success
function do_setupReset() {
    if [ -f "${SCRIPT_DIRECTORY_REAL}/.${SCRIPT_FILENAME}.config" ]; then
        echo
        if confirmCommand "Please confirm removing your custom config"; then
            rm "${SCRIPT_DIRECTORY_REAL}/.${SCRIPT_FILENAME}.config";
            echo
            echo "$(mark_ok) Setup/ custom config '.${SCRIPT_FILENAME}.config' was removed.";
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


# do no operation
function do_noop() {
    return 0;
}


function do_exit() {
   echo "$BANNER_OUTRO";
   echo

   exit;
}


### End General functions }}} ##################################################



################################################################################
# {{{ ### Program default configs ##############################################
################################################################################

MOD_BASE_ROOT_PATH="/home/${USER}/projects/myproject";
MOD_DB_NAME='dbuser';
MOD_DB_HOST='dbhostname_or_ip';
MOD_DB_USERNAME='dbuser';
MOD_DB_PASSWORD='dbpass';
# Import file extension can be .sql, .gz or .tgz
MOD_DB_DUMP_IMPORT='dbdump-import.sql.gz';
# Export file extension can be .sql, .gz or .tgz
MOD_DB_DUMP_EXPORT='dbdump-export.sql.gz';
MOD_DB_DUMP_SUBPATH="transfer";

# Don't replace UNKNOWN here! REPO_USERNAME will be used
MOD_REPO_PROJECT_BRANCHCURRENT=""
MOD_REPO_PROJECT_BRANCHDEFAULT="stable";
MOD_REPO_PROJECT_URL="https://UNKNOWN@somehost.tld/path/to/proj/repo.git";
MOD_REPO_PROJECT_USERNAME="";

MOD_SSH_SERVER1_USER="user";
MOD_SSH_SERVER1_HOST="server1";

# source config if exists to overwrite prev. defaults
if [ -f "${SCRIPT_DIRECTORY_REAL}/.${SCRIPT_FILENAME}.config" ]; then
    # shellcheck source=/dev/null
    . "${SCRIPT_DIRECTORY_REAL}/.${SCRIPT_FILENAME}.config";
fi

### end Program custom configs }}} #############################################



################################################################################
# {{{ ### Menu config ##########################################################
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
MENU_NAM[_IDX]="Help"; # Dont do it in menu, like: ❓ or using colors!
MENU_KEY[_IDX]="exec:menuhelp";
MENU_HLP[_IDX]="General help info... and to show all help";

((_IDX=_IDX+1)); # 2
MENU_NAM[_IDX]="Exit or 'q' for quit";
MENU_KEY[_IDX]="exec:do_exit";
MENU_HLP[_IDX]="Exit the program
The following options will work:
- Press CTRL+C
- Select '$_IDX' from the menu or
- enter 'q'
to quit/ exit this program";

((_IDX=_IDX+1)); # 3
MENU_NAM[_IDX]="---";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 4
MENU_NAM[_IDX]="MYF: function do_noop";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 5
MENU_NAM[_IDX]="---";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 6
MENU_NAM[_IDX]="MYF: function do_noop";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 7
MENU_NAM[_IDX]="MYF: function do_noop";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 8
MENU_NAM[_IDX]="MYF: function do_noop";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 9
MENU_NAM[_IDX]="MYF: function do_noop";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1)); # 10
MENU_NAM[_IDX]="---";
MENU_KEY[_IDX]="exec:do_noop";

((_IDX=_IDX+1));
MENU_NAM[_IDX]="CFG: Setup custom config";
MENU_KEY[_IDX]="exec:do_setupConfig";
MENU_HLP[_IDX]="Show and change custom config values.

This 'Setup' first shows the current config and then will request each
parameter for changes and to save them to a config file
(.${SCRIPT_FILENAME}.config') for the usage of this program. If the config does
not exists our defaults will be used and shown. Eg: user and passwords for a DB
or locations where all the code, reositories will go to.

Make sure this script exists only once in your user account and you dont run
setup at the same time in e.g. two shells. Saving config may fail behinde the
scene: If another running instance of this program or any other program
modifies the config, it will be overwritten at this point, losing any previous
changes made by the other program(s).

To restore back to our defaults just remove this config file or select
'delete custom config' and start the script again.

Details of the config keys and usage:

# base root path to be used
# e.g.: /home/${USER}/projects/some-path
$(ct_yellow "MOD_BASE_ROOT_PATH")


more to come...
";
# end CFG: Setup custom config


((_IDX=_IDX+1));
MENU_NAM[_IDX]="CFG: Delete custom config";
MENU_KEY[_IDX]="exec:do_setupReset";
MENU_HLP[_IDX]="This will delete your custom config '.${SCRIPT_FILENAME}.config'
and exits the program.
Start the script again and the script default config values will be used.";

### End Menu config }}} ########################################################



################################################################################
# {{{ ### Promotion ############################################################
################################################################################

# its: ANSI Regular & Hand Made
BANNER_INTRO_PRE=$(
    cat <<'BANNER_INTRO'

     ██   ██████   █████  ███████ ██   ██    ███   ███  ██████  ██████  ███████
     ██   ██   ██ ██   ██ ██      ██   ██    ████ ████ ██    ██ ██   ██ ██
 ██████   ██████  ███████ ███████ ███████    ██ ███ ██ ██    ██ ██   ██ █████
██   ██   ██   ██ ██   ██      ██ ██   ██    ██  █  ██ ██    ██ ██   ██ ██
 █████ ██ ██████  ██   ██ ███████ ██   ██ ██ ██     ██  ██████  ██████  ███████
 VERSION_STRING

BANNER_INTRO
);

BANNER_INTRO="${BANNER_INTRO_PRE/VERSION_STRING/${VERSION_STRING}}";

# Umpf TL:DR: 1 - 26 DEC!
BANNER_OUTRO_PRE_DEC=$(
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
     _________________c42______/_ __ \______________________
    |                                                       |
    |                 BAD, BAD, BUG HERE                    |
    |_______________________________________________________|

BANNER_OUTRO_BUG
);


BANNER_OUTRO_PRE_DEF=$(
    cat <<'EOTXT'
         _\|/_
         (o o)
 +--- oOO-{_}-OOo----+
 |  Have a good day  |
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
        # BANNER_OUTRO_PRE_DEC # xmas time # Upf TL;DR: 1 - 26 DEC!
        # BANNER_OUTRO_PRE_BUG # winter    # Bug to be shown at 24.12 and 31.12 - 1.1

        03-2[1-9] | 03-3* | 04-[0123]* | 05-[0123]* | 06-[01]* | 06-20)
            banner="$BANNER_OUTRO_PRE_SPR";
            ;;

        06-2[1-9] | 06-3* | 07-[0123]* | 08-[0123]* | 09-[01]* | 09-20)
            banner="$BANNER_OUTRO_PRE_SUM";
            ;;

        # 09-2[2-9] | 09-3* | 1[012]-[01]* | 12-2[012])
        #     echo "autumn"
        #     ;;

        12-2[4-6] | 01-01 | 12-31)
            banner="$BANNER_OUTRO_PRE_BUG";
            ;;

        12-0[1-9] | 12-1[0-9] | 12-2[0-6]*)
            banner="$BANNER_OUTRO_PRE_DEC";
            ;;

        # 12-2[1-9] | 12-3* | 01-[0123]* | 02-[0123]* | 03-[1*|20)
        #     banner="wintertime";
        #     ;;
    esac

    echo "$banner";
}

BANNER_OUTRO="$(getBannerOutro)";


### End promotion }}} ##########################################################



################################################################################
# ### {{{ Custom program functions #############################################
################################################################################

#function some_function() {}

# # Example go to a server via ssh connection or call a command at server side
function goto_sshserver_do() {
    if [ "$1" = "" ]; then
        ssh "user@server";
    # else
    #     local cmd="$1";
    #     ssh user@server "$cmd";
    fi
}

### End Custom program functions }}} ###########################################



################################################################################
# {{{ ### Action handling start ################################################
################################################################################
#
# THESE SHOULD BE THE LAST CODE LINES IN THIS SCRIPT
#

tput reset;
# print banner once at startup
echo "${BANNER_INTRO}";
echo

##
# program pre checks

#   script root parh exists?

# end program pre checks
##

PS3="
--------------------------------------------------------------------------------
Press <enter> for menu, CTRL+C or 'q' for 'exit',
choose an action number: ";

# number of columns for the select stmt
COLUMNS=120;
select CURRENT_SCRIPT_MENUENAME in "${MENU_NAM[@]}"
do
    cd "${MOD_BASE_ROOT_PATH}" &> /dev/null || {
        echo
        echo "Menu selected: ${CURRENT_SCRIPT_MENUENAME} ($REPLY)";
        echo "Please run 'install' or 'setup' first.";
        txt_warn "cd to base root path failt: '$MOD_BASE_ROOT_PATH'";
        echo
        cd "$(pwd)" || echo "cd pwd failt";
    }

    # detect input

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
done

### End Action handling start }}} ##############################################


# vim: ts=4 sw=4 et
