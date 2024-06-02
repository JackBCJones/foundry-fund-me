## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation
https://book.getfoundry.sh/

## Quickstart

after cloning run: 
```forge build```

## Project purpose

The aim of this project was to get more familiar with Solidity through Foundry and the many tools it comes with. Previously the only experience I had was with Ganache and Remix. This project got be to dig deeper into a CL local blockchain with Anvil, unit and integration testing of my contract, gas efficiency, oracles and of course Forge, which I found to be a great tool to use. This project was part of a tutorial series done by Patrick Collins, to whom I am grateful. 

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
