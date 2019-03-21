#!/bin/bash

if [ -z "$1" ]
then
 echo "Usage: $0 'FlaskAppName'"
 echo "!!! CAREFUL !!!"
 exit 0
else
 if [ ! -d /opt/$1 ]; then
  cd /opt/
  sudo rm -rf $1*
  sudo rm -rf /etc/nginx/sites-enabled/$1*
  sudo rm -rf /etc/nginx/sites-enabled/nginx*
  sudo rm -rf /etc/nginx/sites-available/$1*
  sudo rm -rf /etc/nginx/sites-available/nginx*
  sudo rm -rf /etc/systemd/system/$1*
  sudo systemctl daemon-reload
 fi

