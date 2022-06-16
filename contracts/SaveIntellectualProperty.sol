// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SaveIntellectualProperty is ERC721Enumerable, Ownable {
    // Total count of authors
    uint256 public totalCountAuthors = 0;

    // Mapping from token ID to author address
    mapping(uint256 => address) private authors;

    // Mapping from unical identifier to token ID
    mapping(string => uint256) private tokenIdByIdentifier;

    // Mapping from token ID to unical identifier
    mapping(uint256 => string) private identifierByTokenId;

    // Mapping from author address to tokens list
    mapping(address => uint256[]) private tokensByAuthor;

    // Mapping from author address to tokens list
    mapping(address => uint256[]) private tokensByOwner;

    // Mapping from author address to his name
    mapping(address => string) private authorsNames;

    // Mapping from author address to his description
    mapping(address => string) private authorsDescriptions;

    constructor() ERC721("Save Intellectual Property", "SIP") {}

    function authorOfTokenId(uint256 tokenId) public view returns (address) {
        address author = authors[tokenId];
        require(author != address(0), "SaveIntellectualProperty: token with given id was not registered");

        return author;
    }

    function authorOfIdentifier(string calldata identifier) public view returns (address) {
        uint256 tokenId = tokenIdByIdentifier[identifier];
        require(tokenId != 0, "SaveIntellectualProperty: token with given identifier was not registered");

        return authorOfTokenId(tokenId);
    }

    function ownerOfIdentifier(string calldata identifier) public view returns (address) {
        uint256 tokenId = tokenIdByIdentifier[identifier];
        require(tokenId != 0, "SaveIntellectualProperty: image with given identifier was not registered");

        return super.ownerOf(tokenId);
    }

    function registerNewToken(string calldata identifier, address author) payable public {
        require(author != address(0), "SaveIntellctualProperty: author has null adress");
        require(tokenIdByIdentifier[identifier] == 0, "SaveIntellectualProperty: token with given identifier was register");
        
        // Count new token id
        uint256 tokenId = ERC721Enumerable.totalSupply() + 1;
        
        // Save authors data
        authors[tokenId] = author;
        // Save relation between token id and identifier
        tokenIdByIdentifier[identifier] = tokenId;
        identifierByTokenId[tokenId] = identifier;

        // Decrease total quantity of authors
        if (tokensByAuthor[author].length == 0) {
            totalCountAuthors++;
        }
        // Refill list tokens by author and owner
        tokensByAuthor[author].push(tokenId);
        tokensByOwner[author].push(tokenId);

        // Mint - save to blockchain
        _safeMint(author, tokenId);
    }

    function getTokensByAuthor(address author) public view returns (uint256[] memory) {
        require(author != address(0), "SaveIntellectualProperty: empty address");

        uint256[] memory authorTokens = tokensByAuthor[author];

        require(authorTokens.length != 0, "SaveIntellectualProperty: this author was not registered");

        return authorTokens;
    }

    function getTokensByOwner(address owner) public view returns (uint256[] memory) {
        require(owner != address(0), "SaveIntellectualProperty: empty address");

        uint256[] memory ownerTokens = tokensByOwner[owner];

        require(ownerTokens.length != 0, "SaveIntellectualProperty: this owner has not tokens");

        return ownerTokens;
    }

    function setAuthorName(string calldata name) payable public {
        address author = _msgSender();

        require(keccak256(bytes(name)) != keccak256(bytes(authorsNames[author])), "SaveIntellectualProperty: name the same");

        authorsNames[author] = name;
    }

    function getAuthorName(address author) public view returns (string memory) {
        require(author != address(0), "SaveIntellctualProperty: author has null adress");

        return authorsNames[author];
    }

    function setAuthorDescription(string calldata description) payable public {
        address author = _msgSender();

        require(keccak256(bytes(description)) != keccak256(bytes(authorsDescriptions[author])), "SaveIntellectualProperty: description the same");

        authorsDescriptions[author] = description;
    }

    function getAuthorDescription(address author) public view returns (string memory) {
        require(author != address(0), "SaveIntellctualProperty: author has null adress");

        return authorsDescriptions[author];
    }

    function getImageIdentifier(uint256 tokenId) public view returns (string memory) {
        require(tokenId != 0, "SaveIntellctualProperty: given tokenId was not registered");

        string storage identifier = identifierByTokenId[tokenId];

        require(keccak256(bytes(identifier)) != keccak256(bytes("")), "SaveIntellctualProperty: given relation tokenId with identifier was not registered");

        return identifier;
    }
}
