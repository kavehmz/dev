#!/bin/bash -x

if [ "$(which gcloud)" == "" ]
then
	echo "install google cloud sdk"
	echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
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