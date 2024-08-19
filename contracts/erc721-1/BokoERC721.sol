// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BokoERC721 is ERC721, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant NFT_PRICE = 0.1 ether;

    uint256 public totalSupply;

    constructor() ERC721("BokoERC721", "BOKO") {}

    function mint() external payable {
        require(totalSupply < MAX_SUPPLY, "Sold out");
        require(msg.value >= NFT_PRICE, "Insufficient funds");

        if (msg.value > NFT_PRICE) {
            payable(msg.sender).call{value: msg.value - NFT_PRICE}("");
        }

        totalSupply++;
        _safeMint(msg.sender, totalSupply);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyOwner {
        super.safeTransferFrom(from, to, tokenId);
    }
}
