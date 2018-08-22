#!/bin/bash

cd ~

# tmux session name
SN=PRIVXMR

tmux kill-session -t $SN

tmux new -d -s $SN

# nodes window

tmux rename-window -t 0 nodes

# start  node_01
tmux split-window -t $SN.0 -h
tmux select-pane -t 0
tmux send-keys  "monerod --testnet  --no-igd --hide-my-port --data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 0 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080  --fixed-difficulty 100" C-m

# start  node_02
tmux split-window -v
#tmux send-keys  "cd ~/onion-monero-blockchain-explorer/build && sleep 20  && startxmrblocksmainet" C-m
tmux send-keys  "sleep 3  && monerod --testnet --p2p-bind-port 38080 --rpc-bind-port 38081 --zmq-rpc-bind-port 38082 --no-igd --hide-my-port  --log-level 0 --data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080 --fixed-difficulty 100" C-m

# start  node_03
tmux select-pane -R
tmux send-keys  "sleep 6 && monerod --testnet --p2p-bind-port 48080 --rpc-bind-port 48081 --zmq-rpc-bind-port 48082 --no-igd --hide-my-port  --log-level 0 --data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080 --fixed-difficulty 100" C-m
tmux split-window -v

# wallets window

tmux new-window

tmux rename-window -t 1 wallets

# start wallet_01
tmux split-window  -h
tmux select-pane -t 0
tmux send-keys  "sleep 3 && cd ~/testnet && monero-wallet-cli --testnet --trusted-daemon --wallet-file ./wallet_01.bin --password '' --log-file ./wallet_01.log" C-m

# start wallet_02
tmux split-window -v
tmux send-keys  "sleep 3 && cd ~/testnet && monero-wallet-cli --testnet --daemon-port 38081 --trusted-daemon --wallet-file ./wallet_02.bin --password '' --log-file ./wallet_02.log" C-m

# start wallet_03
tmux select-pane -R
tmux send-keys  "sleep 3 && cd ~/testnet && monero-wallet-cli --testnet --daemon-port 48081 --trusted-daemon --wallet-file ./wallet_03.bin --password '' --log-file ./wallet_03.log" C-m
tmux split-window -v

# explorer window

tmux new-window

# start the explorer for the private testnet network
tmux rename-window -t 2 explorer
tmux split-window -h
tmux select-pane -t 0
tmux send-keys  "sleep 3 && cd ~/onion-monero-blockchain-explorer/build && ./xmrblocks -t -p 9999 -b /home/mwo/testnet/node_01/testnet/lmdb/ --no-blocks-on-index 50 --enable-as-hex  --enable-pusher" C-m

# open second (wallets) tmux window
tmux select-window -t 1

# open tmux for this session
tmux a -t $SN
