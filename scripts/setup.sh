#!/bin/bash

# Update the system
sudo apt update -y
sudo apt upgrade -y

# Install Apache, MariaDB, and PHP
sudo apt install php libapache2-mod-php
sudo apt install -y apache2 mariadb-server php php-mysql
sudo composer require vlucas/phpdotenv
sudo chmod 600 /etc/environment
sudo chmod 600 .env

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure the MariaDB installation
sudo mysql_secure_installation

# Adjust the firewall to allow HTTP traffic
sudo ufw enable
sudo ufw allow in "Apache"
sudo ufw status
sudo ufw reload

echo "LAMP stack installed successfully on Ubuntu."