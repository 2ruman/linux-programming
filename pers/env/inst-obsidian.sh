#!/bin/bash

source utils/git_utils.sh

APP_NAME=obsidian
REMOTE_URL=https://github.com/obsidianmd/obsidian-releases
LATEST_VER=$(get_remote_repo_tag_lv "$REMOTE_URL")

if [ -z "$LATEST_VER" ]; then
   echo "Failed to get the latest version of hugo..."
   exit 1
fi

ARCH=amd64
TMP_PATH=/tmp
ARTIFACT="${APP_NAME}_${LATEST_VER}_${ARCH}.deb"
WGET_CMD="wget -c -P $TMP_PATH $REMOTE_URL/releases/latest/download/$ARTIFACT"

$WGET_CMD
RES=$?

if [ "$RES" -ne 0 ]; then
    echo "Failed to downlolad arftifact: $ARTIFACT"
    exit 1
fi

sudo dpkg -i "$TMP_PATH/$ARTIFACT"
RES=$?

if [ "$RES" -ne 0 ]; then
    echo "Failed to install arftifact: $TMP_PATH/$ARTIFACT"
    exit 1
fi

echo "Done"
