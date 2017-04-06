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
chown -R root:root .
chomod -R 0755 html
mv html /usr/share/nginx/
aws s3 cp "s3://${s3bucketName}/nginx-config/nginx.conf" /etc/nginx/nginx.cong
aws s3 cp "s3://${s3bucketName}/nginx-config/default.conf" /etc/nginx/conf.d/default.cong
systemctl start nginx
aws s3 cp "s3://${s3bucketName}/build.sh" .
sh build.sh
