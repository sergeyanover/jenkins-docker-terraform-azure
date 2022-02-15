#!/usr/bin/env bash

sudo echo "Port 22" >> /etc/ssh/sshd_config
sudo echo "Port 12000" >> /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg
sudo apt install -y binutils
sudo apt install -y net-tools
sudo apt install -y inetutils-traceroute 

sudo apt install -y unzip
sudo apt install -y mc
sudo apt install -y nmap

#install git
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt install -y git

#install Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y
sudo apt update
sudo apt-cache policy docker-ce
sudo apt install -y docker-ce
#sudo snap install docker

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker azureuser



cd /home/azureuser
git clone https://github.com/sergeyanover/jenkins-docker-terraform-azure.git
cd jenkins-docker-terraform-azure
cd jenkins
docker build -t jenkins .
docker tag jenkins azure-docker-jenkins:v1

docker run --name jenkins -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home azure-docker-jenkins:v1
