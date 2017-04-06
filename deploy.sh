#!/bin/bash

# Store config files in s3 bucket
s3bucketName="sekure-archive-ec2"

if [ ! -x /usr/sbin/nginx ]; then
    echo "Nginx not installed"
    echo "Installing Nginx"
    apt-get update -y
    apt-get install nginx -y
    ufw app list
    ufw allow 'Nginx HTTPS'
  else
    echo "Nfinx already installed"
fi
systemctl stop nginx
echo "Preparing File permissions..."
useradd --no-create-home nginx
chown -R root:root .
chmod -R 0755 html

echo "Installing Files..."
rsync -a html/ /usr/share/nginx/html/
aws s3 cp "s3://${s3bucketName}/default.conf" /etc/nginx/conf.d/default.conf
systemctl start nginx
echo "Starting Nginx Sever..."


echo "Building API..."
sh build.sh
