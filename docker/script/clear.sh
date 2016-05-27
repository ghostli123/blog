BRIDGE=ovs-test
ip netns delete ns1
ip netns delete ns2
ip netns delete ns3
ovs-vsctl del-br $BRIDGE

#ip link delete br-tap1
