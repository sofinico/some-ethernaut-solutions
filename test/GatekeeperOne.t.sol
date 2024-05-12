// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "@forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {GatekeeperOne} from "../src/levels/GatekeeperOne.sol";
import {GatekeeperOneFactory} from "../src/levels/GatekeeperOneFactory.sol";
import {GatekeeperOneSolution} from "../src/attacks/GatekeeperOneSolution.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

contract TestGatekeeperOne is Test, Utils {
    Ethernaut ethernaut;
    GatekeeperOne instance;

    address payable owner;
    address payable player;

    bytes8 constant GATEKEY = 0x0023caca00001f38;

    /// @notice Create level instance.
    function setUp() public {
        address payable[] memory users = createUsers(2);

        owner = users[0];
        vm.label(owner, "Owner");

        player = users[1];
        vm.label(player, "Player");

        vm.startPrank(owner);
        ethernaut = getEthernautWithStatsProxy(owner);
        GatekeeperOneFactory factory = new GatekeeperOneFactory();
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        vm.startPrank(player);
        instance = GatekeeperOne(payable(createLevelInstance(ethernaut, Level(address(factory)), 0)));
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
        GatekeeperOneSolution solution = new GatekeeperOneSolution(address(instance));
        
        uint multiplier = 3;
        uint ans = solution.makeEntrant(GATEKEY, multiplier);

        console.log("Total forwarded gas to GatekeeperOne.entrant(): %s", ans);
        console.log("Total consumed gas until gasleft(): %s", ans - multiplier*8191);

        assertEq(instance.entrant(), player, "Player is not entrant.");
        assertTrue(submitLevelInstance(ethernaut, address(instance)));
        vm.stopPrank();
    }
}