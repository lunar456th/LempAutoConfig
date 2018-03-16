#!/bin/bash


## Ubuntu 16.04 + Nginx + PHP7.0 + MariaDB
## Auto Installation and Configuration


## Prerequisite

#sudo sed -i 's/us.archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
sudo apt -y install git
sudo rm /var/lib/dpkg/lock


## Install the latest Nginx Web Server

# First stop and remove Apache
sudo service apache2 stop 2>/dev/null
sudo apt remove --purge apache2 apache2-utils
sudo rm -rf /etc/apache2
sudo apt -y autoremove

# Add the nginx repository, update then install nginx
sudo add-apt-repository -y ppa:nginx/development
sudo apt -y update
sudo apt -y install nginx

# Start nginx
sudo systemctl unmask nginx
sudo systemctl start nginx

# Enable nginx to auto start at boot time
sudo systemctl enable nginx

# Edit the config and set www-data as the Nginx process user
# Change user nginx; to user www-data;
sudo sed -i 's/user nginx;/user www-data;/g' /etc/nginx/nginx.conf

# Reload nginx
sudo systemctl reload nginx


## Install MariaDB

# Install the required package below, you should have already installed this in the first step if not install it now
sudo apt -y install software-properties-common

# Imports keys
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8

# Add the repository then update
sudo add-apt-repository -y 'deb [arch=amd64,i386,ppc64el] http://mariadb.mirror.anstey.ca/repo/10.1/ubuntu xenial main'
sudo apt -y update
sudo apt -y upgrade

# Install MariaDB server and client
sudo apt -y install mariadb-server mariadb-client
# (During the install you will get prompts to set a root password just press enter each time until it finishes)

# Start the server
sudo systemctl start mysql

# Enable mariadb to auto start at boot time
sudo systemctl enable mysql

# Run the post installation security script
sudo mysql_secure_installation


## Install PHP7

# Add the php repository
sudo add-apt-repository -y ppa:ondrej/php
sudo apt -y update

# Install PHP7 and PHP7 extensions
sudo apt -y install php-pear php-imagick php7.0 php7.0-cli php7.0-dev php7.0-common php7.0-curl php7.0-json php7.0-gd php7.0-mysql php7.0-mbstring php7.0-mcrypt php7.0-xml php7.0-fpm

# Start php7.0-fpm
sudo systemctl start php7.0-fpm


## Create a defualt Nginx Server Block file

# Remove the default.conf symlink in sites-enabled directory
sudo rm /etc/nginx/sites-enabled/default

# Move the file under /etc/nginx/conf.d/ directory
sudo mv -f LempAutoConfig/default.conf /etc/nginx/conf.d/default.conf

# Check the configuration file for any errors
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx


## Test PHP

# create a test file in the webroot directory
sudo mv LempAutoConfig/test.php /usr/share/nginx/html/test.php


# Open a browser and enter 192.168.0.1/test.php and check if it works
# After test, replace ip address with your actual IP on /etc/nginx/conf.d/default.conf
# The End.

