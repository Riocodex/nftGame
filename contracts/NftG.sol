// SPDX-License-Identifier: MIT
//0x820DAF5fC56E8221cE2B0B00Ba6599Ce7453A3EC mumbai
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NftG is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => uint256) public tokenIdToStrengths;

    // track Strengths
    //track hp
    //track strength
    //track speed


    constructor() ERC721 ("RIO NFT", "RIO"){
    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strengths: ",getStrengths(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ));
    }

    function getStrengths(uint256 tokenId) public view returns (string memory) {
        uint256 strengths = tokenIdToStrengths[tokenId];
        return strengths.toString();
    }


    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    // function tokenURI(uint256 _tokenId) public view virtual override returns(string memory _tokenURI) { 
    //     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token"); 

    //     if(tokenIdToJohnny[_tokenId].timeLeft >= 30 days  tokenIdToJohnny[_tokenId].frozenStage == 5) { 
    //         string memory currentBaseURI = phaseToBaseURI[5]; 
    //         return bytes(currentBaseURI).length > 0 ? 
    //             string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : ""; 

    //     } else if(tokenIdToJohnny[_tokenId].timeLeft >= 22 days  tokenIdToJohnny[_tokenId].frozenStage == 4) { 
    //         string memory currentBaseURI = phaseToBaseURI[4]; 
    //         return bytes(currentBaseURI).length > 0 ? 
    //             string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : ""; 

    //     } else if(tokenIdToJohnny[_tokenId].timeLeft >= 14 days  tokenIdToJohnny[_tokenId].frozenStage == 3) { 
    //         string memory currentBaseURI = phaseToBaseURI[3]; 
    //         return bytes(currentBaseURI).length > 0 ? 
    //             string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : ""; 

    //     } else if(tokenIdToJohnny[_tokenId].timeLeft >= 7 days  tokenIdToJohnny[_tokenId].frozenStage == 2) { 
    //         string memory currentBaseURI = phaseToBaseURI[2]; 
    //         return bytes(currentBaseURI).length > 0 ? 
    //             string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : ""; 

    //     } else if (tokenIdToJohnny[_tokenId].timeLeft <= 1 seconds || tokenIdToJohnny[_tokenId].frozenStage == 1) { 
    //         string memory currentBaseURI = phaseToBaseURI[1]; 
    //         return bytes(currentBaseURI).length > 0 ? 
    //             string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : ""; 

    //     } 

    // }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToStrengths[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function increaseStrength(uint256 tokenId, uint256 _strength) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        tokenIdToStrengths[tokenId] = _strength;
        
    }
}