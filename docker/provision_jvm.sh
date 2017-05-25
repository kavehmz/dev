curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" 'http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz' > /opt/jdk-8u131-linux-x64.tar.gz

cd /opt
tar --gzip -xf jdk-8u131-linux-x64.tar.gz
mv jdk-8u131-linux-x64 jdk

curl -L 'https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.deb' > /opt/scala-2.12.2.deb
dpkg -i /opt/scala-2.12.2.deb

rm -f /opt/scala-2.12.2.deb
rm -f /opt/jdk-8u131-linux-x64.tar.gz