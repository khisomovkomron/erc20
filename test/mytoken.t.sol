// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "lib/forge-std/src/Test.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {MyToken} from "../src/mytoken.sol";
import {DeployMyToken} from "../script/mytoken.s.sol";

contract TestMyToken is Test, Script {
    MyToken token;
    uint256 mintingValue = 100000 * 10 ** 18;

    function setUp() public {
        DeployMyToken deploy = new DeployMyToken();
        token = deploy.run();
    }

    function testInitialSupply() public view {
        uint256 expectedSupply = 100000 * 10 ** 18;
        assertEq(token.totalSupply(), expectedSupply);
    }

    function testMinting() public {
        token.mint(msg.sender, 100000 * 10 ** 18);
        assertEq(token.totalSupply(), mintingValue * 2);
    }

    function testBurning() public {
        token.burn(msg.sender, (100000 * 10 ** 18) / 2);
        assertEq(token.totalSupply(), 50000 * 10 ** 18);
    }

}
