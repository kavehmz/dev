# Run this script in an empty directory.
# It will establish a setup of a redis server master with two slaves.
# There will be one sentinel installed along with each redis server.

for i in {0..2}
do
	DNAME=700$i
	SENTINEL=2800$i
	echo $DNAME
	echo "creating directory"
	mkdir -p 700$i

echo "creating $DNAME/redis.conf"
cat > $DNAME/redis.conf <<- EOM
port $DNAME
min-slaves-to-write 1
min-slaves-max-lag 10
EOM

echo "creating $DNAME/sentinel.conf"
cat > $DNAME/sentinel.conf <<- EOM
port $SENTINEL
sentinel monitor mymaster 127.0.0.1 7000 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 10000
sentinel parallel-syncs mymaster 1
EOM

	echo "running redis-server and sentinel"
	tmux new -s $DNAME -d -c $DNAME 'redis-server redis.conf'
	tmux new -s $SENTINEL -d -c $DNAME 'redis-server sentinel.conf --sentinel'
done

echo "setting up a sample redis slaves"
for i in {1..2}
do
	echo $i
	redis-cli -p 700$i SLAVEOF 127.0.0.1 7000
done

