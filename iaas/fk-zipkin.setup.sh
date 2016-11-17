#!/bin/bash
#setup infra-cli and default srcs.list
echo "deb http://wzy-mirror.nm.flipkart.com/ftp.debian.org/debian wheezy-backports main" > /etc/apt/sources.list.d/wzy-backports.list
echo "deb http://10.47.2.22/repos/infra-cli/3 /" > /etc/apt/sources.list.d/infra-cli-svc.list
apt-get update
apt-get install --yes --allow-unauthenticated infra-cli

#setup your package
echo "w3_zipkin_prod" > /etc/fk-zipkin-bucket
echo "team_name=mobile-api" > /etc/default/nsca_wrapper

reposervice --host repo-svc-app-0001.nm.flipkart.com --port 8080 env --name fk-zipkin --appkey fk-zipkin > /etc/apt/sources.list.d/fk-zipkin.list
apt-get update
apt-get install --yes --allow-unauthenticated fk-zipkin
apt-get install --yes --allow-unauthenticated fk-nagios-common