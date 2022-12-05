#!/usr/bin/env bash
set -e
# adding extra repos
echo "deb http://ftp.debian.org/debian bullseye-backports main" > /etc/apt/sources.list.d/bullseye_backports.list

# install basic commands
apt-get update
apt-get install -y git unzip apt-transport-https curl wget bzip2 build-essential ack-grep apt-utils htop jq tmate tmux nano graphviz locales-all

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker admin

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /bin/


# kidn
curl -Lo /kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x /kind
mv /kind /bin/kind

# install go
curl -L https://golang.org/dl/go1.17.linux-amd64.tar.gz -o /tmp/go1.17.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/go1.17.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/bash.bashrc
