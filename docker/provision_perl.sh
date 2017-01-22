#!/bin/bash -x

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