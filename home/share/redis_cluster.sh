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
 (gem list --local|grep -q redis) || gem install redis

for i in {1..5}
do
	echo $i
	redis-cli -p 7000 CLUSTER MEET 127.0.0.1 700$i
done

echo "waiting for redis instances to meet"
sleep 1

echo "setting up a sample redis cluster"
for i in {0..2}
do
	echo $i
	SLAVE=$(($i+3))
	MASTERNODE=$(redis-cli -p 7000 cluster nodes|grep 127.0.0.1:700$i|cut -d' ' -f1)
	echo "$SLAVE will be slave of $MASTERNODE"
	redis-cli -p 700$SLAVE CLUSTER REPLICATE $MASTERNODE
done
