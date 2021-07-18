var SolnSquareVerifier = artifacts.require("../contracts/SolnSquareVerifier.sol");

// var ERC721Mintable = artifacts.require("../contracts/ERC721Mintable.sol");
var verifier = artifacts.require('../contracts/verifier.sol');
module.exports = async(deployer) => {
    await deployer.deploy(verifier);
    // await deployer.deploy(ERC721Mintable);
    //await deployer.deploy(TestERC721Mintable,"HST_ERC721MintableToken", "HST_721");
    await deployer.deploy(SolnSquareVerifier, verifier.address, "SRE_ERC721MintableToken", "SRE_721");
};