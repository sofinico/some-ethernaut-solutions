// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {Preservation} from "../src/levels/Preservation.sol";
import {PreservationFactory} from "../src/levels/PreservationFactory.sol";
import {PreservationAttack} from "../src/attacks/PreservationAttack.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

contract TestPreservation is Test, Utils {
    Ethernaut ethernaut;
    Preservation instance;

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
        PreservationFactory factory = new PreservationFactory();
        ethernaut.registerLevel(Level(address(factory)));
        vm.stopPrank();

        vm.startPrank(player);
        instance = Preservation(
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
        /// @notice This solution does not rely on the sender but on the argument to make the attack.
        /// Hence, I don't need to prank.
        PreservationAttack attack = new PreservationAttack(address(instance));

        attack.takeSlotZero();
        assertEq(address(instance.timeZone1Library()), address(attack));

        // console.log("casted address -> uint256", uint256(uint160(address(player)));
        instance.setFirstTime(uint256(uint160(address(player))));
        assertEq(instance.owner(), player);

        vm.prank(player);
        assertTrue(submitLevelInstance(ethernaut, address(instance)));
    }
}
