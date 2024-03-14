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

