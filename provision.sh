#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive

[[ "$(uname -a)" == *"Ubuntu"* ]] && add-apt-repository ppa:nviennot/tmate
[[ "$(uname -a)" == *"Debian"* ]] && echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie_backports.list
apt-get update
apt-get install -y libjson-perl vim emacs tmate git httpie locate curl cpanminus exuberant-ctags vim-nox htop iotop atop sysdig ack-grep graphviz linux-tools-3.16
apt-get remote --pruge -y ghostscript
apt-get -y upgrade
cpanm  -L /usr/local/perl Perl::Tidy@20140711

if [ ! -f /root/.ssh ]
then
	mkdir /root/.ssh
	cp /home/vagrant/.ssh/authorized_keys /root/.ssh/authorized_keys
	chmod 600 /root/.ssh/ -R
fi

if [ ! -f /home/share/secret/github_token ]
then
   echo "Actoin Required: You need to create /home/share/secret/github_token and save your github token there. Visit https://github.com/settings/tokens."
   exit 1;
fi

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
	curl --silent https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz -o /tmp/go.tar.gz
	tar --gzip -xf /tmp/go.tar.gz -C /opt
	mkdir -p /opt/gopath
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

exit 0
