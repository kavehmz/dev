#!/bin/bash -x

# setup apt
export DEBIAN_FRONTEND=noninteractive

# adding extra repos
echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch_backports.list

# install basic commands
apt-get update
apt-get install -y git unzip apt-transport-https curl wget bzip2 build-essential
