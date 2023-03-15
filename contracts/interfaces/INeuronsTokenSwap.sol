// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface INeuronsTokenSwap {

    function mint(address to, uint256 amount) external;

    function rebase(
        uint256 epoch,
        uint256 indexDelta,
        bool positive
    ) external returns (uint256);

    function totalSupply() external view returns (uint256);

    function transferUnderlying(address to, uint256 value)
        external
        returns (bool);

    function fragmentToNeurons(uint256 value) external view returns (uint256);

    function neuronsToFragment(uint256 neurons) external view returns (uint256);

    function balanceOfUnderlying(address who) external view returns (uint256);
}