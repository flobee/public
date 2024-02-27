#!/bin/bash

#DIR_OF_FILE="$(dirname "$(readlink -f "$0")")";
SCRIPT_FILENAME=$(basename "$0");

if [ -z "$BASH" ]; then
   echo "Please run this script '$0' with bash";
   echo "Call it like './${SCRIPT_FILENAME}' or 'bash ${SCRIPT_FILENAME}";
   exit 1;
fi

# Colorize a string.
#
# Options and example:
#  strColor "${WHITE}WHITE string${RESET}"
#  strColor "${RED}RED string${RESET}"
#  strColor "${GREEN}GREEN string${RESET}"
#  strColor "${ORANGE}ORANGE string${RESET}"
#  strColor "${BLUE}BLUE string${RESET}"
#  strColor "${MAGENTA}MAGENTA string${RESET}"
#  strColor "${TURQ}TURQ string${RESET}"
#  strColor "${GREY}GREY string${RESET}"
# https://wiki.archlinux.org/title/Bash/Prompt_customization#List_of_colors_for_prompt_and_Bash
strColor() {
   INPUT_STRING=$1;
   # colors: 0-7
   WHITE="$(tput setaf 0)"
   RED="$(tput setaf 1)"
   GREEN="$(tput setaf 2)"
   ORANGE="$(tput setaf 3)"
   BLUE="$(tput setaf 4)"
   MAGENTA="$(tput setaf 5)"
   TURQ="$(tput setaf 6)"
   GREY="$(tput setaf 7)"
   RESET="$(tput sgr0)"

   echo "${INPUT_STRING}"
}


# Color functions
#
# https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
#
# 'ct_'  prefix = color text
# 'ctb_' prefix = color text bright
# 'cb_' prefix =  color background for text
#
# Basic rule: echo -e "\033[31;1;4mHello\033[0m"
#       red (31), bold (1), underlined (4) = 31;1;4m
# where the first part makes the text red (31), bold (1), underlined (4) and
# the last part clears all this (0).
#
# Options and example:
# echo -e "ct_ (DANGER: its the color code. The result may not work elsewhere):
# $(ct_black "ct_black")
# $(ct_red "ct_red")
# $(ct_green "ct_green")
# $(ct_yellow "ct_yellow")
# $(ct_blue "ct_blue")
# $(ct_purple "ct_purple")
# $(ct_cyan "ct_cyan")
# $(ct_grey "ct_grey")
# $(ct_white "ct_white")

# ctb_:
# $(ctb_black "ctb_black")
# $(ctb_red "ctb_red")
# $(ctb_green "ctb_green")
# $(ctb_yellow "ctb_yellow")
# $(ctb_blue "ctb_blue")
# $(ctb_purple "ctb_purple")
# $(ctb_cyan "ctb_cyan")
# $(ctb_grey "ctb_grey")
# $(ctb_white "ctb_white")
# ";
# or: echo -e "my text $(ct_red "red mark") to know..."
function ct_black() { echo -e "\033[30m$1\033[0m"; }
function ct_red()   { echo -e "\033[31m$1\033[0m"; }
function ct_green() { echo -e "\033[32m$1\033[0m"; }
function ct_yellow(){ echo -e "\033[33m$1\033[0m"; }
function ct_blue()  { echo -e "\033[34m$1\033[0m"; }
function ct_purple(){ echo -e "\033[35m$1\033[0m"; }
function ct_cyan()  { echo -e "\033[36m$1\033[0m"; }
function ct_grey()  { echo -e "\033[37m$1\033[0m"; }
function ct_white() { echo -e "\033[38m$1\033[0m"; }
echo -e "ct_:
$(ct_black "ct_black")
$(ct_red "ct_red")
$(ct_green "ct_green")
$(ct_yellow "ct_yellow")
$(ct_blue "ct_blue")
$(ct_purple "ct_purple")
$(ct_cyan "ct_cyan")
$(ct_grey "ct_grey")
$(ct_white "ct_white")


function ctb_black() { echo -e "\033[90m$1\033[0m"; }
function ctb_red()   { echo -e "\033[91m$1\033[0m"; }
function ctb_green() { echo -e "\033[92m$1\033[0m"; }
function ctb_yellow(){ echo -e "\033[93m$1\033[0m"; }
function ctb_blue()  { echo -e "\033[94m$1\033[0m"; }
function ctb_purple(){ echo -e "\033[95m$1\033[0m"; }
function ctb_cyan()  { echo -e "\033[96m$1\033[0m"; }
function ctb_grey()  { echo -e "\033[97m$1\033[0m"; }
function ctb_white() { echo -e "\033[98m$1\033[0m"; }
ctb_:
$(ctb_black "ctb_black")
$(ctb_red "ctb_red")
$(ctb_green "ctb_green")
$(ctb_yellow "ctb_yellow")
$(ctb_blue "ctb_blue")
$(ctb_purple "ctb_purple")
$(ctb_cyan "ctb_cyan")
$(ctb_grey "ctb_grey")
$(ctb_white "ctb_white")
";
or: echo -e "my text $(ct_red "red mark") to know..."

### some symbols:
# https://www.w3schools.com/charsets/ref_utf_symbols.asp
#
# big fail and red: \xE2\x9D\x8C, posix/utf8:
echo -e "
   \u2714 =HEAVY CHECK MARK;
   \u2713 =CHECK MARK;
   \u274c = cross mark";
   # hex codes for utf8 presentation
   # 2715 MULTIPLICATION X

echo -e '
   ☑ = \u2611 done
   ☒ = \u2612 fail
   ☐ = \u2610 to do
';