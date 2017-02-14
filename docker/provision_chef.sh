#!/bin/bash -x

curl -s -o /tmp/chefdk_1.1.16-1_amd64.deb https://packages.chef.io/files/stable/chefdk/1.1.16/debian/8/chefdk_1.1.16-1_amd64.deb
[ "$(sha256sum /tmp/chefdk_1.1.16-1_amd64.deb|cut -d' ' -f1|tail -c 16)" == "d4201b37d2681a6" ] &&
	dpkg -i tmp/chefdk_1.1.16-1_amd64.deb
rm -f /tmp/chefdk_1.1.16-1_amd64.deb
