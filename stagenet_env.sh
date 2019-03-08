#!/bin/sh

export NETTYPE=stagenet
export DIFFICULT=1

alias pnode1="monerod --$NETTYPE  --no-igd --hide-my-port --data-dir ~/$NETTYPE/node_01 --p2p-bind-ip 127.0.0.1 --log-level 0 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080  --fixed-difficulty $DIFFICULT"


alias pwallet1="monero-wallet-cli --$NETTYPE --trusted-daemon --wallet-file ~/$NETTYPE/wallet_01.bin --password '' --log-file ~/$NETTYPE/wallet_01.log"
alias pwallet2="monero-wallet-cli --$NETTYPE --trusted-daemon --wallet-file ~/$NETTYPE/wallet_02.bin --password '' --log-file ~/$NETTYPE/wallet_02.log"
alias pwallet3="monero-wallet-cli --$NETTYPE --trusted-daemon --wallet-file ~/$NETTYPE/wallet_03.bin --password '' --log-file ~/$NETTYPE/wallet_03.log"

echo "private stagenet pnode1 pwallet1 pwallet2 and pwallet3 aliases avaliable now"
