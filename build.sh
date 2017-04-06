#!/bin/sh

aws s3 cp s3://sekure-archive-ec2/psql.sh .
chmod +x psql.sh
sudo apt install -y awscli docker.io
sudo systemctl start docker.service
git clone https://github.com/SEKure-archive/sekure-archive-server
cd sekure-archive-server
sudo docker build -t sekure-archive-server .
#sudo docker run -p 80:80 sekure-archive-server
sudo docker run sekure-archive-server
