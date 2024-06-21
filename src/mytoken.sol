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
contract MyToken is ERC20, AccessControl, Pausable {
    // EVENTS
    event MintingEvent(address to, uint256 value);
    event BurningEvent(address from, uint256 value);
    event PausingEvent();
    event UnpausingEvent();

    // STATE VARIABLES
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowance;
    /**
     * @dev added required address for roles during the deployment
     */

    constructor(address minter, address burner) ERC20("MyToken", "MTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, minter);
        _grantRole(BURNER_ROLE, burner);
        _mint(msg.sender, 100000 * 10 ** 18);
        console.log("Contract started");
    }

    /**
     * @dev requires role of minter given during deployment
     * @notice this functions helps to mint new tokens
     * @param to an address to which required to mint new tokens
     * @param value amount required to mint
     */
    function mint(address to, uint256 value) public onlyRole(MINTER_ROLE) {
        require(to != address(0), "Address does not exist");
        require(value > 0, "Minting value cannot be 0");
        _mint(to, value);
        _balances[to] += value;
        emit MintingEvent(to, value);
    }

    /**
     * @dev requires role of burner given during deployment
     * @notice this functions helps to burn existing tokens from an address
     * @param from an address from which will burn existing tokens
     * @param value amount required to burn
     */
    function burn(address from, uint256 value) public onlyRole(BURNER_ROLE) {
        require(from != address(0), "Address does not exist");
        require(value > 0, "Burning value cannot be 0");
        _burn(from, value);
        // _balances[from] -= value;

        emit BurningEvent(from, value);
    }

    function balanceOf(address account) public override view returns (uint256) {
        return balanceOf(account);
    }

    function approve(address owner, address spender, uint256 amount) public returns (bool) {
        _allowance[owner][spender] = amount;
        return true;
    }

    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowance[owner][spender];
    }

    function transferFrom(address spender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(spender, recipient, amount);

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
}
