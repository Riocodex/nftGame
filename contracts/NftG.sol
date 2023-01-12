
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {
    mapping(uint256 => string) public metadata;
    mapping(uint256 => address) public ownerOf;

    constructor() ERC721("MyNFT", "MNFT") public {}

    function mint(address _to, uint256 _tokenId, string memory _metadata) public {
        require(_to != address(0));
        require(_tokenId != 0);
        _mint(_to, _tokenId);
        metadata[_tokenId] = _metadata;
        ownerOf[_tokenId] = _to;
    }

    function setMetadata(uint256 _tokenId, string memory _metadata) public {
        require(msg.sender == ownerOf[_tokenId]);
        metadata[_tokenId] = _metadata;
    }
}
// The contract inherits from the ERC721Full contract provided by OpenZeppelin, which includes all the necessary functionality for an ERC-721 compliant token. The mint function allows a user to mint a new NFT by calling the _mint function provided by the ERC721Full contract, and then adds the new metadata and the owner of the NFT. The setMetadata function allows the owner of the NFT to change the metadata of that NFT, it will check if the msg.sender is the owner of the NFT before updating the metadata.

// It's important to note that this is just an example and depending on the requirements of your specific use case, you may need to include additional functionality or make other changes to the contract.



