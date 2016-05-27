#please run under su
BRIDGE=ovs-br0
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
ovs-vsctl del-br $BRIDGE
rm /var/run/netns/*

#ip link delete br-tap1
