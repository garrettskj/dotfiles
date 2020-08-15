#!/bin/bash

# This script gets the requested password from a keepass file.
#
# Usage: gp [-u] [-p] [-c] [-d] [-n] name_of_entry"
#
# Cache this to the Gnome-keyring
secret-tool store --label=KPDB name keepass

KEYRING_ID=keepass
PASSWORD_PATH="$2"

function trim {
    local var="${*:-$(</dev/stdin)}"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

password=$(secret-tool lookup name "$KEYRING_ID")
info=$(echo "$password" | keepassxc-cli show --show-protected --quiet "$PASSWORD_STORE" "$PASSWORD_PATH")

OUT_TO_SCREEN=false

while getopts ":upncd" opt; do
  case ${opt} in
    u ) output=$(echo "$info" | grep -i "username: " | cut -d: -f2 | trim)
      ;;
    p ) output=$(echo "$info" | grep -i "password: " | cut -d: -f2 | trim)
      ;;
    n ) output=$(echo "$info" | grep -i "notes: " | cut -d: -f2 | trim)
      ;;
    c ) OUT_TO_SCREEN=true
      ;;
    d ) output=$(echo "$info" | tail -n +2) # dump it all
      ;;
  esac
done
shift $((OPTIND -1))

if [ "$OUT_TO_SCREEN" = true ]
 then
  echo "$output"
 else
  echo "$output" | xclip -sel clip
fi

# Lock me back up when i'm done.
secret-tool clear name keepass
