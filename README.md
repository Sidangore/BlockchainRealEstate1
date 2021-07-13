# Udacity Blockchain Capstone

The capstone will build upon the knowledge you have gained in the course in order to build a decentralized housing product. 

## Install

To install, download or clone the repo, then:

`npm install`

Move to contracts directory, install dependencies and compile contracts:

```
cd eth-contracts
npm install
truffle compile
``` 

To run individual tests:
```
truffle test ./test/ERC721Mintable.test.js
truffle test ./test/Verifier.test.js
truffle test ./test/SolnSquareVerifier.test.js
```

## ZoKrates Setup

Install and instantiate a Zokrates zkSnarks development environment using Docker. Completes the Zokrates proof in `square.code` by adding the variable names in `square.code`.

Preequisite: Install Docker using instructions from [here](https://docs.docker.com/install/).


```
# Run ZoKrates
docker run -v <path to your project folder>:/home/zokrates/code -ti zokrates/zokrates /bin/bash

# Change path to code/square
cd code/square

# Compile the program
zokrates compile -i square.code

# Generate the Trusted Setup
zokrates setup

# Compute Witness
zokrates compute-witness -a 3 9

# Generate Proof
zokrates generate-proof

# Export Verifier
zokrates export-verifier
```

## Contracts Deployment on Rinkeby

Contract deployment information on Rinkeby netwrok:
```
Deploying 'RealEstateERC721Token'
   > transaction hash:    
   > contract address:    
   > account:             

Deploying 'SquareVerifier'
   --------------------------
   > transaction hash:    
   > contract address:    
   > account:             

Deploying 'SolnSquareVerifier'
   ------------------------------
   > transaction hash:    
   > contract address:    
   > account:             

```

## Mint Tokens

1. Use [Remix](https://remix.ethereum.org/) or [MyEtherWallet](https://www.myetherwallet.com/access-my-wallet) to mint 10 tokens to list in Opensea. Use the  ABI and the deployed SolnSquareVerifier's contract address.

<!-- 2. You can list the tokens by going to: [https://rinkeby.opensea.io/get-listed/step-two](https://rinkeby.opensea.io/get-listed/step-two) -->

<!-- ## Opensea Storefront
OpenSea Link : [https://rinkeby.opensea.io/assets/real-estate](https://rinkeby.opensea.io/assets/real-estate) -->

# Project Resources

* [Remix - Solidity IDE](https://remix.ethereum.org/)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Truffle Framework](https://truffleframework.com/)
* [Ganache - One Click Blockchain](https://truffleframework.com/ganache)
* [Open Zeppelin ](https://openzeppelin.org/)
* [Interactive zero knowledge 3-colorability demonstration](http://web.mit.edu/~ezyang/Public/graph/svg.html)
* [Docker](https://docs.docker.com/install/)
* [ZoKrates](https://github.com/Zokrates/ZoKrates)