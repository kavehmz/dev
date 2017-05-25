echo "deb [arch=amd64] https://osquery-packages.s3.amazonaws.com/xenial xenial main" > /etc/apt/sources.list.d/osquery.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B

apt-get update
apt-get install -y osquery
