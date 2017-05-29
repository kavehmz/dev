#!/bin/bash -x

if [ ! -d /opt/go ]
then
	echo "installing go"
	curl --silent https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz -o /tmp/go.tar.gz
	mkdir -p /opt/go/goroot
	tar --gzip -xf /tmp/go.tar.gz -C /tmp
	mv /tmp/go/* /opt/go/goroot/
fi

[ ! -d /opt/flame ] && git clone https://github.com/brendangregg/FlameGraph.git /opt/flame

if [ ! -d /opt/hub ]
then
	git clone https://github.com/github/hub.git /opt/hub
	cd /opt/hub/
	export GOROOT=/opt/go/goroot/
	export PATH=$PATH:/opt/go/goroot/bin
	script/build
fi
rm -rf /tmp/go*
