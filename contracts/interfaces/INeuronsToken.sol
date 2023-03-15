// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface INeuronsToken {
    function mint(address to, uint256 amount) external;
    function totalSupply() external view returns (uint256);
    function transferUnderlying(address to, uint256 value) external returns (bool);
    function fragmentToNeurons(uint256 value) external view returns (uint256);
    function neuronsToFragment(uint256 eggs) external view returns (uint256);
    function balanceOfUnderlying(address who) external view returns (uint256);
    function burn(uint256 amount) external;
}