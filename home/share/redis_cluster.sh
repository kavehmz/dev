# To establish a cluster of redis servers with 3 masters and 3 slaves just run this script in an empty directory.
# Redis clusters will be created and started on ports 700[0-5].

for i in {0..6}
do
	DNAME=700$i
	echo $DNAME
	echo "creating directory"
	mkdir -p 700$i
echo "creating $DNAME/redis.conf"
cat > $DNAME/redis.conf <<- EOM
port $DNAME
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
EOM
	echo "running redis-server in tmux $DNAME/redis.conf"
	tmux new -s $DNAME -d -c $DNAME 'redis-server redis.conf'
done

apt-get install -y ruby gem
gem install redis

echo "setting up a sample redis cluster"
/usr/share/doc/redis-tools/examples/redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005
