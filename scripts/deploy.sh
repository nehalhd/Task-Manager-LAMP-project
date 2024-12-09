#!/bin/bash
APP_DIR="/var/www/html/Task-Manager-LAMP-project"
DB_USER="root"
DB_PASSWORD="StrongPassword123!"

# Clone the application
sudo git clone https://github.com/nehalhd/Task-Manager-LAMP-project.git $APP_DIR

# Set permissions
sudo chown -R apache:apache $APP_DIR

# Create the database
sudo mysql -u$DB_USER -p$DB_PASSWORD -e "
CREATE DATABASE IF NOT EXISTS taskdb;
USE taskdb;
CREATE TABLE IF NOT EXISTS tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);"

echo "Application deployed successfully!"