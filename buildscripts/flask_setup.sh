#!/bin/bash

sudo apt install nginx git python3-pip python3-flask libpcre3 libpcre3-dev -y
sudo pip3 install virtualenv

if [ -z "$1" ]
then
 echo "Specify a name for the Flask Setup"
 exit 0
else
 if [ ! -d /opt/$1 ]; then
  sudo mkdir -p /opt/$1
  sudo mkdir -p /opt/$1/templates
 fi

 ## Configure all the generic permissions
 sudo useradd $1
 sudo usermod -a -G $1 www-data

 # do the following so that we can actually setup files
 sudo usermod -a -G $1 $USER
 sudo chown -R $USER:$USER /opt/$1

 # time to configure flask
 cd /opt/$1
 virtualenv $1env
 source $1env/bin/activate

 pip3 install uwsgi flask 

 touch /opt/$1/$1.py

 echo "\
from flask import Flask, render_template
application = Flask(__name__)

@application.route(\"/$1/\")
def hello():
    return \"<h1 style='color:blue'>Hello There!</h1>\"

if __name__ == \"__main__\":
    application.run(host='0.0.0.0')
" > /opt/$1/$1.py

 echo "\
from $1 import application

if __name__ == \"__main__\":
    application.run()
" > /opt/$1/$1_wsgi_wrapper.py
 
 deactivate

 echo "\
[uwsgi]
module = $1_wsgi_wrapper

master = true
processes = 5

socket = $1.sock
chmod-socket = 660
vacuum = true

die-on-term = true
" > /opt/$1/$1_uwsgi.ini
 
 echo "\
[Unit]
Description=uWSGI instance to serve $1
After=network.target

[Service]
User=$1
Group=$1
WorkingDirectory=/opt/$1
Environment=\"PATH=/opt/$1/$1env/bin\"
ExecStart=/opt/$1/$1env/bin/uwsgi --ini $1_uwsgi.ini

[Install]
WantedBy=multi-user.target
" > /opt/$1/$1.service

 sudo cp /opt/$1/$1.service /etc/systemd/system/

 echo "\
server {
    listen 80;
    server_name $1;

    ## this is specific to this flask instance
    ## if you want multiple instances
    ## add the locations to a single server file
    
    location /$1/ {
        include uwsgi_params;
        uwsgi_pass unix:/opt/$1/$1.sock;
    }
}
"> /opt/$1/$1-nginx.conf

 ## this scripts overwrites the existing configuration
 ## if you want multiple flask apps
 ## simply concatenate all the locations together
 ## in a single server file.
 sudo cp /opt/$1/$1-nginx.conf /etc/nginx/sites-available/$1-nginx.conf
 sudo ln -s /etc/nginx/sites-available/$1-nginx.conf /etc/nginx/sites-enabled/$1-nginx.conf

 if [ -f /etc/nginx/sites-enabled/default ]
 then 
  sudo rm /etc/nginx/sites-enabled/default
 fi

 sudo chown -R $1:$1 /opt/$1
 sudo chmod 750 /opt/$1

 sudo systemctl enable $1
 sudo systemctl enable nginx

fi
