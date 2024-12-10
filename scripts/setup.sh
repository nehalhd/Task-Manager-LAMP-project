#!/bin/bash

# Update and upgrade the system
sudo apt update -y
sudo apt upgrade -y

echo "Start Installing Apache, MySQL, PHP, and other dependencies"

# Install Apache, MySQL, PHP, and other dependencies
sudo apt install -y apache2 mysql-server php8.1 php8.1-mysqli php8.1-fpm curl git

# Install Composer (if not installed already)
if ! command -v composer &> /dev/null; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# Start and enable Apache and MySQL services
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure MySQL installation (prompts will be shown, this needs manual interaction)
sudo mysql_secure_installation

# Set up the firewall to allow HTTP traffic
sudo ufw enable
sudo ufw allow in "Apache"
sudo ufw reload

# Check if we are inside the repository directory
if [ ! -d ".git" ]; then
  echo "Error: Please clone the repository first."
  exit 1
fi

# Set up the database (replace with your actual database schema)
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS taskdb;"
mysql -u root -p taskdb < db_schema.sql

# Install PHP dependencies with Composer
composer install

# Set up Apache (copy the repository files to the proper directory)
sudo cp -r . /var/www/html/$(basename "$(pwd)")
sudo chown -R www-data:www-data /var/www/html/$(basename "$(pwd)")
sudo chmod -R 755 /var/www/html/$(basename "$(pwd)")

# Restart Apache
sudo systemctl restart apache2

echo "LAMP stack and application setup completed successfully!"
