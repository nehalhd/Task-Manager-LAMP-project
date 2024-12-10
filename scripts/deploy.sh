#!/bin/bash

# Exit if any command fails
set -e

# Define repository URL and name
REPO_URL="https://github.com/nehalhd/Task-Manager-LAMP-project.git"
REPO_NAME=$(basename "$REPO_URL" .git)

# Print the steps
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "Starting the Deployment Process"

# Check if the repository is already cloned, else clone it
if [ ! -d "./$REPO_NAME" ]; then
  echo "Repository not found, cloning it now..."
  git clone $REPO_URL
  cd $REPO_NAME
else
  echo "Repository already exists, pulling the latest changes..."
  cd $REPO_NAME
  git pull origin main
fi

# Install Composer dependencies
echo "Installing Composer dependencies..."
composer install --no-interaction

# Ensure Apache and MySQL are running
echo "Ensuring Apache and MySQL are running..."
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql

# Check if MySQL database exists; if not, create it
DB_NAME="taskdb"
echo "Checking if the database $DB_NAME exists..."
if ! mysql -u root -e "USE $DB_NAME;" 2>/dev/null; then
  echo "Database not found, creating it..."
  mysql -u root -e "CREATE DATABASE $DB_NAME;"
fi

# Set up the database schema (ensure the db_schema.sql exists in the repo)
if [ -f "db_schema.sql" ]; then
  echo "Setting up the database schema..."
  mysql -u root $DB_NAME < db_schema.sql
else
  echo "Warning: db_schema.sql not found. Skipping database setup."
fi

# Copy project files to Apache's public directory
echo "Copying project files to Apache's directory..."
sudo cp -r . /var/www/html/$REPO_NAME
sudo chown -R www-data:www-data /var/www/html/$REPO_NAME
sudo chmod -R 755 /var/www/html/$REPO_NAME

# Restart Apache to apply changes
echo "Restarting Apache..."
sudo systemctl restart apache2

# Adjust firewall settings (only if necessary)
echo "Configuring firewall to allow HTTP traffic..."
sudo ufw allow in "Apache"
sudo ufw reload

# Final message
echo "Deployment completed successfully!"

