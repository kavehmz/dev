#!/usr/bin/env bash

if [ "$(which gcloud)" == "" ]
then
	echo "install google cloud sdk"
	echo "deb http://packages.cloud.google.com/apt cloud-sdk-stretch main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
	apt-get update && apt-get install -y google-cloud-sdk kubectl
	# kubectl completion bash > /etc/bash_completion.d/kubectl
fi

if [ "$(which aws)" == "" ]
then
	echo "installing aws cli"
	cd /tmp
	wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
	unzip awscli-bundle.zip
	./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
	rm -rf /tmp/awscli-bundle*
fi