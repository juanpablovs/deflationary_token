// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/ERC20PresetMinterRebaser.sol";
import "contracts/interfaces/INeuron.sol";

contract Neuron is ERC20PresetMinterRebaser, Ownable, INeuron {

    using SafeMath for uint256;



}