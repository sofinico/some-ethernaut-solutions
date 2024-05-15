// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {GatekeeperTwo} from "../src/levels/GatekeeperTwo.sol";
import {GatekeeperTwoFactory} from "../src/levels/GatekeeperTwoFactory.sol";
import {GatekeeperTwoSolution} from "../src/attacks/GatekeeperTwoSolution.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

contract SolutionTest is Test {
    GatekeeperTwo gk;
    GatekeeperTwoSolution sol;

    function setUp() public {
        gk = new GatekeeperTwo();
    }

    function testSolution() public {
        sol = new GatekeeperTwoSolution(address(gk));

        // if here, deployment went successfull
        assertTrue(true);
    }
}
