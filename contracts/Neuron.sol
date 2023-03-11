// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/ERC20PresetMinterRebaser.sol";
import "contracts/interfaces/INeuron.sol";

contract Neuron is ERC20PresetMinterRebaser, Ownable, INeuron {

    using SafeMath for uint256;

    /**
     * @notice Internal decimals used to handle scaling factor
     */
    uint256 public constant internalDecimals = 10**24;

    /**
     * @notice Used for percentage maths
     */
    uint256 public constant BASE = 10**18;

    /**
     * @notice Scaling factor that adjusts everyone's balances
     */
    uint256 public neuronsScalingFactor;

    mapping(address => uint256) internal _neuronsBalances;

    mapping(address => mapping(address => uint256)) internal _allowedFragments;

    uint256 public initSupply;

    bytes32 public DOMAIN_SEPARATOR;

    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH =
        0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    mapping(address => uint256) public nonces;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
        );

    uint256 private INIT_SUPPLY = 1_000_000_000 * BASE;
    uint256 private _totalSupply;

    modifier validRecipient(address to) {
        require(to != address(0x0));
        require(to != address(this));
        _;
    }

    constructor() ERC20PresetMinterRebaser("Neurons", "NEON") {
        neuronsScalingFactor = BASE;
        initSupply = _fragmentToNeurons(INIT_SUPPLY);
        _totalSupply = INIT_SUPPLY;
        _neuronsBalances[owner()] = initSupply;

        emit Transfer(address(0), msg.sender, INIT_SUPPLY);
    }

    /* - SafeMath implementations - */

    function fragmentToNeurons(uint256 value) public view returns (uint256) {
        return _fragmentToNeurons(value);
    }

    function _fragmentToNeurons(uint256 value) internal view returns (uint256) {
        return value.mul(internalDecimals).div(neuronsScalingFactor);
    }

}
