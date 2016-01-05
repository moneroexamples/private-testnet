# Setting private Monero testnet network

Having private [Monero](https://getmonero.org/) testnet network can be very useful, as you can play around
with Monero without risking making expensive mistakes on real network. However,
it is not clear how to set up a private testnet network. In this example, this
is demonstrated.

The example is executed on Xubuntu 15.10 x64 using Monero 0.9.
How to compile latest monero is shown here:
[compile-monero-ubuntu-1510](http://moneroexamples.github.io/compile-monero-ubuntu-1510/).


The testnet Monero network will include 3 nodes, each with its own blockchain database
and a corresponding wallet on a single computer. The three testnet nodes will be listening
at the following ports 28080, 38080 and 48080, respectively.


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

For testnet network, I prefer to have fixed addresses for each wallet and no password.
The reason is that it is much easier to work with such testnet wallets.

Execute the following commands to create three wallets without password.

**For wallet_01.bin:**
```bash
echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_01.bin  --restore-deterministic-wallet --electrum-seed="sequence atlas unveil summon pebbles tuesday beer rudely snake rockets different fuselage woven tagged bested dented vegan hover rapid fawns obvious muppet randomly seasons randomly" --password "" --log-file ~/testnet/wallet_01.log;  echo ""
```

Resulting address:
```
9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8
```

The command creates a deterministic wallet and exits after its created. The reason for exit is
that `simplewallet` may crash if the blockchain is empty.

The `simplewallet` options are:

 - *testnet*   - Used to deploy test nets. The daemon must be launched with --testnet flag.
 - *generate-new-wallet*    - Generate new wallet and save it to <arg> or <address>.wallet by default.
 - *restore-deterministic-wallet* - Recover wallet using electrum-stylemnemonic.
 - *electrum-seed* - Specify electrum seed for wallet recovery/creation.
 - *password* - Wallet password.
 - *log-file*  - Specify log file.

**For wallet_02.bin:**
```bash
echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_02.bin  --restore-deterministic-wallet --electrum-seed="deftly large tirade gumball android leech sidekick opened iguana voice gels focus poaching itches network espionage much jailed vaults winter oatmeal eleven science siren winter" --password "" --log-file ~/testnet/wallet_02.log;  echo ""
```

Resulting address:
```
9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh
```

The `simplewallet` options are as before.

**For wallet_03.bin:**
```bash
echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_03.bin  --restore-deterministic-wallet --electrum-seed="upstairs arsenic adjust emulate karate efficient demonstrate weekday kangaroo yoga huts seventh goes heron sleepless fungal tweezers zigzags maps hedgehog hoax foyer jury knife karate" --password "" --log-file ~/testnet/wallet_03.log;  echo ""
```

Resulting address:
```
A2rgGdM78JEQcxEUsi761WbnJWsFRCwh1PkiGtGnUUcJTGenfCr5WEtdoXezutmPiQMsaM4zJbpdH5PMjkCt7QrXAhV8wDB
```

The `simplewallet` options are as before.

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
/opt/bitmonero/simplewallet --testnet --trusted-daemon --wallet-file ~/testnet/wallet_01.bin --password "" --log-file ~/testnet/wallet_01.log
```

wallet_02:
```
/opt/bitmonero/simplewallet --testnet --daemon-port 38081 --trusted-daemon --wallet-file ~/testnet/wallet_02.bin --password "" --log-file ~/testnet/wallet_02.log
```

wallet_03:
```
/opt/bitmonero/simplewallet --testnet --daemon-port 48081 --trusted-daemon --wallet-file ~/testnet/wallet_03.bin --password "" --log-file ~/testnet/wallet_03.log
```


## Testnet folder structure

The resulting `~/testnet` folder structure should be as follows:
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

## Start nodes with mining

Optionally, each node can be started so that it starts mining automatically. With this,
there is no need for manually launching the mining operation in each node. It speeds
up using using the testnet.

For example, to start the three nodes so that they mine into the first two wallets (like in step 5):

in node_01 (mining to the first wallet):
```bash
/opt/bitmonero/bitmonerod --testnet --no-igd --hide-my-port --testnet-data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 1 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080 --start-mining 9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 --mining-threads 1
```

in node_02 (mining to the second wallet):
```bash
/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 38080 --testnet-rpc-bind-port 38081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080 --start-mining 9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh --mining-threads 1
```

in node_03 (mining to the first wallet as well):
```bash
/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 48080 --testnet-rpc-bind-port 48081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080 --start-mining 9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 --mining-threads 1
```

## Commands' aliases
The comments used are rather long, so to speed things up, one can make aliases
for them. For example, by adding the following to `~/.bashrc`:

```bash
alias testmakewallet1='echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_01.bin  --restore-deterministic-wallet --electrum-seed="sequence atlas unveil summon pebbles tuesday beer rudely snake rockets different fuselage woven tagged bested dented vegan hover rapid fawns obvious muppet randomly seasons randomly" --password "" --log-file ~/testnet/wallet_01.log;  echo ""'

alias testmakewallet2='echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_02.bin  --restore-deterministic-wallet --electrum-seed="deftly large tirade gumball android leech sidekick opened iguana voice gels focus poaching itches network espionage much jailed vaults winter oatmeal eleven science siren winter" --password "" --log-file ~/testnet/wallet_02.log;  echo ""'

alias testmakewallet3='echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_03.bin  --restore-deterministic-wallet --electrum-seed="upstairs arsenic adjust emulate karate efficient demonstrate weekday kangaroo yoga huts seventh goes heron sleepless fungal tweezers zigzags maps hedgehog hoax foyer jury knife karate" --password "" --log-file ~/testnet/wallet_03.log;  echo ""'

# additional alias for making random wallet_04
alias testmakewallet4='{ echo "0"; echo "exit"; } | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_04.bin   --password "" --log-file ~/testnet/wallet_04.log;  echo ""'

alias testmakeallwallets="testmakewallet1; testmakewallet2; testmakewallet3; testmakewallet4"

alias testnode1="/opt/bitmonero/bitmonerod --testnet --no-igd --hide-my-port --testnet-data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 1 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080"

alias testnode2="/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 38080 --testnet-rpc-bind-port 38081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080"

alias testnode3="/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 48080 --testnet-rpc-bind-port 48081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080"

alias testnodeandmine1="/opt/bitmonero/bitmonerod --testnet --no-igd --hide-my-port --testnet-data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 1 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080 --start-mining 9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 --mining-threads 1"

alias testnodeandmine2="/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 38080 --testnet-rpc-bind-port 38081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080 --start-mining 9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh --mining-threads 1"

alias testnodeandmine3="/opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 48080 --testnet-rpc-bind-port 48081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080 --start-mining 9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 --mining-threads 1"

alias teststartwallet1='/opt/bitmonero/simplewallet --testnet --trusted-daemon --wallet-file ~/testnet/wallet_01.bin --password "" --log-file ~/testnet/wallet_01.log'

alias teststartwallet2='/opt/bitmonero/simplewallet --testnet --daemon-port 38081 --trusted-daemon --wallet-file ~/testnet/wallet_02.bin --password "" --log-file ~/testnet/wallet_02.log'

alias teststartwallet3='/opt/bitmonero/simplewallet --testnet --daemon-port 48081 --trusted-daemon --wallet-file ~/testnet/wallet_03.bin --password "" --log-file ~/testnet/wallet_03.log'

alias teststartwallet4='/opt/bitmonero/simplewallet --testnet --daemon-port 48081 --wallet-file ~/testnet/wallet_04.bin --password "" --log-file ~/testnet/wallet_04.log'

alias testremove="rm -rvf ~/testnet"

alias testremoveandmkdir="rm -rvf ~/testnet; mkdir ~/testnet"
```

## Commands' aliases (with rlwrap)
As an alternative to the above aliases, the comamnds using `rlwrap` for having
commands history and tab-compliton in the `bitmonerod` and `simplewallet` consoles
are provided. The `rlwrap` is not added for testmakewallet[1-4] aliases.

```bash
alias testmakewallet1='echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_01.bin  --restore-deterministic-wallet --electrum-seed="sequence atlas unveil summon pebbles tuesday beer rudely snake rockets different fuselage woven tagged bested dented vegan hover rapid fawns obvious muppet randomly seasons randomly" --password "" --log-file ~/testnet/wallet_01.log;  echo ""'

alias testmakewallet2='echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_02.bin  --restore-deterministic-wallet --electrum-seed="deftly large tirade gumball android leech sidekick opened iguana voice gels focus poaching itches network espionage much jailed vaults winter oatmeal eleven science siren winter" --password "" --log-file ~/testnet/wallet_02.log;  echo ""'

alias testmakewallet3='echo "exit" | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_03.bin  --restore-deterministic-wallet --electrum-seed="upstairs arsenic adjust emulate karate efficient demonstrate weekday kangaroo yoga huts seventh goes heron sleepless fungal tweezers zigzags maps hedgehog hoax foyer jury knife karate" --password "" --log-file ~/testnet/wallet_03.log;  echo ""'

alias testmakewallet4='{ echo "0"; echo "exit"; } | /opt/bitmonero/simplewallet --testnet --generate-new-wallet ~/testnet/wallet_04.bin   --password "" --log-file ~/testnet/wallet_04.log;  echo ""'

alias testmakeallwallets="testmakewallet1; testmakewallet2; testmakewallet3; testmakewallet4"

alias testnode1='rlwrap -f ~/monerocommands_bitmonerod.txt /opt/bitmonero/bitmonerod --testnet --no-igd --hide-my-port --testnet-data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 1 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080'

alias testnode2='rlwrap -f ~/monerocommands_bitmonerod.txt /opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 38080 --testnet-rpc-bind-port 38081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080'

alias testnode3='rlwrap -f ~/monerocommands_bitmonerod.txt /opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 48080 --testnet-rpc-bind-port 48081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080'

alias testnodeandmine1='rlwrap -f ~/monerocommands_bitmonerod.txt /opt/bitmonero/bitmonerod --testnet --no-igd --hide-my-port --testnet-data-dir ~/testnet/node_01 --p2p-bind-ip 127.0.0.1 --log-level 1 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080 --start-mining 9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 --mining-threads 1'

alias testnodeandmine2='rlwrap -f ~/monerocommands_bitmonerod.txt /opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 38080 --testnet-rpc-bind-port 38081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080 --start-mining 9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh --mining-threads 1'

alias testnodeandmine3='rlwrap -f ~/monerocommands_bitmonerod.txt /opt/bitmonero/bitmonerod --testnet --testnet-p2p-bind-port 48080 --testnet-rpc-bind-port 48081 --no-igd --hide-my-port  --log-level 1 --testnet-data-dir ~/testnet/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080 --start-mining 9wviCeWe2D8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPwq9Gm8 --mining-threads 1'

alias teststartwallet1='rlwrap -f ~/monerocommands_simplewallet.txt /opt/bitmonero/simplewallet --testnet --trusted-daemon --wallet-file ~/testnet/wallet_01.bin --password "" --log-file ~/testnet/wallet_01.log'

alias teststartwallet2='rlwrap -f ~/monerocommands_simplewallet.txt /opt/bitmonero/simplewallet --testnet --daemon-port 38081 --wallet-file ~/testnet/wallet_02.bin --password "" --log-file ~/testnet/wallet_02.log'

alias teststartwallet3='rlwrap -f ~/monerocommands_simplewallet.txt /opt/bitmonero/simplewallet --testnet --daemon-port 48081 --wallet-file ~/testnet/wallet_03.bin --password "" --log-file ~/testnet/wallet_03.log'

alias teststartwallet4='rlwrap -f ~/monerocommands_simplewallet.txt /opt/bitmonero/simplewallet --testnet --daemon-port 48081 --wallet-file ~/testnet/wallet_04.bin --password "" --log-file ~/testnet/wallet_04.log'

alias testremove="rm -rvf ~/testnet"

alias testremoveandmkdir="rm -rvf ~/testnet; mkdir ~/testnet"
```

The files `monerocommands_bitmonerod.txt` and `monerocommands_simplewallet.txt` should be downloaded
and placed in your home folder for the above aliases to work.

```bash
cd ~
wget https://raw.githubusercontent.com/moneroexamples/compile-monero-ubuntu/master/monerocommands_bitmonerod.txt
wget https://raw.githubusercontent.com/moneroexamples/compile-monero-ubuntu/master/monerocommands_simplewallet.txt
```

## Making transfers

Newly mined blocks require confirmation of 60 blocks, before they can be used. So before you can make any transfers between the wallets, we need to mine at least 60 blocks. Until then, the wallets will have `unlocked balance` equal to 0. In contrast, for regular transfers between wallets to be unlocked it takes 6 blocks.

## Example screenshots

**Commands used to start the nodes and wallets:**
![Before](https://raw.githubusercontent.com/moneroexamples/private-testnet/master/img/testnet_setup.jpg)
The above image shows the command used for each node (left column) and wallets (right column).
Each row represents one node with the corresponding wallet.


**After mining first few blocks:**
![After](https://raw.githubusercontent.com/moneroexamples/private-testnet/master/img/testnet_run.jpg)
The above image shows the state of the nodes and wallets after first few blocks mined. We see
that the first two wallets already have some xmr, but their `unlocked balance` values are zero. For them
to unlock the mined xmr, we need to mine at least 60 blocks.


**After mining more than 60 blocks:**
![After60](https://raw.githubusercontent.com/moneroexamples/private-testnet/master/img/testnet_run_60.jpg)
After mining more than 60 blocks, the `unlocked balance` is no longer zero
and we can start mining transfers between wallets.


## How can you help?

Constructive criticism, code and website edits are always good. They can be made through github.

Some Monero are also welcome:
```
48daf1rG3hE1Txapcsxh6WXNe9MLNKtu7W7tKTivtSoVLHErYzvdcpea2nSTgGkz66RFP4GKVAsTV14v6G3oddBTHfxP6tU
```    
