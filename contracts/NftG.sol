//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    uint public tokenCount;
    mapping(uint256 => uint256) public tokenIdStrength;

    constructor () ERC721("Rio NFT", "RIO"){}

    function mint(string memory _tokenURI) external returns(uint){
        tokenCount ++;
        _safeMint(msg.sender, tokenCount);
        _setTokenURI(tokenCount, _tokenURI)
        return(tokenCount);
    }
    
    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdStrength[tokenId];
        return strength;
    }

}