#!/bin/bash

# Exit if any command fails
set -e

# Constants for MySQL credentials
MYSQL_ROOT_PASSWORD="StrongPassword123!"
MYSQL_USER="root"
MYSQL_PASSWORD="StrongPassword123!
MYSQL_DATABASE="taskdb"
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


# Secure MySQL installation if not done already
echo "Securing MySQL installation..."
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$MYSQL_ROOT_PASSWORD';" || true
sudo mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

# Check if the database exists and create it if necessary
echo "Checking if the database $MYSQL_DATABASE exists..."
DB_EXISTS=$(mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES LIKE '$MYSQL_DATABASE';" 2>/dev/null | grep "$MYSQL_DATABASE" || true)
if [ -z "$DB_EXISTS" ]; then
    echo "Database not found, creating it..."
    sudo mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE $MYSQL_DATABASE;"
    sudo mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
    sudo mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost';"
    sudo mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
else
    echo "Database $MYSQL_DATABASE already exists."
fi

# Install Composer dependencies
echo "Installing Composer dependencies..."
if ! [ -x "$(command -v composer)" ]; then
    echo "Composer not found, installing Composer..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php
    sudo mv composer.phar /usr/local/bin/composer
fi
composer install


# Ensure Apache and MySQL are running
echo "Ensuring Apache and MySQL are running..."
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mysql
sudo systemctl enable mysql

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

