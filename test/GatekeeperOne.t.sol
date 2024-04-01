// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/GatekeeperOne.sol";
import "src/GatekeeperOneSolution.sol";

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
        console.log("Forwarded gas: %s", ans);
        console.log("Extra gas: %s", ans-multiplier*8191);

        address entrant = gk.entrant();
        assertEq(entrant, DEPLOYER, "Not entrant.");
    }
}
