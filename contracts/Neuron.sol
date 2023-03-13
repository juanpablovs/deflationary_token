// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/ERC20PresetMinterRebaser.sol";
import "contracts/interfaces/INeuron.sol";
import "hardhat/console.sol";
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

// TODO: check address is correct
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant PERMIT_TYPEHASH =
        0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;

    mapping(address => uint256) public nonces;

// TODO: check this is still valid
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

    constructor() ERC20PresetMinterRebaser("Neurons", "NRS") {
        neuronsScalingFactor = BASE;
        initSupply = _fragmentToNeurons(INIT_SUPPLY);
        console.log("INIT_SUPPLY es %s -- initSupply es %s", initSupply, INIT_SUPPLY);
        _totalSupply = INIT_SUPPLY;
        _neuronsBalances[owner()] = initSupply;

        emit Transfer(address(0), msg.sender, INIT_SUPPLY);
    }




    /* - ERC20 Overrides - */

    /**
     *
     * @param addr The address to get balance from
     * @return The balance of addr
     */
    function balanceOf(address addr) public view override returns (uint256) {
        return _neuronsToFragment(_neuronsBalances[addr]);
    }

    /**
     * @dev Overrides Transfer to Transfer tokens to a specified address
     * @param to The address to transfer to
     * @param value The amount to be transferred
     * @return True on success else false
     */
    function transfer(address to, uint256 value)
        public
        override
        validRecipient(to)
        returns (bool)
    {
        // underlying balance is stored in neurons, so divide by current scaling factor

        // note, this means as scaling factor grows, dust will be untransferrable.
        // minimum transfer value == neuronsScalingFactor / 1e24;

        // get amount in underlying
        uint256 neuronsValue = _fragmentToNeurons(value);

        // sub from balance of sender
        _neuronsBalances[msg.sender] = _neuronsBalances[msg.sender].sub(neuronsValue);

        // add to balance of receiver
        _neuronsBalances[to] = _neuronsBalances[to].add(neuronsValue);

        emit Transfer(msg.sender, to, value);

        return true;
    }





















    /* - SafeMath implementations - */

    function fragmentToNeurons(uint256 value) public view returns (uint256) {
        return _fragmentToNeurons(value);
    }

    function _fragmentToNeurons(uint256 value) internal view returns (uint256) {
        return value.mul(internalDecimals).div(neuronsScalingFactor);
    }

    function neuronsToFragment(uint256 neurons) external view returns (uint256) {
        return _neuronsToFragment(neurons);
    }

    function _neuronsToFragment(uint256 neurons) internal view returns (uint256) {
        return neurons.mul(neuronsScalingFactor).div(internalDecimals);
    }

}
