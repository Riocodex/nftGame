/*

Johnny's Time
By. Kronos + Zurvan

━━┏┓┏━━━┓┏┓━┏┓┏━┓━┏┓┏━┓━┏┓┏┓━━┏┓┏┓┏━━━┓━━━━┏━━━━┓┏━━┓┏━┓┏━┓┏━━━┓
━━┃┃┃┏━┓┃┃┃━┃┃┃┃┗┓┃┃┃┃┗┓┃┃┃┗┓┏┛┃┃┃┃┏━┓┃━━━━┃┏┓┏┓┃┗┫┣┛┃┃┗┛┃┃┃┏━━┛
━━┃┃┃┃━┃┃┃┗━┛┃┃┏┓┗┛┃┃┏┓┗┛┃┗┓┗┛┏┛┗┛┃┗━━┓━━━━┗┛┃┃┗┛━┃┃━┃┏┓┏┓┃┃┗━━┓
┏┓┃┃┃┃━┃┃┃┏━┓┃┃┃┗┓┃┃┃┃┗┓┃┃━┗┓┏┛━━━┗━━┓┃━━━━━━┃┃━━━┃┃━┃┃┃┃┃┃┃┏━━┛
┃┗┛┃┃┗━┛┃┃┃━┃┃┃┃━┃┃┃┃┃━┃┃┃━━┃┃━━━━┃┗━┛┃━━━━━┏┛┗┓━┏┫┣┓┃┃┃┃┃┃┃┗━━┓
┗━━┛┗━━━┛┗┛━┗┛┗┛━┗━┛┗┛━┗━┛━━┗┛━━━━┗━━━┛━━━━━┗━━┛━┗━━┛┗┛┗┛┗┛┗━━━┛
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

*/


// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

interface ITime {
    function balanceOf(address account) external view returns (uint256);
}

