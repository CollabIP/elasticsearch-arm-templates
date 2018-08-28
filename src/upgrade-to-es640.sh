#!/bin/bash

# upgrade-to-es640.sh
# Upgrade Elasticsearch to v6.4.0
# Author: D. Lowrance
# Creation date 8.28.2018
#
# Run as root
# Copy to any local dir
# Runline
#      
#    bash upgrade-to-es640.sh
#
############################

# Make a copy of elasticsearch.yml (just in case)
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.mybak

# Rollback monit version due to bug that won't allow stop command
apt-get install monit=1:5.16-2

# Stop service
monit stop elasticsearch
sleep 5s

# Confirm service stopped
monit status elasticsearch

# Download and install the public signing key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# install the apt-transport-https package on Debian before proceeding:
apt-get install apt-transport-https

# Save the repository definition to /etc/apt/sources.list.d/elastic-6.x.list:
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

# install the Elasticsearch Debian package
apt-get update && sudo apt-get install elasticsearch

# confirm the new version deployed
apt list elasticsearch

# start the service
monit start elasticsearch
sleep 5s

# Check the status
monit status elasticsearch