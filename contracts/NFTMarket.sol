// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarket is Ownable {
    // 用于存储上架的 NFT 信息
    struct Listing {
        uint256 price;   // NFT 价格（单位：MyToken）
        address seller;  // 卖家地址
    }

    // NFT 合约地址
    IERC721 public nftContract;
    // ERC-20 代币合约地址
    IERC20 public paymentToken;

    // 存储每个 tokenId 对应的上架信息
    mapping(uint256 => Listing) public listings;

    constructor(address _nftContract, address _paymentToken) Ownable(msg.sender) {
        nftContract = IERC721(_nftContract);
        paymentToken = IERC20(_paymentToken);
    }

    // 上架 NFT
    function list(uint256 tokenId, uint256 price) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You must own the NFT");
        require(price > 0, "Price must be greater than zero");

        // 上架 NFT
        nftContract.transferFrom(msg.sender, address(this), tokenId);

        listings[tokenId] = Listing({
            price: price,
            seller: msg.sender
        });
    }

    // 购买 NFT
    function buyNFT(uint256 tokenId) external {
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "This NFT is not for sale");

        uint256 price = listing.price;
        address seller = listing.seller;

        // 从买家账户中转移代币
        require(paymentToken.transferFrom(msg.sender, seller, price), "Payment failed");

        // 将 NFT 转移给买家
        nftContract.transferFrom(address(this), msg.sender, tokenId);

        // 清除上架信息
        delete listings[tokenId];
    }

    // 取消上架
    function cancelListing(uint256 tokenId) external {
        Listing memory listing = listings[tokenId];
        require(listing.seller == msg.sender, "You are not the seller");

        // 将 NFT 返回给卖家
        nftContract.transferFrom(address(this), msg.sender, tokenId);

        // 清除上架信息
        delete listings[tokenId];
    }
}
