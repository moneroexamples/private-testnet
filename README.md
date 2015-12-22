# Setting private monero testnet network

Having private [Monero](https://getmonero.org/) testnet network can be very useful, as you can play around
with the monero without risking making expensive mistakes on real network. However,
it is not clear how to set up a private testnet network. In this example, this
is demonstrated.

The example is executed on Xubuntu 15.10 x64 using current (as of Dec 2015)
github version of Monero. Not sure if this will work with official, stable version
from 2014.  How to compile latest monero is shown here:
[compile-monero-ubuntu-1510](http://moneroexamples.github.io/compile-monero-ubuntu-1510/).


The testnet monero network will include 3 nodes, each with its own blockchain database
and corresponding wallet on a single computer. The three testnet nodes will be listening
at the following three ports: 28080, 38080 and 48080.


The example is based on the following reddit posts:
 - [How do I make my own testnet network, with e.g. two private nodes and private blockchain?](https://www.reddit.com/r/Monero/comments/3x5qwo/how_do_i_make_my_own_testnet_network_with_eg_two/)
 - [Does unlocking balance in testnet mode differers from the normal mode?](https://www.reddit.com/r/Monero/comments/3xj9vp/does_unlocking_balance_in_testnet_mode_differers/)

 Also much thanks go to reddit's user [o--sensei](https://www.reddit.com/user/o--sensei) for
  help with setting up the initial testnet network.

## Step 1: Create testnet wallets

Each of the nodes will have corresponding wallet. Thus we create them first. I assume that the wallets will be called `wallet_01.bin`,
`wallet_02.bin` and `wallet_03.bin`. Also, I assume the wallets will be located in `~/testnet` folder.

Create the `~/testnet` folder and go into it:

```bash
mkdir ~/testnet && cd ~/testnet
```

Execute the following command three times, one for each wallet name, and follow the prompts to actually make the wallet and obtain its address.
```bash
/opt/bitmonero/simplewallet --testnet
```

In this example, the addresses obtained were:


wallet_01.bin:
```
9vcyth7idHcfGVripDeUJwQgjqyPYRbh2CMP9JudycTZGgot7tCp2o9aAsY9nUs9hLfoV3KQv59tE1hpZSpgTJXD9zVMHso
```

wallet_02.bin:
```
9uKAVnkfhE9Ww8ZZ9nA8JYYeeXD4f1XgLbHtsoQ3fBKf8QPgv1jyrn5Xc5DHKm8epwWLhrFJnH2w712N9Tk8yRxpGqJgN4C
```

wallet_03.bin:
```
9utaupAkugX7YEuGKL5LPeKD1TQHBYE7edEZXkEuFLirVNzcdf53WHWS3nUieF3vHeShTk6SqU5eSCce5W56mdcZHW67Cs3
```

Exit from the wallets before proceedings. We need only addresses for now.
The `simplewallet` may crash as the blockchain is empty at this stage.
We need to mine some blocks, before the wallets can be used.

## Step 2: Start first node

The node will listen for connections at port 28080 and connect to the two other nodes, i.e., those on ports 38080 and 48080. It will store its blockchain in `~/testnet/node_01`.

```bash
/opt/bitmonero/bitmonerod --testnet --no-igd --hide-my-port --testnet-data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 1 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080
```

The `bitmonerod` options are:

 - *testnet*   - Run on testnet. The wallet must be launched with --testnet flag.
 - *no-igd*    - Disable UPnP port mapping.
 - *hide-my-port* - Do not announce yourself as peerlist candidate.
 - *testnet-data-dir* - Specify testnet data directory.
 - *p2p-bind-ip* - Interface for p2p network protocol.
 - *log-level*  - Log level.
 - *add-exclusive-node* - Specify list of peers to connect to  only. If this option is given the options add-priority-node and seed-node are ignored.

## Step 3: Start second node

The node will listen for connections at port 38080 and connect to the two other nodes, i.e., those on ports 28080 and 48080. It will store its blockchain in `~/testnet/node_02`.

```bash
/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 38080 --testnet-rpc-bind-port 38081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080
```

Additional `bitmonerod` options are:

 - *testnet-p2p-bind-port* - Port for testnet p2p network protocol.
 - *testnet-rpc-bind-port* - Port for testnet RPC server.    


## Step 4: Start third node

The node will listen for connections at port 48080 and connect to the two other nodes, i.e., those on ports 28080 and 38080. It will store its blockchain in `~/testnet/node_03`.


```bash
/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 48080 --testnet-rpc-bind-port 48081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080
```

`bitmonerod` options as before, but with different ports.

## Step 5: Start mining

How you mine is up to you know. You can mine only for the first wallet, and keep other two empty for now,
or mine in two nodes, or all three of them.

For example, to mine in two first wallets, the following commands can be used:


in node_01 (mining to the first wallet):
```
start_mining  9vcyth7idHcfGVripDeUJwQgjqyPYRbh2CMP9JudycTZGgot7tCp2o9aAsY9nUs9hLfoV3KQv59tE1hpZSpgTJXD9zVMHso 1
```

in node_02 (mining to the second wallet):
```
start_mining  9uKAVnkfhE9Ww8ZZ9nA8JYYeeXD4f1XgLbHtsoQ3fBKf8QPgv1jyrn5Xc5DHKm8epwWLhrFJnH2w712N9Tk8yRxpGqJgN4C 1
```

in node_03 (mining to the first wallet):
```
start_mining  9vcyth7idHcfGVripDeUJwQgjqyPYRbh2CMP9JudycTZGgot7tCp2o9aAsY9nUs9hLfoV3KQv59tE1hpZSpgTJXD9zVMHso 1
```

As can be seen, both node_01 and node_03 mine to the first wallet. The third wallet
is not used for mining in this example. The reason is that it will receive xmr,
through transfers, from the remaining wallets.

## Step 6: Start the wallets

wallet_01:
```
/opt/bitmonero/simplewallet --testnet --trusted-daemon --wallet-file ~/testnet/wallet_01.bin
```

wallet_02:
```
/opt/bitmonero/simplewallet --testnet --daemon-port 38081 --wallet-file ~/testnet/wallet_02.bin
```

wallet_03:
```
/opt/bitmonero/simplewallet --testnet --daemon-port 48081 --wallet-file ~/testnet/wallet_03.bin
```


## Testnet folder structure

The resulting `~/testnet` folder structure should be as follows:
```bash
/home/mwo/testnet/
├── node_01
│   ├── bitmonero.log
│   ├── lmdb
│   │   ├── data.mdb
│   │   └── lock.mdb
│   └── p2pstate.bin
├── node_02
│   ├── bitmonero.log
│   ├── lmdb
│   │   ├── data.mdb
│   │   └── lock.mdb
│   └── p2pstate.bin
├── node_03
│   ├── bitmonero.log
│   ├── lmdb
│   │   ├── data.mdb
│   │   └── lock.mdb
│   └── p2pstate.bin
├── wallet_01.bin
├── wallet_01.bin.address.txt
├── wallet_01.bin.keys
├── wallet_02.bin
├── wallet_02.bin.address.txt
├── wallet_02.bin.keys
├── wallet_03.bin
├── wallet_03.bin.address.txt
└── wallet_03.bin.keys

6 directories, 21 files
```

## Making transfers

Mined blocked require confirmation of 60 blocks. So before you can make any transfers between the wallets, need to mine at least 60 blocks. Until then, the wallets will have `unlocked balance` equal to 0. In contrast, for regular transfers between
wallets to be unlocked it takes 6 blocks.

## Example screenshots

**Commands used to start the nodes and wallets:**
![Before](https://raw.githubusercontent.com/moneroexamples/private-testnet/master/img/testnet_setup.jpg)
The above image shows the command used for each node (left column) and wallets (right column).
Each row represents one node with the corresponding wallet.



**After mining first 5 blocks:**
![After](https://raw.githubusercontent.com/moneroexamples/private-testnet/master/img/testnet_run.jpg)
The above image shows the state of the nodes and wallets after frist few blocks mined. We see
that the first two wallets already have some xmr, but the `unlocked balance` values are zero. For them
to unlock the mined xmr, we need to mine at least 60 blocks.


**After mining first 60 blocks:**
![After60](https://raw.githubusercontent.com/moneroexamples/private-testnet/master/img/testnet_run_60.jpg)
After mining 60 blocks, the `unlocked balance` is no longer zero.


## How can you help?

Constructive criticism, code and website edits are always good. They can be made through github.

Some Monero are also welcome:
```
48daf1rG3hE1Txapcsxh6WXNe9MLNKtu7W7tKTivtSoVLHErYzvdcpea2nSTgGkz66RFP4GKVAsTV14v6G3oddBTHfxP6tU
```    
