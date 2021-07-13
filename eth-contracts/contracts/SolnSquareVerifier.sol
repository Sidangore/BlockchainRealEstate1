// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "./ERC721Mintable.sol";
import "./verifier.sol";

// contract SolnSquareVerifier is SidRealEstateToken, Verifier {
//     struct Solution {
//         bytes32 index;
//         address addr;
//         uint256 tokenId;
//         bool exists;
//     }

//     mapping(uint256 => Solution) solutions;

//     mapping(bytes32 => bool) private uniqueSolutions;

//     event SolutionAdded(bytes32 key, address addr, uint256 tokenId);

//     function addSolution(address addr, uint256 tokenId, uint[2] memory a, uint[2] memory b, uint[2] memory c, uint[2] memory input) public {
//         bytes32 key = keccak256(abi.encodePacked(a, b, c, input));
//         require(!uniqueSolutions[key], "This solution is already used");
//         bool isValidProof = verifyTx(a, b, c, input);
//         require(isValidProof, "This proof is not valid");
//         Solution memory solution = Solution(key, addr, tokenId, true);
//         solutions[tokenId] = solution;
//         uniqueSolutions[key] = true;
//         emit SolutionAdded(key, addr, tokenId);
//     }

//     function ming(address to, uint256 tokenId) public returns (bool) {
//         require(solutions[tokenId].exists, "Solution has been used before");
//         return super.mint(to, tokenId);
//     }
// }

import "./ERC721Mintable.sol";
import "./verifier.sol";


// define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is Verifier, SidRealEstateToken {
    // define a solutions struct that can hold an index & an address
    struct Solution {
        bytes32 index;
        address addr;
        uint256 tokenId;
        bool exist;
    }

    // define an array of the above struct
    mapping(uint256 => Solution) solutions;

    // define a mapping to store unique solutions submitted
    mapping(bytes32 => bool) private uniqueSolutions;

    // Create an event to emit when a solution is added
    event SolutionAdded(bytes32 key, address addr, uint256 tokenId);

    //  Create a function to add the solutions to the array and emit the event
    //  This will just limit the ability for a user to mint a token unless they have actually verified that they own that token
    function addSolution(address addr, uint256 tokenId, uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[2] memory input) public{
        // Create unique key for the argumqnts
        bytes32 key = keccak256(abi.encodePacked(a, b, c, input));
        // Check whether the solution is already used
        require(!uniqueSolutions[key], "This solution was already used!");
        // Verification to check if a token is valid using zokrates (verifier.sol)
        bool isValidProof = verifyTx(a, b, c, input);
        require(isValidProof, "The provided proof is not valid!");
        // Add solutions mappings and set uniqueSolutions to be true
        Solution memory solution = Solution(key, addr, tokenId, true);
        solutions[tokenId] = solution;
        uniqueSolutions[key] = true;
        emit SolutionAdded(key, addr, tokenId);
    }


    // Create a function to mint new NFT only after the solution has been verified
    //  - make sure the solution is unique (has not been used before)
    //  - make sure you handle metadata as well as tokenSuplly
    function mint(address to, uint256 tokenId) public returns(bool){
        require(solutions[tokenId].exist,"solution has been used before");
        return super.mint(to, tokenId);
    }
}