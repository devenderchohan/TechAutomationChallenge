#!/bin/bash
sudo apt-get update
sudo apt-get install -y cloud-utils apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker ubuntu
#Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#Make the application up as a container.
docker run -d -p 8080:3000 --env VTT_DBUSER=${username} --env VTT_DBPASSWORD=${password} --env VTT_DBNAME=${name} --env VTT_DBPORT=${port} --env VTT_DBHOST=${host} --env VTT_LISTENHOST=0.0.0.0 --env VTT_LISTENPORT=3000 servian/techchallengeapp serve

