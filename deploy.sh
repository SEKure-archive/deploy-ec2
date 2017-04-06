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
chmod -R 0755 html
rsync -a html/ /usr/share/nginx/html/
aws s3 cp "s3://${s3bucketName}/nginx-config/nginx.conf" /etc/nginx/nginx.conf
aws s3 cp "s3://${s3bucketName}/nginx-config/default.conf" /etc/nginx/conf.d/default.conf
systemctl start nginx
aws s3 cp "s3://${s3bucketName}/build.sh" .
sh build.sh
