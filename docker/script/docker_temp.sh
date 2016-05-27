ovs-vsctl add-br ovsbr0
ip addr add dev ovsbr0 10.10.0.1/16
ip link set dev ovsbr0 up

ip link add veth_hostc0 type veth peer name veth_contc0
ovs-vsctl add-port ovsbr0 veth_hostc0
docker run --net='none' -itd ghostli123/ubuntu /bin/sh
docker inspect -f '{{.State.Pid}}' 2090b6c4a1ba8e
mkdir -p /var/run/netns
ln -s /proc/29944/ns/net /var/run/netns/29944
ip link set veth_contc0 netns 29944

docker attach 2090b6c4a1ba8e
ifconfig -a
ip netns exec 29944 ip link set dev veth_contc0 name eth0
ip netns exec 29944 ip link set dev eth0 up

docker attach 6a37777816a7
ifconfig -a	
