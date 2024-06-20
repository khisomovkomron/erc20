// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "lib/forge-std/src/Test.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {MyToken} from "../src/mytoken.sol";
import {DeployMyToken} from "../script/mytoken.s.sol";

contract TestMyToken is Test, Script {
    MyToken token;
    uint256 mintingValue = 100000 * 10 ** 18;
    uint256 allowanceAmount = 50000 * 10 ** 18;
    uint256 constant STARTING_BALANCE = 10 ether;
    address USER = address(0x123);
    address spender = address(0x456);
    address recipient = address(0x789);

    function setUp() public {
        DeployMyToken deploy = new DeployMyToken();
        token = deploy.run();
        token.approve(msg.sender, spender, allowanceAmount);
        // vm.deal(USER, STARTING_BALANCE);
    }

    function testInitialSupply() public view {
        uint256 expectedSupply = 100000 * 10 ** 18;
        assertEq(token.totalSupply(), expectedSupply);
    }

    function testMinting() public {
        token.mint(msg.sender, 100000 * 10 ** 18);
        assertEq(token.totalSupply(), mintingValue * 2);
    }

    function testMintingToNonExistingAddress() public {
        vm.expectRevert();
        token.mint(address(0), 100000 * 10 ** 18);
    }

    function testMintingZeroValue() public {
        vm.expectRevert();
        token.mint(msg.sender, 0);
    }

    function testBurning() public {
        token.burn(msg.sender, (100000 * 10 ** 18) / 2);
        assertEq(token.totalSupply(), 50000 * 10 ** 18);
    }

    function testBurningToNonExistingAddress() public {
        vm.expectRevert();
        token.burn(address(0), 100000 * 10 ** 18);
    }

    function testBurningZeroValue() public {
        vm.expectRevert();
        token.burn(msg.sender, 0);
    }

    function testAllowance() public {
        assertEq(token.allowance(msg.sender, spender), 50000 * 10 ** 18);
    }

    function testTransferFrom() public {
        token.allowance(msg.sender, spender);
        token.transferFrom(spender, recipient, 40000 * 10 ** 18);
        assertEq(token.balanceOf(recipient), 40000 * 10 ** 18);
    }

    function testPauseContract() public {
        token.pause();
        assertTrue(token.paused());
    }

    function testUnpauseContract() public {
        token.pause();
        assertTrue(token.paused());
        token.unpause();

        assertFalse(token.paused());
    }
}
