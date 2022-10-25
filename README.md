# Example-Solidity-Sprint

## Getting Started

To build, test, and deploy the example smart contract, we will use Hardhat, an Ethereum development environment. Make sure you have [npm](https://nodejs.org/en/download/) installed before executing the following commands.

First clone the repository and enter the directory.
```
$ git clone https://github.com/404-DAO/Solidity-Sprint-Example.git
$ cd "Solidity-Sprint-Example"
```

Install the necessary dependencies
```
$ npm i
```

Compile the ExampleSoliditySprint2022 contract
```
$ npx hardhat compile
```

Run associated tests
```
$ npx hardhat test
```

Deploy locally
```
$ npx hardhat run scripts/deploy.js --network hardhat
```

## Preparation

[IF YOU NEED GOERLI ETH, ASK IN THE DISCORD](https://discord.gg/G7ZV5kFmd2) or [visit this link](https://goerlifaucet.com/)

Play around with the contract [using Etherscan](https://goerli.etherscan.io/address/0xcfd9741867bad2f94c8bfb91518066436cbe6a20#writeContract) or locally by running tests.

Try to complete `f1`. Note that each transaction sent to the network incurs a gas cost.



## Educational Materials

* [Build and Deploy Smart Contracts using Hardhat](https://www.youtube.com/watch?v=GBc3lBrXEBo&ab_channel=PatrickCollins)
* [Crypto Zombies](https://cryptozombies.io/)
* [Speedrun Ethereum](https://speedrunethereum.com/)
