pragma solidity ^0.8.20;

import {Script} from "lib/forge-std/src/Script.sol";
import {MyToken} from "../src/mytoken.sol";

contract DeployMyToken is Script {

    function run() external returns (MyToken) {
        vm.startBroadcast();

        MyToken mytoken = new MyToken("Test", "TST");

        vm.stopBroadcast();

        return mytoken;
    }
}
