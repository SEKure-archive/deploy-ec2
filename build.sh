#!/bin/bash

# Stop the current server container, if any
CONTAINER_ID=$(sudo docker ps --format "{{.ID}}")
if [[ $CONTAINER_ID ]]; then
    sudo docker kill $CONTAINER_ID
    sudo docker rm $CONTAINER_ID
fi

sudo aws s3 cp s3://sekure-archive-ec2/psql.sh .
sudo chmod +x psql.sh

sudo apt install -y awscli docker.io
sudo systemctl start docker.service

sudo git clone https://github.com/SEKure-archive/sekure-archive-server
cd sekure-archive-server
sudo git pull origin master

# Build the server container
sudo docker build -t sekure-archive-server .

# Delete unused images
IMAGE_IDS=$(sudo docker images --filter "dangling=true" -q --no-trunc)
if [[ $IMAGE_IDS ]]; then
    sudo docker rmi $IMAGE_IDS
fi

# Run the server container
sudo docker run sekure-archive-server
