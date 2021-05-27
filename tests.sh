#!/bin/bash

#Stop and remove every mba container
docker rm -f $(docker ps | grep mba | cut -f1 -d" ")

#Create container images from dockerfiles
sudo docker build -t mba-nginx-image:1.0 nginx/

sudo docker build -t mba-mysql-image:1.0 mysql/

#Create nginx container from image 
sudo docker run --name mba-nginx-container -d -p 8081:80 mba-nginx-image:1.0

#Assign nginx container URI to variable
NGINX_CONTAINER_IP='http://$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mba-nginx-container)'
echo -e "\nThe Nginx container IP is $NGINX_CONTAINER_IP"

sleep 5

#Curl from host to container IP on container-nginx port 80 (Nginx default)
echo -e "\nCurl from host to container IP"
curl -s $NGINX_CONTAINER_IP | grep 'Welcome'

#Curl from host to container IP on host port 8081 (forwarded from container 80 -> 8081)
echo -e "\nCurl from host to host IP (port forwarded)"
curl -s http://localhost:8081 | grep 'Welcome'

#Curl from remote container-mysql to container-nginx IP on container nginx port 80 (Nginx default)
echo -e "\nCurl from mysql container to container IP"
sudo docker run --rm --name mba-mysql-container -it mba-mysql-image:1.0 "curl -s '$NGINX_CONTAINER_IP'" | grep 'Welcome'

=======

NGINX_CONTAINER_IP=$(sudo docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mba-nginx-container)
echo "\nThe Nginx container IP is $NGINX_CONTAINER_IP"

#Curl from host to container IP on container-nginx port 80 (Nginx default)
echo "\nCurl from host to container IP"
curl -s $NGINX_CONTAINER_IP | grep 'Welcome'

#Curl from host to container IP on host port 8081 (forwarded from container 80 -> 8081)
echo "\nCurl from host to host IP (port forwarded)"
curl -s http://localhost:8081 | grep 'Welcome'

#Curl from remote container-mysql to container-nginx IP on container nginx port 80 (Nginx default)
echo "\nCurl from mysql container to container IP"
sudo docker run --rm --name mba-mysql-container -it mba-mysql-image:1.0 "curl -s '$NGINX_CONTAINER_IP'" | grep 'Welcome'
