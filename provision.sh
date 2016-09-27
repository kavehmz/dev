#!/bin/bash -x

# enable access to root
if [ ! -f /root/.ssh ]
then
	mkdir /root/.ssh
	cp /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys
	chmod 600 /root/.ssh/ -R
fi

# setup apt
export DEBIAN_FRONTEND=noninteractive
apt-get install -y apt-transport-https ca-certificates
apt-get update
apt-get -y upgrade

# adding extra repos
echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie_backports.list
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/postgresql.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# install basic commands
apt-get update
apt-get install -y cloc jq unzip libjson-perl vim emacs tmux tmate git locate curl cpanminus exuberant-ctags vim-nox htop iotop atop sysdig ack-grep graphviz linux-tools
apt-get remove --purge -y ghostscript
apt-get -t jessie-backports install -y redis-server ansible
cpanm  -L /usr/local/perl Perl::Tidy@20140711

# installing docker and its tools
apt-get install -y docker-engine
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

if [ ! -f /home/share/secret/github_token ]
then
   echo "Actoin Required: You need to create /home/share/secret/github_token and save your github token there. Visit https://github.com/settings/tokens."
   exit 1;
fi

# setup gitconfig using github api
if [ ! -f /root/.gitconfig ]
then
	TOKEN=$(cat /home/share/secret/github_token)
	REQ=$(curl --silent "https://api.github.com/user?access_token=$TOKEN")
	USER=$(perl -MJSON -e "print JSON::from_json('$REQ')->{login}")
	NAME=$(perl -MJSON -e "print JSON::from_json('$REQ')->{name}")
	EMAIL=$(perl -MJSON -e "print JSON::from_json('$REQ')->{email}")
	cp /home/share/config/gitconfig /root/.gitconfig
	sed -i.bak s/GITUSER/$USER/g /root/.gitconfig
	git config --global user.email "$EMAIL"
	git config --global user.name "$NAME"
fi

[[ ! -f /root/.bash_profile ]] && cp /home/share/config/bash_profile /root/.bash_profile

if [ ! -d /opt/go ]
then
	echo "installing go"
	curl --silent https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz -o /tmp/go.tar.gz
	mkdir -p /opt/go/goroot
	tar --gzip -xf /tmp/go.tar.gz -C /tmp
	mv /tmp/go/* /opt/go/goroot/
	mkdir -p /opt/go/gopath
	. ~/.bash_profile
fi

if [ ! - ~/.spf13-vim-3  ]
then
	sh <(curl --silent https://j.mp/spf13-vim3 -L)
	vim +GoInstallBinaries +q
fi

[[ ! -d ~/.emacs.d ]] && echo "install emacs spacemacs config" && git clone --recursive https://github.com/syl20bnr/spacemacs ~/.emacs.d

if [ ! -d /opt/hub ]
then
	git clone https://github.com/github/hub.git /opt/hub
	cd /opt/hub/
	script/build
fi

[ ! -d /opt/flame ] && git clone https://github.com/brendangregg/FlameGraph.git /opt/flame

if [ "$(which jekyll)" == "" ]
then
	apt-get install -y bundler ruby-dev
	gem install jekyll
	gem install rouge
	gem install jekyll-paginate
	gem install pygments.rb
fi

if [ ! -f /etc/cron.d/zram ]
then
cat <<End > /opt/zram.sh
#!/bin/bash
set -x
[ -f /sys/block/zram0/disksize ] && exit 0
/sbin/modprobe zram
echo 256M > /sys/block/zram0/disksize
/sbin/mkswap /dev/zram0
/sbin/swapoff -a
/sbin/swapon /dev/zram0
End
	chmod +x /opt/zram.sh
	echo "@reboot root /opt/zram.sh" > /etc/cron.d/zram
	/opt/zram.sh
fi

perl /home/share/update_repos.pl

if [ ! -d /opt/perl5 ]
then
	export PERLBREW_ROOT=/opt/perl5
	mkdir /opt/perl5 && curl -L http://install.perlbrew.pl | bash
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

if [ "$(which protoc)" == "" ]
then
	apt-get install -y autoconf automake libtool curl make g++ unzip
	cd /opt/
	git clone git@github.com:google/protobuf.git
	cd protobuf/
	./autogen.sh
	./configure
	make
	make install
	ldconfig
	go get -u github.com/golang/protobuf/{proto,protoc-gen-go}
fi

exit 0
