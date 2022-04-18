
#
# Commands used for createing private stagenet nodes and wallets
#

mkdir stagenet && cd ~/stagenet

# set network type and its difficulty

NETTYPE=stagenet
DIFFICULT=1


# create private wallets

# 56bCoEmLPT8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPx1iovY
echo "" | monero-wallet-cli --$NETTYPE --generate-new-wallet ~/$NETTYPE/wallet_01.bin  --restore-deterministic-wallet --electrum-seed="sequence atlas unveil summon pebbles tuesday beer rudely snake rockets different fuselage woven tagged bested dented vegan hover rapid fawns obvious muppet randomly seasons randomly" --password "" --log-file ~/$NETTYPE/wallet_01.log;

# 56VbjczrFCVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4Z6HAo6
echo "" | monero-wallet-cli --$NETTYPE --generate-new-wallet ~/$NETTYPE/wallet_02.bin  --restore-deterministic-wallet --electrum-seed="deftly large tirade gumball android leech sidekick opened iguana voice gels focus poaching itches network espionage much jailed vaults winter oatmeal eleven science siren winter" --password "" --log-file ~/$NETTYPE/wallet_02.log;

# 5BXAsDboVYEQcxEUsi761WbnJWsFRCwh1PkiGtGnUUcJTGenfCr5WEtdoXezutmPiQMsaM4zJbpdH5PMjkCt7QrXAbj3Qrc
echo "" | monero-wallet-cli --$NETTYPE --generate-new-wallet ~/$NETTYPE/wallet_03.bin  --restore-deterministic-wallet --electrum-seed="upstairs arsenic adjust emulate karate efficient demonstrate weekday kangaroo yoga huts seventh goes heron sleepless fungal tweezers zigzags maps hedgehog hoax foyer jury knife karate" --password "" --log-file ~/$NETTYPE/wallet_03.log;

# 55hKAMnUWXaWXd4hUQ9jzQDF3sL7Yu7fML5FpWMFMouUXjxxK2y6oKJYtEf91Vf3ZGaPE6cHccRnbV5q96uC3ChmCKyGuXY 
echo "" | monero-wallet-cli --$NETTYPE --generate-new-wallet ~/$NETTYPE/wallet_04.bin  --restore-deterministic-wallet --electrum-seed="kitchens easy focus sipped tagged roles pool tilt remedy coexist taboo lucky sneeze guest woven coal anybody colony unbending bacon iceberg worry exult bubble tilt" --password "" --log-file ~/$NETTYPE/wallet_04.log;


# stare private nodes

monerod --$NETTYPE  --no-igd --hide-my-port --data-dir ~/$NETTYPE/node_01 --p2p-bind-ip 127.0.0.1 --log-level 0 --add-exclusive-node 127.0.0.1:38080 --add-exclusive-node 127.0.0.1:48080  --fixed-difficulty $DIFFICULT --disable-rpc-ban

monerod --$NETTYPE --p2p-bind-port 38080 --rpc-bind-port 38081 --zmq-rpc-bind-port 38082 --no-igd --hide-my-port  --log-level 0 --data-dir ~/$NETTYPE/node_02 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:48080 --fixed-difficulty $DIFFICULT --disable-rpc-ban

monerod --$NETTYPE --p2p-bind-port 48080 --rpc-bind-port 48081 --zmq-rpc-bind-port 48082 --no-igd --hide-my-port  --log-level 0 --data-dir ~/$NETTYPE/node_03 --p2p-bind-ip 127.0.0.1 --add-exclusive-node 127.0.0.1:28080 --add-exclusive-node 127.0.0.1:38080 --fixed-difficulty $DIFFICULT --disable-rpc-ban

# open private wallets

# 56bCoEmLPT8XS82k2ovp5EUYLzBt9pYNW2LXUFsZiv8S3Mt21FZ5qQaAroko1enzw3eGr9qC7X1D7Geoo2RrAotYPx1iovY
monero-wallet-cli --$NETTYPE --trusted-daemon --wallet-file ~/$NETTYPE/wallet_01.bin --password '' --log-file ~/$NETTYPE/wallet_01.log

# 56VbjczrFCVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4Z6HAo6
monero-wallet-cli --$NETTYPE --daemon-port 38081 --trusted-daemon --wallet-file ~/$NETTYPE/wallet_02.bin --password '' --log-file ~/$NETTYPE/wallet_02.log

# 5BXAsDboVYEQcxEUsi761WbnJWsFRCwh1PkiGtGnUUcJTGenfCr5WEtdoXezutmPiQMsaM4zJbpdH5PMjkCt7QrXAbj3Qrc
monero-wallet-cli --$NETTYPE --daemon-port 38081 --trusted-daemon --wallet-file ~/$NETTYPE/wallet_03.bin --password '' --log-file ~/$NETTYPE/wallet_03.log

# onion explorer

./xmrblocks --$NETTYPE -p 9999 -b /home/mwo/$NETTYPE/node_01/$NETTYPE/lmdb/ --no-blocks-on-index 50 --enable-as-hex  --enable-pusher
