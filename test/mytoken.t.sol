// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "lib/forge-std/src/Test.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {MyToken} from "../src/mytoken.sol";
import {DeployMyToken} from "../script/mytoken.s.sol";

contract TestMyToken is Test, Script {
    MyToken token;
    uint256 mintingValue = 100000 * 10 ** token.decimals();
    uint256 constant STARTING_BALANCE = 10 ether;
    address USER = makeAddr("user");

    function setUp() public {
        DeployMyToken deploy = new DeployMyToken();
        token = deploy.run();
        mintingValue = 100000 * 10 ** token.decimals();
        vm.deal(USER, STARTING_BALANCE);
        
        // Grant minter role to this contract for testing
        token.grantRole(token.MINTER_ROLE(), address(this));
    }

    function testInitialSupply() public view {
        uint256 expectedSupply = 100000 * 10 ** token.decimals();
        assertEq(token.totalSupply(), expectedSupply);
    }

    function testMinting() public {
        token.mint(msg.sender, 100000 * 10 ** token.decimals());
        assertEq(token.totalSupply(), mintingValue * 2);
        assertEq(token.balanceOf(USER), mintingValue);
    }
}
