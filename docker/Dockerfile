FROM debian:stretch-backports
MAINTAINER kavehmz@gmail.com

RUN apt-get update && apt-get install -y git unzip apt-transport-https curl wget bzip2 build-essential \
                    ack-grep apt-utils cloc dnsutils emacs etckeeper exuberant-ctags gdb \
					htop jq libjson-perl locate ntp python-requests tmate tmux vim vim-nox \
                    python3-pip sudo bash-completion nano linux-tools redis-server

RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-stretch main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/postgresql.list
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update && apt-get install -y google-cloud-sdk kubectl postgresql-10

RUN cd /tmp && \
    wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

RUN curl --silent https://storage.googleapis.com/golang/go1.10rc1.linux-amd64.tar.gz -o /tmp/go.tar.gz && \
    mkdir -p /opt/go/goroot && \
    tar --gzip -xf /tmp/go.tar.gz -C /tmp && \
    mv /tmp/go/* /opt/go/goroot/

RUN rm -rf /tmp/*

RUN apt-get clean

CMD ["/bin/bash"]