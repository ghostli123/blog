cd p4factory/targets/simple_router
make bm
sudo ./behavioral-model

python ../../cli/pd_cli.py -p simple_router -i p4_pd_rpc.simple_router -s $PWD/tests/pd_thrift:$PWD/../../testutils $@


sudo python ../../mininet/1sw_demo.py --behavioral-exe $PWD/behavioral-model

add_entry send_frame 1 rewrite_mac 00:aa:bb:00:00:00
add_entry send_frame 2 rewrite_mac 00:aa:bb:00:00:01
add_entry forward 10.0.0.10 set_dmac 00:04:00:00:00:00
add_entry forward 10.0.1.10 set_dmac 00:04:00:00:00:01
add_entry ipv4_lpm 10.0.0.10 32 set_nhop 10.0.0.10 1
add_entry ipv4_lpm 10.0.1.10 32 set_nhop 10.0.1.10 2



sudo mn -c 
sudo killall behavioral-model 
redis-cli FLUSHALL
