#!/bin/bash

# Installing git
sudo apt update -y && sudo apt install git -y

# Installing docker
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt update -y && sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
newgrp docker

# Installing docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

# Installing kubernetes
sudo apt update -y && sudo apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt update -y
sudo apt install -y kubectl

sudo cd /opt && sudo git clone https://github.com/danilobrinu/udacity-cloud-devops-engineer-project-5.git capstone.io
sudo cd /opt/capstone.io && docker stack deploy --orchestrator=kubernetes -c ./etc/docker/docker-compose.yml capstone


echo '<p style="color:blue">blue.</p>' > /var/www/html/index.html

sudo systemctl enable nginx
sudo systemctl start nginx
