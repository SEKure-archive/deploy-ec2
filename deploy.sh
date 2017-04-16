#!/bin/bash

# The S3 bucket containing EC2 related configuration files
S3_BUCKET="sekure-archive-ec2"

# Install Nginx if it is not already installed
if [ ! -x /usr/sbin/nginx ]; then
    echo "Nginx not installed, installing..."
    sudo apt-get update -y
    sudo apt-get install -y nginx
    sudo ufw app list
    sudo ufw allow 'Nginx HTTPS'
    sudo useradd --no-create-home nginx
else
    echo "Stopping Nginx..."
    sudo systemctl stop nginx
fi

# Install static files
echo "Setting static file permissions..."
sudo chown -R root:root .
sudo chmod -R 0755 html
echo "Copying files..."
sudo rsync -a html/ /usr/share/nginx/html/
sudo aws s3 cp "s3://${S3_BUCKET}/default.conf" /etc/nginx/conf.d/default.conf

# Start Nginx
echo "Starting Nginx server..."
sudo systemctl start nginx

# Compile and start Express server
echo "Building Express server..."
bash build.sh
