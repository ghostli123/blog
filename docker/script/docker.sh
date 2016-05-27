# add the namespaces
docker run --name ns1 --net='none' -itd ghostli123/ubuntu /bin/bash
pid1=$(docker inspect -f '{{.State.Pid}}' ns1) 
ln -s /proc/$pid1/ns/net /var/run/netns/ns1

docker run --name ns2 --net='none' -itd ghostli123/ubuntu /bin/bash
pid2=$(docker inspect -f '{{.State.Pid}}' ns2) 
ln -s /proc/$pid2/ns/net /var/run/netns/ns2

docker run --name ns3 --net='none' -itd ghostli123/ubuntu /bin/bash
pid3=$(docker inspect -f '{{.State.Pid}}' ns3) 
ln -s /proc/$pid3/ns/net /var/run/netns/ns3

# create the switch
BRIDGE=ovs-br0
ovs-vsctl add-br $BRIDGE
#
#### PORT 1
# create an internal ovs port
ovs-vsctl add-port $BRIDGE tap1 -- set Interface tap1 type=internal
# attach it to namespace
ip link set tap1 netns ns1
# configure mac address
ip netns exec ns1 ifconfig tap1 hw ether 00:00:00:00:00:01
# set the ports to up
ip netns exec ns1 ip link set dev tap1 up
#
#### PORT 2
# create an internal ovs port
ovs-vsctl add-port $BRIDGE tap2 -- set Interface tap2 type=internal
# attach it to namespace
ip link set tap2 netns ns2
# configure mac address
ip netns exec ns2 ifconfig tap2 hw ether 00:00:00:00:00:02
# set the ports to up
ip netns exec ns2 ip link set dev tap2 up
#
#### PORT 3
# create an internal ovs port
ovs-vsctl add-port $BRIDGE tap3 -- set Interface tap3 type=internal
# attach it to namespace
ip link set tap3 netns ns3
# configure mac address
ip netns exec ns3 ifconfig tap3 hw ether 00:00:00:00:00:03
# set the ports to up
ip netns exec ns3 ip link set dev tap3 up
#


# now assign the ip addresses
ifconfig $BRIDGE 192.168.0.1
ip netns exec ns1 ip addr add 192.168.0.2 dev tap1
ip netns exec ns2 ip addr add 192.168.0.3 dev tap2
ip netns exec ns3 ip addr add 192.168.0.4 dev tap3

# add default route
ip netns exec ns1 ip route add default dev tap1
ip netns exec ns2 ip route add default dev tap2
ip netns exec ns3 ip route add default dev tap3

# configure ovs 
#sudo ovs-ofctl show
sudo ovs-ofctl add-flow $BRIDGE in_port=1,dl_dst=00:00:00:00:00:03,priority=100,actions=drop

# test
ip netns exec ns1 ping 192.168.0.2
