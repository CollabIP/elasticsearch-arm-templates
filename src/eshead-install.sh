#!/bin/bash

# eshead-install.sh
# Installs Elasticsearch Head web app to Debian Linux VM
# Author: D. Lowrance
# Creation date 8.23.2018

# To install
#
#  Login as root
#  Copy file to a Linux directory or copy/paste entire contents to new file named eshead-install.sh
#  Run in bash
#
#    Example
#
#      bash eshead-install.sh
#
################
echo "Installing elasticsearch-head"

echo "Update all packages"
apt-get update

echo "Install node.js"
apt install nodejs-legacy

############	
# Install ES-head app
############
echo "Clone the es-head repo in /usr/share/"
cd /usr/share
git clone git://github.com/mobz/elasticsearch-head.git

echo "Go to cloned repo folder"
cd elasticsearch-head

echo "Installing npm" 
apt install npm

# Install eshead (It finds the packages in the current directory)
echo "Installing Elasticsearch Head"
npm install

# Run the ES Webapp. MANUAL START
# echo Starting es-head...
# npm run start &

############
# Configure to run ES-head as a service
############
echo "Configure es-head to run as a service"
# Go to the systemd folder
cd /etc/systemd/system/

# Create service file 'eshead.service 'for ES-head
echo "Create service file"

echo "[Service]" >> eshead.service
echo "WorkingDirectory=/usr/share/elasticsearch-head" >> eshead.service
echo "ExecStart=/usr/bin/npm run start" >> eshead.service
echo "Restart=always" >> eshead.service
echo "StandardOutput=syslog" >> eshead.service
echo "StandardError=syslog" >> eshead.service
echo "SyslogIdentifier=eshead" >> eshead.service
echo "User=root" >> eshead.service
echo "Group=root" >> eshead.service
echo "Environment=NODE_ENV=production" >> eshead.service
echo ""	>> eshead.service
echo "[Install]" >> eshead.service
echo "WantedBy=multi-user.target" >> eshead.service

echo "Start es-head"
systemctl start eshead

echo "Enable es-head to run on boot with 'systemctl enable' command"
systemctl enable eshead