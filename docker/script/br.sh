# add the namespaces
ip netns add ns1
ip netns add ns2
# create the switch
BRIDGE=br-test
brctl addbr $BRIDGE
brctl stp   $BRIDGE off
ip link set dev $BRIDGE up
#
#### PORT 1
# create a port pair
ip link add tap1 type veth peer name br-tap1
# attach one side to linuxbridge
brctl addif br-test br-tap1 
# attach the other side to namespace
ip link set tap1 netns ns1
# set the ports to up
ip netns exec ns1 ip link set dev tap1 up
ip link set dev br-tap1 up
#
#### PORT 2
# create a port pair
ip link add tap2 type veth peer name br-tap2
# attach one side to linuxbridge
brctl addif br-test br-tap2
# attach the other side to namespace
ip link set tap2 netns ns2
# set the ports to up
ip netns exec ns2 ip link set dev tap2 up
ip link set dev br-tap2 up

# now assign the ip addresses
ip netns exec ns1 ip addr add 192.168.0.1 dev tap1
ip netns exec ns2 ip addr add 192.168.0.2 dev tap2
# add default route
ip netns exec ns1 ip route add default dev tap1
ip netns exec ns2 ip route add default dev tap2



