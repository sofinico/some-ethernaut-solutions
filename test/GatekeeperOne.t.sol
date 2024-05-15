// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
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

    bytes8 gateKey;

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
        instance = GatekeeperOne(
            payable(createLevelInstance(ethernaut, Level(address(factory)), 0))
        );
        vm.stopPrank();

        // let's create the gate key
        gateKey = createKey(player);
    }

    /// @notice Check the intial state of the level and enviroment.
    function testInit() public {
        vm.startPrank(player);
        assertFalse(submitLevelInstance(ethernaut, address(instance)));
    }

    /// @notice Test the solution for the level.
    function testSolve() public {
        /// @notice This is the minimum multiplier possible.
        uint multiplier = 3;
        
        vm.prank(player);
        GatekeeperOneSolution solution = new GatekeeperOneSolution(
            address(instance)
        );

        vm.prank(player, player);
        uint offset = solution.makeEntrant(gateKey, multiplier);
        assertEq(instance.entrant(), player, "Player is not entrant.");

        vm.prank(player);
        assertTrue(submitLevelInstance(ethernaut, address(instance)));

        console.log("Total consumed gas until gasleft(): %s", offset);
    }

    function createKey(address origin) private pure returns (bytes8) {
        /**
        Solidity uses hexadecimal notation for defining bytes values. In particular, the gate key is a bytes8 type.
        Let's deduce the requirements of gateThree modifier to create the opening gatekey.

        1. First require: uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))
       
        Note casting bytesN values into a smaller bytesM type in Solidity (N > M), keeps the first bytes and truncates 
        the last ones. But for N-bit binary values, is the opposite. When converting from a larger integer type into a 
        smaller one, the bits on the right are kept while the bits on the left are lost. 
        
        So here, since we are casting integer types, the "last" 16 bits can be anything and bits in positions [16; 32) 
        (from right to left) must be zero in order to accomplish the condition. 

        Current array of bytes: [?, ?, ?, ?, 0, 0, X, Y]

        2. Second require: uint32(uint64(_gateKey)) != uint64(_gateKey)
        
        This means the obtained casted uint64 number cannot be represented as a uint32 due to it size. So at least one 
        bit in position [32; 64) (from right to left) has to be 1. 

        Current array of bytes: [A, 0, 0, 0, 0, 0, X, Y] or [0, A, 0, 0, 0, 0, X, Y] or ...

        3. Third require: uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))

        This is nice. Here we are constraining X and Y values ("last" 16 bits) in order to match "last" 2 bytes of an 
        arbitrary address.
         */

        // 2**60 was chosen randomly, it can be any number from 2**32 to 2**64 - 1 inclusive.
        bytes8 key = bytes8(uint64(uint16(uint160(origin))) + 2 ** 60);

        return key;
    }
}
