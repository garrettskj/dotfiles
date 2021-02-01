#!/bin/bash 

# make the directory structure:

LOCATION=$1

# stand up the base structure
touch $1/ansible.cfg
mdkir -p $1/group_vars
touch $1/group_vars/all
touch $1/hosts

# base playbook info
mkdir -p $1/roles
mkdir -p $1/roles/device_name

# template directory
mkdir -p $1/roles/device_name/templates
touch $1/roles/device_name/templates/jinja_template.j2

# tasks folder
mkdir -p $1/roles/device_name/tasks
touch $1/roles/device_name/tasks/main.yml

# variables and custom configuration
mkdir -p $1/roles/device_name/vars
touch $1/roles/device_name/vars/main.yml

# build the playbook
touch $1/playbook.yaml
