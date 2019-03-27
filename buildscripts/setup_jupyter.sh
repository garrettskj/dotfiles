#!/bin/bash

sudo apt install python3-pip python3-dev virtualenv

sudo -H pip3 install --upgrade pip

virtualenv jnotebook

source jnotebook/bin/activate

sudo -H pip3 install jupyter 
sudo -H pip3 install pandas matplotlib seaborn statsmodels

jupyter notebook
