#!/bin/bash -x

# setup apt
export DEBIAN_FRONTEND=noninteractive

apt-get install -y  ack-grep apt-utils cloc dnsutils emacs etckeeper exuberant-ctags gdb \
					htop jq libjson-perl locate ntp python-requests tmate tmux vim vim-nox \
                    python3-pip sudo bash-completion nano linux-tools 

apt-get -t stretch-backports install -y redis-server ansible

