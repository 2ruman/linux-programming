#!/bin/bash

DIR_PATH="${HOME}/mydir"

if [ -d "$DIR_PATH" -o -f "$DIR_PATH" ]; then
    echo "The directory or file already exists: $DIR_PATH"
else
    mkdir -p "$DIR_PATH" 2> /dev/null
    [ "$?" -ne 0 ] && echo "Failed to create: $DIR_PATH" && exit 1 \
        || echo "Directory created: $DIR_PATH"
fi
