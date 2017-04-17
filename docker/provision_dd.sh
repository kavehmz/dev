DATADOG_API_KEY=$1

echo "[$DATADOG_API_KEY]"

[ "$DATADOG_API_KEY" = "" ] && exit 255

echo 'deb https://apt.datadoghq.com/ stable main' > /etc/apt/sources.list.d/datadog.list
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 C7A7DA52

apt-get update
apt-get install datadog-agent

sh -c "sed 's/api_key:.*/api_key: $DATADOG_API_KEY/' /etc/dd-agent/datadog.conf.example > /etc/dd-agent/datadog.conf"
sh -c "sed -i 's/# hostname:.*/hostname: kmz-docker-dev/' /etc/dd-agent/datadog.conf"
sh -c "sed -i 's/# apm_enabled:.*/apm_enabled: true/' /etc/dd-agent/datadog.conf"
