# Setting private Monero testnet network

Having private [Monero](https://getmonero.org/) testnet network can be very useful, as you can play around
with Monero without risking making expensive mistakes on real network. However,
it is not clear how to set up a private testnet network. In this example, this
is demonstrated.

## Pre-requsits

The instructions below have been prepared
based on Monero v0.12.3.

## Testnet network

The testnet Monero network will include 3 nodes, each with its own blockchain database
and a corresponding wallet on a single computer. The three testnet nodes will be listening
at the following ports 28080, 38080 and 48080, respectively. As a result, testnet folder structure will be following:

```bash
./testnet/
├── node_01
│   ├── bitmonero.log
│   └── lmdb
│       ├── data.mdb
│       └── lock.mdb
├── node_02
│   ├── bitmonero.log
│   └── lmdb
│       ├── data.mdb
│       └── lock.mdb
├── node_03
│   ├── bitmonero.log
│   └── lmdb
│       ├── data.mdb
│       └── lock.mdb
├── wallet_01.bin
├── wallet_01.bin.address.txt
├── wallet_01.bin.keys
├── wallet_01.log
├── wallet_02.bin
├── wallet_02.bin.address.txt
├── wallet_02.bin.keys
├── wallet_02.log
├── wallet_03.bin
├── wallet_03.bin.address.txt
├── wallet_03.bin.keys
└── wallet_03.log

6 directories, 21 files
```


The example is based on the following reddit posts:
 - [How do I make my own testnet network, with e.g. two private nodes and private blockchain?](https://www.reddit.com/r/Monero/comments/3x5qwo/how_do_i_make_my_own_testnet_network_with_eg_two/)
 - [Does unlocking balance in testnet mode differers from the normal mode?](https://www.reddit.com/r/Monero/comments/3xj9vp/does_unlocking_balance_in_testnet_mode_differers/)

Also much thanks go to reddit's user [o--sensei](https://www.reddit.com/user/o--sensei) for
  help with setting up the initial testnet network.

## Step 1: Create testnet wallets

Each of the nodes will have a corresponding wallet. Thus we create the wallets first.
I assume that the wallets will be called `wallet_01.bin`,
`wallet_02.bin` and `wallet_03.bin`. Also, I assume that the wallets will be located
in `~/testnet` folder.

Create the `~/testnet` folder and go into it:

```bash
mkdir ~/testnet && cd ~/testnet
```

For the testnet network, I prefer to have fixed addresses for each wallet and no password.
The reason is that it is much easier to work with such testnet wallets.

Execute the following commands to create three wallets without password.

**For wallet_01.bin:**
```bash
monero-wallet-cli --testnet --generate-new-wallet ~/testnet/wallet_01.bin  --restore-deterministic-wallet --electrum-seed="sequence atlas unveil summon pebbles tuesday beer rudely snake rockets different fuselage woven tagged bested dented vegan hover rapid fawns obvious muppet randomly seasons randomly" --password "" --log-file ~/testnet/wallet_01.log;
```

Resulting address and seed:
```
9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8
```
```
sequence atlas unveil summon pebbles tuesday beer rudely snake rockets different fuselage woven tagged bested dented vegan hover rapid fawns obvious muppet randomly seasons randomly
```

The command creates a deterministic wallet and exits after its created. The reason for exit is
that `monero-wallet-cli` may crash if the blockchain is empty.

**For wallet_02.bin:**
```bash
monero-wallet-cli --testnet --generate-new-wallet ~/testnet/wallet_02.bin  --restore-deterministic-wallet --electrum-seed="deftly large tirade gumball android leech sidekick opened iguana voice gels focus poaching itches network espionage much jailed vaults winter oatmeal eleven science siren winter" --password "" --log-file ~/testnet/wallet_02.log;
```

Resulting address and seed:
```
9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh
```
```
deftly large tirade gumball android leech sidekick opened iguana voice gels focus poaching itches network espionage much jailed vaults winter oatmeal eleven science siren winter
```

**For wallet_03.bin:**
```bash
monero-wallet-cli --testnet --generate-new-wallet ~/testnet/wallet_03.bin  --restore-deterministic-wallet --electrum-seed="upstairs arsenic adjust emulate karate efficient demonstrate weekday kangaroo yoga huts seventh goes heron sleepless fungal tweezers zigzags maps hedgehog hoax foyer jury knife karate" --password "" --log-file ~/testnet/wallet_03.log;
```

Resulting address and seed:
```
A2rgGdM78JEQcxEUsi761WbnJWsFRCwh1PkiGtGnUUcJTGenfCr5WEtdoXezutmPiQMsaM4zJbpdH5PMjkCt7QrXAhV8wDB
```
```
upstairs arsenic adjust emulate karate efficient demonstrate weekday kangaroo yoga huts seventh goes heron sleepless fungal tweezers zigzags maps hedgehog hoax foyer jury knife karate
```

## Step 2: Start first node

The node will listen for connections at port 28080 and connect to the two other nodes, i.e., those on ports 38080 and 48080. It will store its blockchain in `~/testnet/node_01`. We are going to set fixed mining difficult at 100. You can change it to whatever suits you. This way we can keep mining blocks faster.

```bash
monerod --testnet  --no-igd --hide-my-port --data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 0 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080  --fixed-difficulty 100
```

## Step 3: Start second node

The node will listen for connections at port 38080 and connect to the two other nodes, i.e., those on ports 28080 and 48080. It will store its blockchain in `~/testnet/node_02`. We set difficult as for the first node.

```bash
monerod --testnet --p2p-bind-port 38080 --rpc-bind-port 38081 --zmq-rpc-bind-port 38082 --no-igd --hide-my-port  --log-level 0 --data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080 --fixed-difficulty 100
```

Additional `monerod` options are:

 - *testnet-p2p-bind-port* - Port for testnet p2p network protocol.
 - *testnet-rpc-bind-port* - Port for testnet RPC server.    


## Step 4: Start third node

The node will listen for connections at port 48080 and connect to the two other nodes, i.e., those on ports 28080 and 38080. It will store its blockchain in `~/testnet/node_03`. We set difficult as for the first node.


```bash
monerod --testnet --p2p-bind-port 48080 --rpc-bind-port 48081 --zmq-rpc-bind-port 48082 --no-igd --hide-my-port  --log-level 0 --data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080 --fixed-difficulty 100
```

## Step 5: Start mining

How you mine is up to you now. You can mine only for the first wallet, and keep other two empty for now,
or mine in two nodes, or all three of them.

For example, to mine into two first wallets, the following commands can be used:


in node_01 (mining to the first wallet):
```
start_mining  9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 1
```

in node_02 (mining to the second wallet):
```
start_mining  9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh 1
```

in node_03 (mining to the first wallet as well):
```
start_mining  9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 1
```

As can be seen, both node_01 and node_03 mine to the first wallet. The third wallet
is not used for mining in this example. The reason is that it will receive xmr,
through transfers, from the remaining wallets.

## Step 6: Start the wallets

wallet_01:
```
monero-wallet-cli --testnet --trusted-daemon --wallet-file ~/testnet/wallet_01.bin --password '' --log-file ~/testnet/wallet_01.log
```

wallet_02:
```
monero-wallet-cli --testnet --daemon-port 38081 --trusted-daemon --wallet-file ~/testnet/wallet_02.bin --password '' --log-file ~/testnet/wallet_02.log
```

wallet_03:
```
monero-wallet-cli --testnet --daemon-port 48081 --trusted-daemon --wallet-file ~/testnet/wallet_03.bin --password '' --log-file ~/testnet/wallet_03.log
```


## Making transfers

Newly mined blocks require confirmation of 60 blocks, before they can be used. So before you can make any transfers between the wallets, we need to mine at least 60 blocks. Until then, the wallets will have `unlocked balance` equal to 0. In contrast, for regular transfers between wallets to be unlocked it takes 10 blocks.

## Private testnet blockchain explorer

The [onion-monero-blockchain-explorer from devel branch](https://github.com/moneroexamples/onion-monero-blockchain-explorer/commits/devel) can be used for exploring the private blockchain.

For example, I use the explorer in the following way:

```bash
./xmrblocks -t -p 9999 -b /home/mwo/testnet/node_01/testnet/lmdb/ --no-blocks-on-index 50 --enable-as-hex  --enable-pusher
```

and go to http://127.0.0.1:9999/ .

## tmux session

The tmux script to automatically launch the three nodes and wallets,
and the explorer is [here](https://github.com/moneroexamples/private-testnet/blob/master/tmux-privatexmr.sh).

## How can you help?

Constructive criticism, code and issues are always welcomed. They can be made through github.
