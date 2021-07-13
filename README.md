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
   > transaction hash:    0x183355c952e46eeff56d9d490302073765453216be42ecf17fd7ed70b2f87f35
   > contract address:    0x5456877Cc94670E34637deDAe359912F3a606737
   > account:             0xAe23E61BCfF7C91b958764F498204C0fa471FE4B

Deploying 'SolnSquareVerifier'
   ------------------------------
   > transaction hash:    0x37d7e56e4fea7542b605e865876eb87506593eb77064320d76bbc50eaea41927
   > contract address:    0x0D20Ae97A7eCB658F3d5ABE378D752892dFAF035
   > account:             0xAe23E61BCfF7C91b958764F498204C0fa471FE4B

```

# Project Resources

* [Remix - Solidity IDE](https://remix.ethereum.org/)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Truffle Framework](https://truffleframework.com/)
* [Ganache - One Click Blockchain](https://truffleframework.com/ganache)
* [Open Zeppelin ](https://openzeppelin.org/)
* [Interactive zero knowledge 3-colorability demonstration](http://web.mit.edu/~ezyang/Public/graph/svg.html)
* [Docker](https://docs.docker.com/install/)
* [ZoKrates](https://github.com/Zokrates/ZoKrates)