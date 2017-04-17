#!/bin/bash -x

# setup apt
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl wget

# adding extra repos
echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie_backports.list

# install basic commands
apt-get update
apt-get install -y  ack-grep apt-utils atop build-essential cloc cpanminus curl \
					dnsutils emacs etckeeper exuberant-ctags gdb git graphviz htop \
					iotop jq libjson-perl linux-tools locate ntp \
					python-requests sysdig tmate tmux unzip vim vim-nox \
					python3-pip sudo bash-completion apt-transport-https
apt-get -t jessie-backports install -y redis-server ansible
apt-get clean