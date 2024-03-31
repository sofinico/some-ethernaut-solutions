// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns(bool);
}

contract Solution {
    address public owner;
    IGatekeeperOne public gatekeeperOne;

    modifier onlyOwner {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _gatekeeperOne) {
        owner = msg.sender;
        gatekeeperOne = IGatekeeperOne(_gatekeeperOne);
    }

    function makeEntrant(bytes8 _gateKey, uint gas) onlyOwner public returns (bool){
        return gatekeeperOne.enter{gas: gas}(_gateKey);
    }
}