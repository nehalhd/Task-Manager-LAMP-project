# Task-Manager-LAMP Project Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [Installation Guide](#installation-guide)
   - [Running on an Ubuntu EC2 Instance (Default)](#running-on-an-ubuntu-ec2-instance-default)
   - [Running on a CentOS EC2 Instance (Optional)](#running-on-a-centos-ec2-instance-optional)
4. [Project Architecture](#project-architecture)
5. [Troubleshooting](#troubleshooting)

---

## Project Overview

The Task Manager LAMP Project is a PHP-based web application powered by a LAMP stack (Linux, Apache, MySQL, PHP). The project repository contains the application files, database scripts, and automation scripts for seamless deployment..

### Key Features
- Automated deployment script for Ubuntu-based EC2 instances.
- Modular LAMP architecture for scalability and ease of development.
- User-friendly interface for task management.

### Tech Stack
- **Backend**: PHP  
- **Frontend**: HTML/CSS/JavaScript  
- **Database**: MySQL  
- **Web Server**: Apache  
- **Hosting Environment**: AWS EC2  

*Note: The default operating system is Ubuntu. CentOS deployment is possible but requires manual configuration.*

---

## Prerequisites

Before you begin, ensure:
1. An AWS EC2 instance with Ubuntu 20.04 or later (default).
2. SSH access to the instance using a PEM key.
3. Git installed locally to clone the repository.
4. Basic familiarity with Linux commands.

---

## Installation Guide

### Running on an Ubuntu EC2 Instance (Default)

1. **Launch an Ubuntu EC2 Instance**:
   - Select Ubuntu 20.04 or later as the AMI.
   - Open necessary ports (HTTP: 80, SSH: 22) in the security group.

2. **Log in to your EC2 instance**:
   ```bash
   ssh -i your-key.pem ubuntu@<instance-ip>
   ```
   
3. **Update system packages**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
   
4. **Clone the repository**:
   ```bash
   git clone https://github.com/nehalhd/Task-Manager-LAMP-project.git
   cd Task-Manager-LAMP-project
   ```

5. **Run the installation script**:
   ```bash
   chmod +x /scripts/setup.sh
   ./scripts/setup.sh
   ```
   
6. **Run the Deployment script**:
   ```bash
   chmod +x /scripts/deploy.sh
   ./scripts/deploy.sh
   ```
    This script performs the following:
      - Installs LAMP stack components (Apache, MySQL, PHP).
      - Configures MySQL database and creates the required schema.
      - Deploys the application files to the Apache web root (/var/www/html)

7. **Access the application**:
  - Open your browser and navigate to: http://<instance-ip>.

---

### Running on a CentOS EC2 Instance (Optional)
*Note: A script for CentOS is not currently provided. Use these steps for manual deployment if CentOS is required.*

1. **Launch a CentOS EC2 Instance**:
  - Choose CentOS 7 or 8 as the AMI.
  - Open necessary ports (HTTP: 80, SSH: 22) in the security group.

2. **Log in to your EC2 instance**:
   ```bash
   ssh -i your-key.pem centos@<instance-ip>
   ```
   
3. **Update system packages**:
   ```bash
   sudo yum update -y
   ```
   
4. **Install LAMP stack components**:
   ```bash
    sudo yum install httpd mariadb-server php php-mysqlnd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd
    sudo systemctl start mariadb
    sudo systemctl enable mariadb
   ```

5. **Set up the MySQL database**:
   - Secure the installation:
     ```bash
     sudo yum update -y
     ```
   - Create the database and import the schema manually.

6. **Clone the repository and deploy files**:
   ```bash
   git clone https://github.com/nehalhd/Task-Manager-LAMP-project.git
   sudo cp -r Task-Manager-LAMP-project/src/* /var/www/html/
   sudo systemctl restart httpd
   ```

7. **Access the application**:
    - Navigate to: http://<instance-ip>.

---

## Project Architecture

```graphql
Task-Manager-LAMP-project/
├── index.php           # Main PHP file for the application
├── style.css           # CSS styles for the application
├── scripts/            # Automation and database setup scripts
│   ├── create_database.sql # SQL script to set up the database
│   ├── deploy.sh          # Script to deploy the application
│   └── setup.sh           # Script to set up the environment
└── .gitignore          # Git ignore file

 ```

## Troubleshooting:

```markdown

|             Issue           | 	Solution                                                                                                   | 
|-----------------------------|--------------------------------------------------------------------------------------------------------------|
| Application not loading     | Ensure Apache is running: bash sudo systemctl start apache2 (Ubuntu) or sudo systemctl start httpd (CentOS). | 
| Permission issues           | Run chmod +x /scripts/setup.sh to make the script executable.                                                |
| Permission issues           | Run sudo chown -R apache:apache /path/to/project       # CentOS                                              |

```
