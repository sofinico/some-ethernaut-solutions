// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {GatekeeperTwo} from "../src/levels/GatekeeperTwo.sol";
import {GatekeeperTwoFactory} from "../src/levels/GatekeeperTwoFactory.sol";
import {GatekeeperTwoSolution} from "../src/attacks/GatekeeperTwoSolution.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

contract TestGatekeeperTwo is Test, Utils {
    Ethernaut ethernaut;
    GatekeeperTwo instance;

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
        GatekeeperTwoFactory factory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        vm.startPrank(player);
        instance = GatekeeperTwo(
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
        vm.prank(player, player);
        new GatekeeperTwoSolution(address(instance));

        /// @dev actually I would've done it this way, but tu avoid compiler warnings...
        // GatekeeperTwoSolution solution = new GatekeeperTwoSolution(address(instance));
        
        assertEq(instance.entrant(), player, "Player is not entrant.");

        vm.prank(player);
        assertTrue(submitLevelInstance(ethernaut, address(instance)));
    }
}