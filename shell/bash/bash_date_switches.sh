#!/bin/bash

#DIR_OF_FILE="$(dirname "$(readlink -f "$0")")";
SCRIPT_FILENAME=$(basename "$0")

if [ -z "$BASH" ]; then
    echo "Please run this script '$0' with bash"
    echo "Call it like './${SCRIPT_FILENAME}' or 'bash ${SCRIPT_FILENAME}"
    exit 1
fi

# ###
# #display the process ID of the shell it’s running in.
# echo $$; # eg the current interactiv shell eg. your zsh
# bash -c 'echo $$' # problably died after execution but the pid of that bash process

###
# /test.sh one two "three four"
#
# echo "Using \"\$*\":"
# for a in "$*"; do
#     echo $a;
# done
#
# echo -e "\nUsing \$*:"
# for a in $*; do
#     echo $a;
# done
#
# echo -e "\nUsing \"\$@\":"
# for a in "$@"; do
#     echo $a;
# done
#
# echo -e "\nUsing \$@:"
# for a in $@; do
#     echo $a;
# done
# #

###
# string replace

# mainString="I love Suzi and Marry"
# search="Suzi"
# replacementString="Sara"
# echo "${mainString/$search/$replacementString}"
#
# mainString="https://USERNAME@domain.org/path/project.git"
# search="USERNAME@"
# replacementString="someuser@"
# echo "${mainString/${search}/${replacementString}}"
#
#
# # prints 'I love Sara and Marry'
# #
# # To replace all occurrences, use
# message='The secret code is 12345'
# echo "${message//[0-9]/X}"
# # prints 'The secret code is XXXXX'

###
# heredoc
# var='xxx';
# x=$(
#     cat <<'BANNER_INTRO'
# txt
# BANNER_INTRO
# );
# # with var
# x=$(
#     cat <<BANNER_INTRO
# txt $var
# BANNER_INTRO
# );

###
# Dimensions:
#
# tput cols # n columns.
# tput lines # n lines


# Echo events based on dates like holidays.
#
# $1 the date to be tested eg: 12-24
# $2 expected value
function date_events() {
    local banner="othertime";
    # case $(date +%m-%d) in
    case "$1" in
        # north hemisphere more strict inside the levels
        # 03-2[2-9] | 03-3* | 0[4-6]-[01]* | 06-2[012])
        #     echo "spring" ;;
        # 06-2[2-9] | 06-3* | 0[7-9]-[01]* | 09-2[012])
        #     echo "summer" ;;
        # 09-2[2-9] | 09-3* | 1[012]-[01]* | 12-2[012])
        #     echo "autumn" ;;
        # 12-2[2-9] | 12-3* | 0[1-3]-[01]* | 03-2[012])
        #     echo "winter" ;;

        # north hemisphere lazy strict and nearby
        #
        # spring    # North earth : ~21 Mar - ~20Jun
        # summer    # ~21 Juni | Jul | Aug | ~ 20Sep
        # xmas time # Upf TL;DR: 1 - 26 DEC!
        # winter    # special at 24.12 and 31.12 - 1.1

        03-2[1-9] | 03-3* | 04-[123]* | 05-[123]* | 06-[01]* | 06-20)
            banner="springtime";
            ;;

        06-2[1-9] | 06-3* | 07-[123]* | 08-[123]* | 09-[01]* | 09-20)
            banner="summertime";
            ;;

        # 09-2[2-9] | 09-3* | 1[012]-[01]* | 12-2[012])
        #     echo "autumn" ;;

        12-2[4-6] | 01-01 | 12-31)
            banner="happy_days";
            ;;

        12-0[1-9] | 12-1[0-9] | 12-2[0-6]*)
            banner="xmas time";
            ;;

        12-2[1-9] | 12-3* | 01-[0123]* | 02-[0123]* | 03-[1*|20)
            banner="wintertime";
            ;;
    esac

    local status="ok";
    if [ "$banner" = "$2" ]; then
        status="ok";
    else
        status="#fail";
    fi
    echo -e "$1 > $banner \texp:$2 \tstatus: $status";
}

date_events "03-01" "othertime";
date_events "03-10" "othertime";
date_events "03-20" "othertime";
date_events "03-21" "springtime";
date_events "03-31" "springtime";
date_events "04-21" "springtime";
date_events "05-21" "springtime";
date_events "06-01" "springtime";
date_events "06-10" "springtime";
date_events "06-20" "springtime";

date_events "06-21" "summertime";
date_events "07-21" "summertime";
date_events "08-21" "summertime";
date_events "09-01" "summertime";
date_events "09-10" "summertime";
date_events "09-20" "summertime";
date_events "09-21" "othertime";

# xmax and secial days
date_events "12-01" "xmas time";
date_events "12-23" "xmas time";
date_events "12-24" "happy_days";
date_events "12-26" "happy_days";

# happy days in winter time
date_events "12-31" "happy_days";
date_events "01-01" "happy_days";

# winter time if xmas time | happy days not set
# date_events "12-21" "wintertime";
# date_events "12-31" "wintertime";
# date_events "01-01" "wintertime";
date_events "01-02" "wintertime";
date_events "01-31" "wintertime";
date_events "02-01" "wintertime";
date_events "02-31" "wintertime";

