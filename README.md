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

## Check 
go in eth-contracts/ and use the npm modules from there.

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

Deploying 'SquareVerifier'
   --------------------------
   > transaction hash:    0x214e640f7ef49285b9d97896138d16824e2303141d32fecf903b2955382ee515
   > contract address:    0x2f5C0c105BF265a02b267a25718f6d561720De61
   > account:             0xAe23E61BCfF7C91b958764F498204C0fa471FE4B

Deploying 'SolnSquareVerifier'
   ------------------------------
   > transaction hash:    0x6001834b66319337e5af60c3135c43e1b42d43bf05f343e92f8b175feb30e704
   > contract address:    0x9Ef784824fb612bF6e5a9d03237841F3d66768f7
   > account:             0xAe23E61BCfF7C91b958764F498204C0fa471FE4B

```

## TO THE UDACITY REVIEWER THE README FILE IS OF LESS IMPORTANCE RIGHT NOW: THE CONTRACT ADDRESS AND OTHER DETAILS ARE MINE! PLEASE CHECK CONTRACT ADDRESS AND HELP ME SOLVE THE PROBLEM TO MINT TOKENS

# Project Resources

* [Remix - Solidity IDE](https://remix.ethereum.org/)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Truffle Framework](https://truffleframework.com/)
* [Ganache - One Click Blockchain](https://truffleframework.com/ganache)
* [Open Zeppelin ](https://openzeppelin.org/)
* [Interactive zero knowledge 3-colorability demonstration](http://web.mit.edu/~ezyang/Public/graph/svg.html)
* [Docker](https://docs.docker.com/install/)
* [ZoKrates](https://github.com/Zokrates/ZoKrates)