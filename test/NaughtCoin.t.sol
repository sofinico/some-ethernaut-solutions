// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {NaughtCoin} from "../src/levels/NaughtCoin.sol";
import {NaughtCoinFactory} from "../src/levels/NaughtCoinFactory.sol";
import {NaughtCoinAttack} from "../src/attacks/NaughtCoinAttack.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

contract TestNaughtCoin is Test, Utils {
    Ethernaut ethernaut;
    NaughtCoin instance;

    address payable owner;
    address payable player;

    /// @notice Create level instance.
    function setUp() public {
        address payable[] memory users = createUsers(2);

        owner = users[0];
        vm.label(owner, "Owner");

        player = users[1];
        vm.label(player, "Player");

        vm.startPrank(owner);
        ethernaut = getEthernautWithStatsProxy(owner);
        NaughtCoinFactory factory = new NaughtCoinFactory();
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        vm.startPrank(player);
        instance = NaughtCoin(
            payable(createLevelInstance(ethernaut, Level(address(factory)), 0))
        );
        vm.stopPrank();
    }

    /// @notice Check the intial state of the level and enviroment.
    function testInit() public {
        vm.startPrank(player);
        assertFalse(submitLevelInstance(ethernaut, address(instance)));
    }

    /// @notice Test the solution for the level.
    function testSolve() public {
        vm.startPrank(player);
        NaughtCoinAttack attack = new NaughtCoinAttack{value: 0.001 ether}(
            address(instance)
        );

        uint balance = instance.balanceOf(player);
        instance.approve(address(attack), balance);

        attack.transferTokens();

        uint newBalance = instance.balanceOf(player);
        assertEq(newBalance, 0);

        assertTrue(submitLevelInstance(ethernaut, address(instance)));
    }
}