#!/bin/bash

function get_remote_repo_tag_lv() {
    local remote_url="$1"
    local -
    set -eo pipefail

    { git ls-remote --tag --ref "$remote_url" | awk -F'/' '{print $3}' | sort -V | tail -n 1 | sed 's/^v//'; } 2>/dev/null
}

