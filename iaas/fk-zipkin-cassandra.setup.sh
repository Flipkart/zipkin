#!/bin/bash
#setup infra-cli and default srcs.list
echo "deb http://wzy-mirror.nm.flipkart.com/ftp.debian.org/debian wheezy-backports main" > /etc/apt/sources.list.d/wzy-backports.list
echo "deb http://10.47.2.22/repos/infra-cli/3 /" > /etc/apt/sources.list.d/infra-cli-svc.list
apt-get update
apt-get install --yes --allow-unauthenticated infra-cli

#!/bin/bash -ex

#Include your repo in sources.list
reposervice --host repo-svc-app-0001.nm.flipkart.com --port 8080 env --name zipkin-cassandra --appkey dummykey > /etc/apt/sources.list.d/fk-3p-cassandra-server.list

#Adding a bucket keyspace in the environment.
export CASSANDRA_DEFAULTS="fk-zipkin-cassandra"
echo "team_name=mobile-api" > /etc/default/nsca_wrapper

#Update
sudo apt-get update

#Install cassandra
sudo apt-get install --yes --allow-unauthenticated fk-3p-cassandra
sed -i s/fk-3p-cassandra-yaml/fk-zipkin-cassandra-yaml/g /etc/confd/conf.d/cassandra.yaml.toml
sed -i s/fk-3p-cassandra-env/fk-zipkin-cassandra-env/g /etc/confd/conf.d/cassandra-env.sh.toml
sudo /etc/init.d/fk-config-service-confd restart

# Mount data disk and create directories
mkfs.ext4 /dev/vdb
mount -t ext4 /dev/vdb /opt/
mkdir -p /opt/fk-zipkin-cassandra/data
chmod 777 /opt/fk-zipkin-cassandra/data

# restart cassandra to pick up the directories and latest config.
sudo /etc/init.d/fk-3p-cassandra restart

#start nagios alerting
apt-get install --yes --allow-unauthenticated fk-nagios-common
