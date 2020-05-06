#!/bin/bash

sudo apt update -y

# Installing git
sudo apt install git -y

# Installing docker
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt update -y && sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker $USER
newgrp docker

# Installing docker-compose
sudo apt install docker-compose -y

# Installing kubernetes
sudo apt install apt-transport-https -y
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt update -y && sudo apt install kubectl -y

# Running kubernetes
echo 'Running kubernetes'
cd /opt && sudo git clone https://github.com/danilobrinu/udacity-cloud-devops-engineer-project-5.git capstone.io
cd /opt/capstone.io && docker stack deploy --orchestrator=kubernetes -c ./etc/docker/docker-compose.yml capstone