contract Johnny is ERC721Enumerable, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    using Strings for uint256;

    struct Johnnys {
        bool isFrozen;
        uint256 frozenStage;
        uint256 timeLeft;
    }

    mapping(uint256 => Johnnys) public tokenIdToJohnny;

    uint256 public maxSupply;
    uint256 public hourPrice = 1e18;
    uint256 public dayPrice = 24e18;
    address private timeTokenAddress;
    address private minterRole;
    uint256 public mintPrice;
    bool public isMintingActive = true;
    string public baseExtension = ".json";
    mapping(uint256 => string) private phaseToBaseURI;

    constructor(
       string memory _name, 
       string memory _symbol, 
       uint256 _maxSupply, 
       uint256 _mintPrice,
       address _setTimeTokenAddress
       )
    ERC721(_name, _symbol) {
        console.log("Contract deployed!");
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        timeTokenAddress = _setTimeTokenAddress;
        minterRole = msg.sender;
    }

    function flipIsMintingActive() external onlyOwner {
        isMintingActive = true;
    }

    function updateMintPrice(uint256 _newMintPrice) external onlyOwner {
        mintPrice = _newMintPrice;
    }

    function updateBaseExtension(string memory _baseExtension) public onlyOwner {
        baseExtension = _baseExtension;
    }

    function updateMaxSupply(uint256 _newMaxSupply) external onlyOwner {
        maxSupply = _newMaxSupply;
    }
    
    function withdraw() external onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns(string memory _tokenURI) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");

        if(tokenIdToJohnny[_tokenId].timeLeft >= 30 days || tokenIdToJohnny[_tokenId].frozenStage == 5) {
            string memory currentBaseURI = phaseToBaseURI[5];
            return bytes(currentBaseURI).length > 0 ?
                string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : "";

        } else if(tokenIdToJohnny[_tokenId].timeLeft >= 22 days || tokenIdToJohnny[_tokenId].frozenStage == 4) {
            string memory currentBaseURI = phaseToBaseURI[4];
            return bytes(currentBaseURI).length > 0 ?
                string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : "";

        } else if(tokenIdToJohnny[_tokenId].timeLeft >= 14 days || tokenIdToJohnny[_tokenId].frozenStage == 3) {
            string memory currentBaseURI = phaseToBaseURI[3];
            return bytes(currentBaseURI).length > 0 ?
                string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : "";

        } else if(tokenIdToJohnny[_tokenId].timeLeft >= 7 days || tokenIdToJohnny[_tokenId].frozenStage == 2) {
            string memory currentBaseURI = phaseToBaseURI[2];
            return bytes(currentBaseURI).length > 0 ?
                string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : "";

        } else if (tokenIdToJohnny[_tokenId].timeLeft <= 1 seconds || tokenIdToJohnny[_tokenId].frozenStage == 1) {
            string memory currentBaseURI = phaseToBaseURI[1];
            return bytes(currentBaseURI).length > 0 ?
                string(abi.encodePacked(currentBaseURI, _tokenId.toString(), baseExtension)) : "";

        }

    }

    function generateRandomNumber() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, blockhash(block.number), msg.sender))) % 108;
        
    }   

    function fate() external {
        
        uint256 tokenId = generateRandomNumber();
        if(tokenIdToJohnny[tokenId].isFrozen == false && tokenIdToJohnny[tokenId].timeLeft >= 30 days) {
            tokenIdToJohnny[tokenId].isFrozen = true;
            tokenIdToJohnny[tokenId].frozenStage = 5;
            tokenIdToJohnny[tokenId].timeLeft = 0;

        } else if(tokenIdToJohnny[tokenId].isFrozen == false && tokenIdToJohnny[tokenId].timeLeft >= 22 days) {
            tokenIdToJohnny[tokenId].isFrozen = true;
            tokenIdToJohnny[tokenId].frozenStage = 4;
            tokenIdToJohnny[tokenId].timeLeft = 0;

        } else if(tokenIdToJohnny[tokenId].isFrozen == false && tokenIdToJohnny[tokenId].timeLeft >= 14 days) {
            tokenIdToJohnny[tokenId].isFrozen = true;
            tokenIdToJohnny[tokenId].frozenStage = 3;
            tokenIdToJohnny[tokenId].timeLeft = 0;

        } else if(tokenIdToJohnny[tokenId].isFrozen == false && tokenIdToJohnny[tokenId].timeLeft >= 7 days) {
            tokenIdToJohnny[tokenId].isFrozen = true;
            tokenIdToJohnny[tokenId].frozenStage = 2;
            tokenIdToJohnny[tokenId].timeLeft = 0;

        } else if(tokenIdToJohnny[tokenId].isFrozen == false && tokenIdToJohnny[tokenId].timeLeft <= 1 seconds) {
            tokenIdToJohnny[tokenId].isFrozen = true;
            tokenIdToJohnny[tokenId].frozenStage = 1;
            tokenIdToJohnny[tokenId].timeLeft = 0;
        }

    }

    function buyHours(uint256 _amount, uint256 _tokenId) public payable {
        require(ownerOf(_tokenId) == msg.sender, "Error, you're not the owner of this token");
        require(ITime(timeTokenAddress).balanceOf(msg.sender) >= _amount + hourPrice, "Error, send the right amount");
        require(tokenIdToJohnny[_tokenId].timeLeft >= 1 seconds, "Error, you can't buy time in dead phase");
        require(tokenIdToJohnny[_tokenId].isFrozen == false, "Error, your token is frozen!");

        tokenIdToJohnny[_tokenId].timeLeft = tokenIdToJohnny[_tokenId].timeLeft + (_amount * 1 hours);
        
    }

    function buyDays(uint256 _amount, uint256 _tokenId) public payable {
        require(ownerOf(_tokenId) == msg.sender, "Error, you're not the owner of this token");
        require(ITime(timeTokenAddress).balanceOf(msg.sender) >= _amount + dayPrice, "Error, send the right amount");
        require(tokenIdToJohnny[_tokenId].timeLeft >= 1 seconds, "Error, you can't buy time in dead phase");
        require(tokenIdToJohnny[_tokenId].isFrozen == false, "Error, your token is frozen!");

        tokenIdToJohnny[_tokenId].timeLeft = tokenIdToJohnny[_tokenId].timeLeft + (_amount * 1 days);
    }

    function mintJohnny(uint256 _amount) public payable {
        require(maxSupply > totalSupply(), "Error, sold out!");

        if(minterRole == msg.sender) {
            require(msg.value == 0, "Yo, you can mint for free!");

        } else {
            require(isMintingActive, "Error, mintinting is not active");
            require(msg.value >= _amount * mintPrice, "Error, not enough ether");
            require(_amount <= 2, "Error, you can't mint more than 2 per transactions");
        }

        for(uint256 _nfts; _nfts < _amount; _nfts++) {
            uint256 newTokenId = _tokenIds.current();
            _safeMint(msg.sender, newTokenId);
            tokenIdToJohnny[newTokenId].timeLeft = 30 days;
            tokenIdToJohnny[newTokenId].isFrozen;
            _tokenIds.increment();
            console.log("NFT w/ ID %s has been minted to %s", newTokenId, msg.sender);

        }
        
    }

    function walletOfOwner(address _owner) external view returns(uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);

        for(uint256 _index; _index < ownerTokenCount; _index++){
            tokenIds[_index] = tokenOfOwnerByIndex(_owner, _index);
        }

        return tokenIds;
    }


    function burnToken(uint256 _tokenId) public {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        require(ownerOf(_tokenId) == msg.sender, "Error, you're not the owner of this token");

        _burn(_tokenId);
    }

}
