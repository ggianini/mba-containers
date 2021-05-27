#!/bin/bash

#Create container images from dockerfiles
sudo docker build -t mba-nginx-image:1.0 nginx/

sleep 30

sudo docker build -t mba-mysql-image:1.0 mysql/

sleep 30

#Create nginx container from image 
sudo docker run --name mba-nginx-container -d -p 8081:80 mba-nginx-image:1.0

#Assign nginx container URI to variable
NGINX_CONTAINER_IP=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mba-nginx-container)

#Curl from host to container IP on container-nginx port 80 (Nginx default)
curl -s $NGINX_CONTAINER_IP | grep 'Welcome'

#Curl from host to container IP on host port 8081 (forwarded from container 80 -> 8081)
curl -s http://localhost:8081 | grep 'Welcome'

#Curl from remote container-mysql to container-nginx IP on container nginx port 80 (Nginx default)
sudo docker run --rm --name mba-mysql-container -it mba-mysql-image:1.0 "curl -s '$NGINX_CONTAINER_IP'" | grep 'Welcome'
