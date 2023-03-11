// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract INeuron {

    /// events that record modification to total number of tokens

    /**
     * @notice Event emitted when tokens are rebased
     */
    event Rebase(
        uint256 epoch,
        uint256 prev
    );



}