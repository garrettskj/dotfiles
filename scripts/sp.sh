#!/bin/bash

# This script will set passwords into keepass
#
# Usage: sp name_of_entry username"
#
# Cache this to the Gnome-keyring
secret-tool store --label=KPDB name keepass

KEYRING_ID=keepass
PASSWORD_PATH="$1"

function trim {
    local var="${*:-$(</dev/stdin)}"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# set a new entry and generate a password.
password=$(secret-tool lookup name "$KEYRING_ID")
info=$(echo "$password" | keepassxc-cli add -glUn -u "$2" "$PASSWORD_STORE" "$PASSWORD_PATH" 2> /dev/null)

# If an incorrect keepass password is provided
# Or if an entry already exists, the errorcode will be 1
if [ "$?" -eq 1 ]
then
  echo "Password unable to be added."
  echo "If you know you entered a correct password, use a new name."
  exit 1
fi  

# get the password that was just generated
info=$(echo "$password" | keepassxc-cli show --show-protected --quiet "$PASSWORD_STORE" "$PASSWORD_PATH")

# Crop out all the extra data
output=$(echo "$info" | grep -i "password: " | cut -d: -f2 | trim)

# output to clipboard and stdout
echo "$output" | xclip -sel clip
xclip -sel clip -out

# Lock me back up when i'm done.
secret-tool clear name keepass
