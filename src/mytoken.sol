// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {AccessControl} from "lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import {Pausable} from "lib/openzeppelin-contracts/contracts/utils/Pausable.sol";
import {console} from "lib/forge-std/src/console.sol";

contract MyToken is ERC20, AccessControl, Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20("MyToken", "MTK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _mint(msg.sender, 100000 * 10 ** 18);
        console.log("Contract started");
    }

    function mint(address to, uint256 value) public onlyRole(MINTER_ROLE) {
        _mint(to, value);
    }

    function burn(address from, uint256 value) public onlyRole(BURNER_ROLE) {
        _burn(from, value);
    }

    function pause() public {
        _pause();
    }

    function unpause() public {
        _unpause();
    }

}
