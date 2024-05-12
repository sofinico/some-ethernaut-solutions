// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/NaughtCoin.sol";
import "src/NaughtCoinAttack.sol";

address constant DEPLOYER = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;

contract NaughtCoinAttackTest is Test {
    NaughtCoin naughtCoin;
    NaughtCoinAttack naughtCoinAttack;

    function setUp() public {
        naughtCoin = new NaughtCoin(DEPLOYER);
        naughtCoinAttack = new NaughtCoinAttack{value: 0.001 ether}(address(naughtCoin));
    }

    function testAttack() public {
        uint balance = naughtCoin.balanceOf(DEPLOYER);
        vm.prank(DEPLOYER);
        naughtCoin.approve(address(naughtCoinAttack), balance);
        
        vm.prank(DEPLOYER);
        naughtCoinAttack.transferTokens();
        
        uint newBalance = naughtCoin.balanceOf(DEPLOYER);
        assertEq(newBalance, 0);
    }
}