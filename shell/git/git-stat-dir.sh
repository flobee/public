#!/bin/bash

dir=$1


if [ "$dir" == "" ]; then
    echo "Directory is required!"
    exit
fi

echo "Git stat for '<dir>'."

git --git-dir="$dir/.git" --work-tree="$dir" status

