//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    uint public tokenCount;

    constructor () ERC721("Rio NFT", "RIO"){}

    function mint(string memory _tokenURI) external returns(uint){
        tokenCount ++;
        _safeMint(msg.sender, tokenCount);
        updateMetadata(tokenCount, _tokenURI);
        return(tokenCount);
    }
    
    function updateMetadata(_tokenCount, _tokenURI) public{
        _setTokenURI(_tokenCount, _tokenURI);

    }

}