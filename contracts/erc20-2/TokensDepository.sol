// SCH Course Copyright Policy (C): DO-NOT-SHARE-WITH-ANYONE
// https://smartcontractshacking.com/#copyright-policy
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {rToken} from "./rToken.sol";

/**
 * @title TokensDepository
 * @author JohnnyTime (https://smartcontractshacking.com)
 */
contract TokensDepository {
    rToken public rAave;
    rToken public rUni;
    rToken public rWeth;

    constructor(address _aave, address _uni, address _weth) {
        require(_aave != address(0), "TokensDepository: _aave is the zero address");
        require(_uni != address(0), "TokensDepository: _uni is the zero address");
        require(_weth != address(0), "TokensDepository: _weth is the zero address");

        rAave = new rToken(_aave, "rAave", "rAAVE");
        rUni = new rToken(_uni, "rUni", "rUNI");
        rWeth = new rToken(_weth, "rWeth", "rWETH");
    }

    function deposit(address token, uint256 amount) external {
        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");

        if (token == rAave.underlyingToken()) {
            rAave.mint(msg.sender, amount);
        } else if (token == rUni.underlyingToken()) {
            rUni.mint(msg.sender, amount);
        } else if (token == rWeth.underlyingToken()) {
            rWeth.mint(msg.sender, amount);
        }
    }

    function withdraw(address token, uint256 amount) external {
        require(IERC20(token).balanceOf(address(this)) >= amount, "Insufficient balance");
        if (token == address(rAave.underlyingToken())) {
            rAave.burn(msg.sender, amount);
        } else if (token == address(rUni.underlyingToken())) {
            rUni.burn(msg.sender, amount);
        } else if (token == address(rWeth.underlyingToken())) {
            rWeth.burn(msg.sender, amount);
        }

        bool success = IERC20(token).transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }
}
