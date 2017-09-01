apt-get install -y -t stretch-backports  openjdk-8-jre-headless ca-certificates-java
curl -L 'https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.deb' > /tmp/scala-2.12.2.deb
dpkg -i /tmp/scala-2.12.2.deb
rm -f /tmp/scala-2.12.2.deb
