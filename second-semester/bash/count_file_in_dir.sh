#!/bin/bash

DIR=$1

if [ -d "$DIR" ]; then
    COUNT=$(find "$DIR" -maxdepth 1 -type f | wc -l)
    echo "There are $COUNT files in '$DIR'."
else
    echo "'$DIR' is not a directory."
fi
