#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y software-properties-common curl git

# Add the PHP repository
echo "Adding PHP repository..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y

# Install Apache, MySQL, PHP, and required extensions
echo "Installing Apache, MySQL, PHP, and extensions..."
sudo apt install -y apache2 mysql-server php8.1 php8.1-mysql php8.1-fpm php8.1-cli

# Start and enable Apache and MySQL services
echo "Starting and enabling Apache and MySQL services..."
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure MySQL installation
echo "Securing MySQL installation..."
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

sudo export USERNAME = "root";
sudo export PASSWORD = "StrongPassword123!";
sudo printenv

# Set up the database (replace with your actual database schema)
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS taskdb;"
mysql -u root -p taskdb < db_schema.sql

# Install Composer
echo "Installing Composer..."
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    echo 'ERROR: Invalid Composer installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

# Clone the Task-Manager-LAMP project repository
echo "Cloning the Task-Manager-LAMP project repository..."
git clone https://github.com/nehalhd/Task-Manager-LAMP-project.git
cd Task-Manager-LAMP-project

# Deploy the application files
echo "Deploying application files to /var/www/html..."
sudo cp -r src/* /var/www/html/

# Set proper permissions for the application files
echo "Setting permissions for /var/www/html..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2

# Completion message
echo "Task-Manager-LAMP setup completed successfully!"
echo "Access the application in your browser at: http://<instance-ip>"
