# Starknet Sandbox

- This is the StarkNet sandbox to know how to deploy contracts and interact from frontend
- Also setup solidity to Cairo development workflow

## Devnet

https://shard-labs.github.io/starknet-devnet/docs/guide/run#run-with-docker

```
docker pull shardlabs/starknet-devnet
docker run -p 127.0.0.1:5050:5050 shardlabs/starknet-devnet
```

## Reference

This tutorial is nice
https://medium.com/@darlingtonnnam/an-in-depth-guide-to-getting-started-with-starknet-js-a55c04d0ccb7

## Setup Argen X

https://chrome.google.com/webstore/detail/argent-x/dlcobpjiigpikoobohmabehhmhfoodbb

## Local

- please replace the private key, account address, contract address
- The original config file does not work, so I modified based on the shared cheat sheet

### Obtain account key

```
http://localhost:5050/predeployed_accounts
```

### Build, Declare, Deploy

```
protostar build
protostar -p devnet declare ./build/main.json
protostar -p devnet deploy ./build/main.json
```

### Invoke and Call

```
protostar -p devnet invoke --contract-address 0x0253b3190a4458d0ec4f67d856b92d34339142e09c212deb5fe67d8d2b85a621 --function "increase_balance" --account-address 0x2d8c183ad449a794beda163d6906fcedf221743ce284b0c60e4a17a15ca6238  --max-fee auto --inputs 3 --private-key-path ./.pkey
```

```
protostar -p devnet call --contract-address 0x0253b3190a4458d0ec4f67d856b92d34339142e09c212deb5fe67d8d2b85a621  --function "get_balance"
```

## Interact with Testnet Starknet Contract

## Bridge

This is to get the test token

https://goerli.starkgate.starknet.io/

https://testnet.starkscan.co/eth-tx/0xd2053ca772f45c0a51932fd4119979cea17d263828d0b540532982b7aa0333e5

### Build

```
protostar build
```

### Declare

```
protostar declare ./build/nftcraft.json --network testnet
```

```
Class hash: 0x026ef61eb4efeb054a07b899ee6386e2156bb10de7c516adb2f51ca90654756c
StarkScan https://testnet.starkscan.co/class/0x026ef61eb4efeb054a07b899ee6386e2156bb10de7c516adb2f51ca90654756c
Voyager   https://goerli.voyager.online/class/0x026ef61eb4efeb054a07b899ee6386e2156bb10de7c516adb2f51ca90654756c

Transaction hash: 0x013f59e0075abfa2ace432abf20fed3e47dc43bbbd6b9998b9a435751be9e8dc
StarkScan https://testnet.starkscan.co/tx/0x013f59e0075abfa2ace432abf20fed3e47dc43bbbd6b9998b9a435751be9e8dc
Voyager   https://goerli.voyager.online/tx/0x013f59e0075abfa2ace432abf20fed3e47dc43bbbd6b9998b9a435751be9e8dc
```

### Deploy

```
protostar deploy ./build/nftcraft.json --network testnet
```

```
Contract address: 0x044157a8c6e513884690c1651e2d0a57f898da98a36f71e14dcfc27cd3dd8894
StarkScan https://testnet.starkscan.co/contract/0x044157a8c6e513884690c1651e2d0a57f898da98a36f71e14dcfc27cd3dd8894
Voyager   https://goerli.voyager.online/contract/0x044157a8c6e513884690c1651e2d0a57f898da98a36f71e14dcfc27cd3dd8894

Transaction hash: 0x015f3562e88ad6c4343ff0c1be506c02a437a657a6d2a13253a07bae14fc3b6b
StarkScan https://testnet.starkscan.co/tx/0x015f3562e88ad6c4343ff0c1be506c02a437a657a6d2a13253a07bae14fc3b6b
Voyager   https://goerli.voyager.online/tx/0x015f3562e88ad6c4343ff0c1be506c02a437a657a6d2a13253a07bae14fc3b6b
```

## Session key Implementation

### GitHub

https://github.com/argentlabs/argent-x/

### Demo

https://argentlabs.github.io/argent-x/

### API Reference

http://localhost:5050/mint

```
{
    "address": "0x0008E7AB9346b2d7E6cE75ef54bd011a3C1D979Ea1eC06925Fd95A2B4E7b7d63",
    "amount": 1000000000000000000
}
```
