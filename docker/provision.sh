#!/bin/bash -x

# setup apt
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl wget

# adding extra repos
echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie_backports.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgresql.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

# install basic commands
apt-get update
apt-get install -y  ack-grep apt-utils atop build-essential cloc cpanminus curl \
					emacs etckeeper exuberant-ctags gdb git graphviz htop  \
					iotop jq libjson-perl linux-tools locate ntp \
					python-requests sysdig tmate tmux unzip vim vim-nox
apt-get -t jessie-backports install -y redis-server ansible

if [ ! -d /opt/go ]
then
	echo "installing go"
	curl --silent https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz -o /tmp/go.tar.gz
	mkdir -p /opt/go/goroot
	tar --gzip -xf /tmp/go.tar.gz -C /tmp
	mv /tmp/go/* /opt/go/goroot/
	rm /tmp/go.tar.gz
fi

if [ ! -d /opt/hub ]
then
	git clone https://github.com/github/hub.git /opt/hub
	cd /opt/hub/
	script/build
fi

[ ! -d /opt/flame ] && git clone https://github.com/brendangregg/FlameGraph.git /opt/flame

if [ ! -f /opt/perl5/etc/bashrc ]
then
	export PERLBREW_ROOT=/opt/perl5
	mkdir /opt/perl5
	curl -L http://install.perlbrew.pl | bash
	source /opt/perl5/etc/bashrc
	perlbrew install-cpanm
	grep "#perlbrewrc" ~/.bash_profile -q || echo "source /opt/perl5/etc/bashrc #perlbrewrc" >> ~/.bash_profile
	perlbrew install --notest blead
fi

if [ "$(which gcloud)" == "" ]
then
	echo "install google cloud sdk"
	export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
	echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
	apt-get update && apt-get install -y google-cloud-sdk
	go get google.golang.org/appengine/cmd/aedeploy
	# Not enough RAM to install it through source, so using the gcloud installation
	sed -i -e 's/true/false/' /usr/lib/google-cloud-sdk/lib/googlecloudsdk/core/config.json
	# gcloud components install kubectl
	# ln -s /usr/lib/google-cloud-sdk/bin/kubectl /usr/bin/kubectl
	# kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl
fi

if [ "$(which aws)" == "" ]
then
	echo "installing aws cli"
	cd /tmp
	wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
	unzip awscli-bundle.zip
	./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
fi
exit 0
