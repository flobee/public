#!/bin/bash

#DIR_OF_FILE="$(dirname "$(readlink -f "$0")")";
SCRIPT_FILENAME=$(basename "$0")

if [ -z "$BASH" ]; then
    echo "Please run this script '$0' with bash"
    echo "Call it like './${SCRIPT_FILENAME}' or 'bash ${SCRIPT_FILENAME}"
    exit 1
fi

###
# bash assoc array
# https://www.shell-tips.com/bash/arrays/#gsc.tab=0
#
# diff between [@] and [*] when referencing bash array values?
# -> The difference is subtle; "${LIST[*]}" (like "$*") creates one argument, while "${LIST[@]}" (like "$@") will expand each item into separate arguments, so:
# https://unix.stackexchange.com/questions/135010/what-is-the-difference-between-and-when-referencing-bash-array-values
#
# order/sortation of arrays
# - What does declaring a bash array with -A do?
#   https://unix.stackexchange.com/questions/384653/what-does-declaring-a-bash-array-with-a-do
#
# - a possible way sort assoc array
# https://www.reddit.com/r/bash/comments/5wma5k/is_there_a_way_to_sort_an_associative_array_by/?rdt=43969
#
# eval
# - The 'eval' command in Bash and its typical uses
#   https://stackoverflow.com/questions/11065077/the-eval-command-in-bash-and-its-typical-uses

###

# print all values:     echo ${ACTIONLIST[@]}

# print all keys:       echo ${!ACTIONLIST[@]}

# print length of array:echo ${#ACTIONLIST[@]}

# access value:         echo ${ACTIONLIST["key1"]}

# apend new value:      ACTIONLIST+=(["new_key"]="new_value")
#
#
#_IDX=0;
# ((_IDX=_IDX+1)); # idx 1 now
#
# Iterate Over an Array:
#for key in ${!ACTIONLIST[@]}
#do
#  echo "${key}, ${ACTIONLIST[${key}]}"
#done

# Check if a Key Exists
# if [[ -n "${ACTIONLIST["key1"]}" ]]
# then
#   echo "True"

# Clear Assoc key       unset ACTIONLIST["key1"]
# or reinit to clear:   declare -A ACTIONLIST
# Delete Assoc Array:   unset ACTIONLIST
#

# --- assoc array
# declare -A ACTIONLIST
# ACTIONLIST["abc"]="menu 01"
# ACTIONLIST["def"]="menu 02"
# # append or ACTIONLIST=(
# ACTIONLIST+=(
#    ["new_keya"]="new_valuea"
#    ["new_keyb"]="new_valueb"
# )
# printf 'printf values @ -> %s\n' "'${ACTIONLIST[@]}'";
# printf 'size values @ -> %s\n' "'${#ACTIONLIST[@]}'";
# echo
# printf 'printf values * -> %s\n' "'${ACTIONLIST[*]}'";
# printf 'size values * -> %s\n' "'${#ACTIONLIST[*]}'";
# echo -e "\n";
# # others
# for itemKey in "${!ACTIONLIST[@]}";
#    do echo "key: $itemKey; val: ${ACTIONLIST[$itemKey]}";
# done

# --- assoc array test 2
# declare -A PRG_GLOBALS
# PRG_GLOBALS=(
#     [my_a]="aa"
#     [my_b]="bb"
#     [my_c]="https://some/with?a=b&#anker"
# );
# # # looping to request updates
# for itemKey in "${!PRG_GLOBALS[@]}"; do
#    echo "Request key: '$itemKey'";
#    echo "Value      : '${PRG_GLOBALS[$itemKey]}'";
#    echo "Enter new value or <enter> for no change";
#    #
#    read TMP_VAR;
#    #
#    PRG_GLOBALS[$itemKey]=${TMP_VAR:-${PRG_GLOBALS[$itemKey]}};
#    #works but eval: eval "${itemKey}=\"${TMP_VAR:-${PRG_GLOBALS[$itemKey]}}\"";
# done
# # eport the keys to have the globals in config:
# typeset -p "${!PRG_GLOBALS[@]}" > "${SCRIPT_DIRECTORY_REAL}/.sh.config"
#
### sort assoc
# local prg_sorted=()
# while IFS= read -rd '' key; do
#    prg_sorted+=( "$key" )
# done < <(printf '%s\0' "${!PRG_GLOBALS[@]}" | sort -z)
# for key in "${prg_sorted[@]}"; do
#     printf '%s \t\t\t %s\n' "$key" "${PRG_GLOBALS[$key]}"
# done

# --- idx array
# declare -a ACTIONLIST_KEY
# ACTIONLIST_KEY[1]="menu 01"
# ACTIONLIST_KEY[2]="menu 02"
# ACTIONLIST_KEY[3]="menu 03"
# printf 'printf idx values @ -> %s\n' "'${ACTIONLIST_KEY[@]}'"
# printf 'size idx values @ -> %s\n' "'${#ACTIONLIST_KEY[@]}'"

# printf 'printf idx values * -> %s\n' "'${ACTIONLIST_KEY[*]}'"
# printf 'size idx values * -> %s\n' "'${#ACTIONLIST_KEY[*]}'"
# echo -e "\n";

#Setting the desired value into the variable
# PS3="Choose an action: ";

# ex 1
# PS3="Choose an action: ";
# menu=("Exit or CTRL + c" "menu 1" "menu 2" "menu 3" "menu 4" "menu 5" "menu 6" )
# echo "${menu[@]}";
# select option in "${menu[@]}";
# do
#    echo "option: $option";
#    case $option in
#       "menu 1")
#          echo "menu 1 selected"
#          ;;
#       "menu 2")
#          echo "menu 2 selected"
#          ;;
#       "menu 3")
#          echo "menu 3 selected"
#          ;;
#       "Exit")
#          echo "Exiting the menu"
#          break
#          ;;
#       *)
#          echo "Invalid option '$REPLY'"
#          ;;
#     esac
# done

# ex 2
# PS3="Choose an action: ";
# menu=(
#    "menu 1"
#    "menu 2"
#    "menu 3"
#    "menu 4"
#    "menu 5"
#    "menu 6"
# );

#    select item in "${menu[@]}" Exit
#    do

#       echo "${BANNER}";

#       case $REPLY in
#          1) echo "Selected item #$REPLY means '$item'";;
#          2) echo "Selected item #$REPLY means '$item'";;
#          3) echo "Selected item #$REPLY means '$item'";;
#          4) echo "Selected item #$REPLY means '$item'";;
#          5) echo "Selected item #$REPLY means '$item'";;
#          6) echo "Selected item #$REPLY means '$item'";;
#          $((${#menu[@]}+1))) echo "Done! Exiting..."; break;;
#          *) echo "Ooops - Option '$REPLY' not implemented, exit"; break;;
#       esac
#    done
