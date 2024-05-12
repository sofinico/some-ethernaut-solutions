// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {NaughtCoin} from "../src/levels/NaughtCoin.sol";
import {NaughtCoinFactory} from "../src/levels/NaughtCoinFactory.sol";
import {NaughtCoinAttack} from "../src/attacks/NaughtCoinAttack.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

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