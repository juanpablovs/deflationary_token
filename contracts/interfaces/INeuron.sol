// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract INeuron {

    /// events that record modification to total number of tokens

    /**
     * @notice Event emitted when tokens are rebased
     */
    event Rebase(
        uint256 epoch,
        uint256 prevNeuronsScalingFactor,
        uint256 newNeuronsScalingFactor
    );

    /**
     * @notice Event emitted when tokens are minted
     */
    event Mint(address to, uint256 amount);

    /**
     * @notice Event emitted when tokens are burned
     */
    event Burn(address from, uint256 amount);

}