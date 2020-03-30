#!/bin/bash
#
# Changes author and committer name and email throughout the whole repository.
# Uses a file with the following format:
#
# Config file:
# john@doe.none=John Doe <john.doe@localhost.localdomain>
# foo@bar.none=Foo Bar <foo.bar@localhost.localdomain>
#

if [ ! -e "$1" ]
then
  echo "Config file '$1' does not exist"
  exit 1
fi

export authors_file=$1

git filter-branch -f --env-filter '
    grep "^$GIT_COMMITTER_EMAIL=" "$authors_file" >> /dev/null
    RETVAL=$?
    if [ $RETVAL -eq 0 ]
    then
        get_name () {
            grep "^$1=" "$authors_file" |
            sed "s/^.*=\(.*\) <.*>$/\1/"
        }
    
        get_email () {
            grep "^$1=" "$authors_file" |
            sed "s/^.*=.* <\(.*\)>$/\1/"
        }
    
        name=$(get_name "$GIT_COMMITTER_EMAIL")
        email=$(get_email "$GIT_COMMITTER_EMAIL")
        GIT_AUTHOR_NAME="$name" &&
            GIT_AUTHOR_EMAIL="$email" &&
            GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" &&
            GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
    fi
' -- --all
