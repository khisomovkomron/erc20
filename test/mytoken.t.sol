// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "lib/forge-std/src/Test.sol";
import {Script} from "lib/forge-std/src/Script.sol";
import {MyToken} from "../src/mytoken.sol";

contract TestMyToken is Test, Script {
    MyToken token;

    function setUp() public {
        token = new MyToken();
    }

    function testInitialSupply() public {
        uint256 expectedSupply = 100000 * 10 ** token.decimals();
        assertEq(token.totalSupply(), expectedSupply);
    }
}
