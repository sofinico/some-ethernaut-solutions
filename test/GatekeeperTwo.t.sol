// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/GatekeeperTwo.sol";
import "src/GatekeeperTwoSolution.sol";

contract SolutionTest is Test {
    GatekeeperTwo gk;
    Solution sol;

    function setUp() public {
        gk = new GatekeeperTwo();
    }

    function testSolution() public {
        sol = new Solution(address(gk));

        // if here, deployment went successfull
        assertTrue(true);
    }
}
