// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import {Pausable} from "lib/openzeppelin-contracts/contracts/utils/Pausable.sol";

contract MyToken is ERC20, AccessControl, Pausable {
    address public owner = msg.sender;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("MyToken", "MTK") {
        
        _mint(msg.sender, 100000 * 10 ** decimals());
    }

    modifier onlyMinter() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyBurner() {
        require(msg.sender == owner);
        _;
    }

    function mint(address to, uint256 value) public onlyMinter {
        _mint(to, value);
    }

    function burn(address from, uint256 value) public onlyBurner {
        _burn(from, value);
    }

    function pauser() public {
        _pause();
    }

    function unpause() public {
        _unpause();
    }
}
