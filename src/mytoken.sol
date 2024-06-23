// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import {Pausable} from "lib/openzeppelin-contracts/contracts/utils/Pausable.sol";
import {console} from "lib/forge-std/src/console.sol";

/**
 * @title an ERC20 token that implements basic functions - minting, burning, pause, unpause
 * @author Komron Khisomov
 * @notice This contract is not audited, do not use it in mainnet
 */
contract MyToken is AccessControl, Pausable {
    // ERRORS
    error InsufficientBalance1(address from, uint256 fromBalance, uint256 value);
    error AddressDoesNotExist();
    error MintingValueLessThanZero();
    error BurningValueLessThanZero();
    error NotApprovedAllowance();
    error InsufficientFunds();

    // EVENTS
    event MintingEvent(address to, uint256 value);
    event BurningEvent(address from, uint256 value);
    event PausingEvent();
    event UnpausingEvent();
    event TransferToken(address from, address to, uint256 amount);

    // STATE VARIABLES
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowance;

    /**
     * @dev add required address for roles during the deployment
     */
    constructor(string memory name_, string memory symbol_) {
        // _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // _grantRole(MINTER_ROLE, minter);
        // _grantRole(BURNER_ROLE, burner);
        _name = name_;
        _symbol = symbol_;
        mint(msg.sender, 100000 * 10 ** 18);
        console.log("Contract started");
    }

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    /**
     * @dev requires role of minter given during deployment
     * @notice this functions helps to mint new tokens
     * @param to an address to which required to mint new tokens
     * @param value amount required to mint
     */
    function mint(address to, uint256 value) public {
    // function mint(address to, uint256 value) public onlyRole(DEFAULT_ADMIN_ROLE) {
        if(to == address(0)) {
            revert AddressDoesNotExist();
        }

        if(value == 0) {
            revert MintingValueLessThanZero();
        }

        _updateToken(address(0), to, value);
        emit MintingEvent(to, value);
    }

    /**
     * @dev requires role of burner given during deployment
     * @notice this functions helps to burn existing tokens from an address
     * @param from an address from which will burn existing tokens
     * @param value amount required to burn
     */
    // function burn(address from, uint256 value) public onlyRole(BURNER_ROLE) {
    function burn(address from, uint256 value) public {
        if(from == address(0)) {
            revert AddressDoesNotExist();
        }
        if(value == 0) {
            revert BurningValueLessThanZero();
        }

        _updateToken(from, address(0), value);
        emit BurningEvent(from, value);
    }

    /**
    * @notice function that returns total amount of tokens for current moment
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @notice function that returns amount of tokens kept in balance of an account
    * @param account that holds tokens
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
    * @notice function that creates allowance of spender to be allowed amount of tokens from owners account in _allowance mapping
    * @param owner an address required to check the allowance before transfer
    * @param spender an address that can send allowed amount of tokens from owner account
    * @param amount of tokens that will be transferred
     */
    function approve(address owner, address spender, uint256 amount) public returns (bool) {
        _allowance[owner][spender] = amount;
        return true;
    }
    /**
    * @notice a function that returns allowance of spender from _allowance mapping
    * @param owner an address required to check the allowance before transfer
    * @param spender an address that can send allowed amount of tokens from owner account
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowance[owner][spender];
    }

    /**
    * @notice this function should check whethere allowance is approved or not, if not returning false, else true
    * currently function approve always returns true, should be put condition 
     */
    function spendAllowance(address owner, address spender) private view returns (bool) {
        if (allowance(owner, spender) > 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
    * @notice function that transfers tokens from one account to another, this is not main function of transfer, function _update should overriden
    * @param owner an address required to check the allowance before transfer
    * @param spender an address that can send allowed amount of tokens from owner account
    * @param recipient an address that will receive tokens from owners account send by spender 
    * @param amount of tokens that will be transferred
     */
    function transferFrom(address owner, address spender, address recipient, uint256 amount) public returns (bool) {
        if(spendAllowance(owner, spender) == false) {
            revert NotApprovedAllowance();
        } else{
            _updateToken(spender, recipient, amount);
        }

        return true;
    }

    /**
     * @notice this functions helps to pause (lock) contract from minting and burning and other function
     */
    function pause() public {
        _pause();
        emit PausingEvent();
    }

    /**
     * @notice this function helps to unpause (unlock) a contract for minting and burning
     */
    function unpause() public {
        _unpause();
        emit UnpausingEvent();
    }

    /**
     * @notice this function is used in minting/burning and transferFrom, according to from/to conditions the logic of the function changes. 
     * If from is empty, then minting happens, if to is empty, then burning happens, else transfer is implemented
     * @param from an address from which tokens are sent
     * @param to an address to which tokens are sent
     * @param amount amount of tokens burnt/sent/transferred 
     */
    function _updateToken(address from, address to, uint256 amount) private {
        if(from == address(0)) {
            _totalSupply += amount;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < amount) {
                revert InsufficientBalance1(from, fromBalance, amount);
            }
            _balances[from] = fromBalance - amount;
        }

        if(to == address(0)) {
            _totalSupply -= amount;
        } else {
            _balances[to] += amount;
        }

        emit TransferToken(from, to, amount);

    }

    // TODO or can be DONE
    // function that counts total amount of minted tokens
    // function that counts total amount of burnt tokens
    // function that can returns total number of token holders
    // function that can returns list of all holder addresses
    // function that can give other address the admin role
}
