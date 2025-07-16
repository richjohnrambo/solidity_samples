// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721URIStorage, Ownable {

    uint256 private _tokenIdCounter;

    // 构造函数，传递名称和符号给 ERC721 的构造函数
    constructor(uint256 initialSupply) ERC721("RedToken", "RT") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply); // 初始供应量铸造给部署者
    }


    // 铸造 NFT
    function mint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _mint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _tokenIdCounter++;
    }

    // 获取当前的 tokenId
    function currentTokenId() public view returns (uint256) {
        return _tokenIdCounter;
    }
}
