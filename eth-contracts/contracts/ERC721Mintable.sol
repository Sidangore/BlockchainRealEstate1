// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

import "../node_modules/@openzeppelin/contracts/utils/Address.sol";
import "../node_modules/@openzeppelin/contracts/drafts/Counters.sol";
import "../node_modules/@openzeppelin/contracts/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./Oraclize.sol";

contract Ownable {
    address private _owner;

    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransfered(address(0), _owner);
    }
    function getContractOwner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Caller not the owner");
        _;
    }

    event OwnershipTransfered(address indexed from, address indexed to);

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New address is not valid");
        address _oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransfered(_oldOwner, newOwner);
    }
}

contract Pausable is Ownable {
    bool private _paused;

    event Paused(address addr);
    event UnPaused(address addr);

    function setPaused(bool mode) public onlyOwner {
        _paused = mode;
        if(_paused) emit Paused(msg.sender);
        if(!_paused) emit UnPaused(msg.sender);
    }

    constructor() internal {
        _paused = false;
    }

    modifier whenNotPaused() {
        require(!_paused, "Contract is Paused");
        _;
    }

    modifier paused() {
        require(_paused, "Contract is not Paused");
        _;
    }
}

contract ERC165 {
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    //mapping of interface id to whether or not its supported
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor() internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    // internal methods to register the interface
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "This interface is 0xffffffff");
        _supportedInterfaces[interfaceId] = true;
    }

    // implement support interfaces using a lookup
    function _supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }
}

contract ERC721 is Pausable, ERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // mapping from tokenId to the owner
    mapping(uint256 => address) private _tokenOwner;

    //mapping from tokenId to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    //mappings from owner to owned tokens
    mapping(address => Counters.Counter) private _ownedTokensCount;

    //mappings from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor() public {
        //register the supported interfaces to confirm erc721 via erc165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    //returns the balance count of given address
    function balanceOf(address owner) public view returns (uint256) {
        return _ownedTokensCount[owner].current();
    }

    //return the owner of the given token
    function ownerOf(uint256 tokenId) public view returns (address) {
        return _tokenOwner[tokenId];
    }

    //approves another address to transfer the given tokenid
    function approve(address to, uint256 tokenId) public {
        require(to != _tokenOwner[tokenId], "Token is already owned");
        require(isApprovedForAll(_tokenOwner[tokenId], msg.sender) || msg.sender == _tokenOwner[tokenId], "Not allowed to approve");
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_tokenApprovals[tokenId] != address(0), "Invalid address for approvals");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender, "you cannot call the function for yourself");
        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

    //check if the operator is approved by the given owner
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "You should be owner or approved");
        _transferFrom(from, to, tokenId);
    }

    //returns whether the spender can trasfer the token or not
    function _isApprovedOrOwner(address operator, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (operator == owner || getApproved(tokenId) == operator || isApprovedForAll(owner, operator));
    }

    //internal function to transfer the ownership of the given token to another address
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(from == _tokenOwner[tokenId], "caller not the owner");
        require(!to.isContract(), "You are not allowed to transfer to contract");
        _tokenApprovals[tokenId] = address(0);
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "Not Received with ERC721");
    }

    //internal function to invoke onERC721Received
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool) {
        if(!to.isContract()) {
            return true;
        }
        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    //internal function to mint new tokens
    function _mint (address to, uint256 tokenId) internal {

        //revert if token already exists for a given address
        require(!_exists(tokenId), "Token already exists");
        require(to != address(0), "Invalid to address");

        //mint token and increment the count
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        emit Transfer(msg.sender, to, tokenId);
    }

    //private function to clear the current approval of a given tokenId
    function _clearApproval(uint256 tokenId) private {
        if(_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

contract ERC721Enumerable is ERC165, ERC721 {
    //mapping from owner to the list of owned token ids
    mapping(address => uint256[]) private _ownedTokens;

    //mapping from token ids to the index of owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    //array with all token ids used for enumerations
    uint256[] private _allTokens;

    //mapping fronm tokenid to position in the all token array
    mapping(uint256 => uint256) private _allTokensIndex;

    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    constructor() public {
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner), "index is out of balanceOf owner");
        return _ownedTokens[owner][index];
    }

    //gets the total amount of tokens stored by the contract
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    //get the token id at a give index of all the tokens in this contract
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply(), "index is out of bounds of total supply");
        return _allTokens[index];
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        super._transferFrom(from, to, tokenId);

        _removeTokenFromOwnerEnumeration(from, tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        if(tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }

        _ownedTokens[from].length--;
    }

    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
        return _ownedTokens[owner];
    }

    function _mint(address to, uint256 tokenId) internal {
        super._mint(to, tokenId);
        _addTokenToAllTokensEnumeration(tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        uint256 lastTokenIndex = _allTokens.length.sub(1);
        uint256 tokenIndex = _allTokensIndex[tokenId];

        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenIndex;

        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
    }
}

contract ERC721Metadata is ERC721Enumerable, usingOraclize {
    string private _name;
    string private _symbol;
    string private _baseTokenURI;

    mapping(uint256 => string) private _tokenURIs;

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    constructor(string memory name, string memory symbol, string memory baseTokenURI) public {
        _name = name;
        _symbol = symbol;
        _baseTokenURI = baseTokenURI;

        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    function getName() public view returns (string memory) {
        return _name;
    }

    function getSymbol() public view returns (string memory) {
        return _symbol;
    }

    function getBaseTokenURI() public view returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Token does not exists");
        return _tokenURIs[tokenId];
    }

    function _setTokenURI(uint256 tokenId) internal {
        require(_exists(tokenId), "Token does not exists");
        _tokenURIs[tokenId] = strConcat(_baseTokenURI, uint2str(tokenId));
    }
}

contract SidRealEstateToken is ERC721Metadata("SidRealEstates", "SRE", "https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/") {
    function mint(address to, uint256 tokenId) public onlyOwner returns (bool) {
        _mint(to, tokenId);
        _setTokenURI(tokenId);
        return true;
    }
}