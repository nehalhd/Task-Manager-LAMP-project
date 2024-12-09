#!/bin/bash

# Update the system
sudo apt update -y
sudo apt upgrade -y

# Install Apache, MariaDB, and PHP
sudo apt install -y apache2 mariadb-server php php-mysql

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
sudo ufw reload

echo "LAMP stack installed successfully on Ubuntu."