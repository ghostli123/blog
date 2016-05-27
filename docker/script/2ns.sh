# add the namespaces
ip netns add ns1
ip netns add ns2
# create the veth pair
ip link add tap1 type veth peer name tap2
# move the interfaces to the namespaces
ip link set tap1 netns ns1
ip link set tap2 netns ns2
# bring up the links
ip netns exec ns1 ip link set dev tap1 up
ip netns exec ns2 ip link set dev tap2 up
# now assign the ip addresses
ip netns exec ns1 ip addr add 192.168.0.1 dev tap1
ip netns exec ns2 ip addr add 192.168.0.2 dev tap2
# add default route
ip netns exec ns1 ip route add default dev tap1
ip netns exec ns2 ip route add default dev tap2
# test
ip netns exec ns1 ping 192.168.0.2

# delete namespaces: ip netns delete ns1; ip netns delete ns2
# switch to ns1: ip netns exec ns1 bash
