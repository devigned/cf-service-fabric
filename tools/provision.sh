#!/usr/bin/env bash

sh -c 'echo "deb [arch=amd64] http://apt-mo.trafficmanager.net/repos/servicefabric/ trusty main" > /etc/apt/sources.list.d/servicefabric.list'
apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893

sh -c 'echo "deb https://deb.nodesource.com/node_4.x trusty main" > /etc/apt/sources.list.d/node.list'
sh -c 'echo "deb-src https://deb.nodesource.com/node_4.x trusty main" > /etc/apt/sources.list.d/node-src.list'
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68576280
apt update

# replace sshd_config and restart
cp -f ./tools/sshd_config /etc/ssh/sshd_config
service sshd restart

# accept eulas ahead of install
debconf-set-selections <<< "servicefabric servicefabric/presenteula select false"
debconf-set-selections <<< "servicefabric servicefabric/accepted-eula-v1 select true"
debconf-set-selections <<< "servicefabric servicefabric/accepted-all-eula select true"

debconf-set-selections <<< "servicefabricsdkcommon servicefabricsdkcommon/presenteula select false"
debconf-set-selections <<< "servicefabricsdkcommon servicefabricsdkcommon/accepted-eula-v1 select true"
debconf-set-selections <<< "servicefabricsdkcommon servicefabricsdkcommon/accepted-all-eula select true"

apt install -y python-pip nodejs openssh-server openssh-client docker.io servicefabricsdkcommon servicefabricsdkjava servicefabricsdkcsharp

/opt/microsoft/sdk/servicefabric/common/sdkcommonsetup.sh
/opt/microsoft/sdk/servicefabric/java/sdkjavasetup.sh
/opt/microsoft/sdk/servicefabric/csharp/sdkcsharpsetup.sh