var SolnSquareVerifier = artifacts.require("../contracts/SolnSquareVerifier.sol");

//var TestERC721Mintable = artifacts.require("./HouseToken");
var verifier = artifacts.require('../contracts/verifier.sol');
module.exports = async(deployer) => {
    await deployer.deploy(verifier);
    //await deployer.deploy(TestERC721Mintable,"HST_ERC721MintableToken", "HST_721");
    await deployer.deploy(SolnSquareVerifier, verifier.address, "SRE_ERC721MintableToken", "SRE_721");
};