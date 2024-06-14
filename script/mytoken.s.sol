pragma solidity ^0.8.20;

import {Script} from "lib/forge-std/src/Script.sol";
import {MyToken} from "../src/mytoken.sol";

contract DeployMyToken is Script {

    function run() external returns (MyToken) {
        vm.startBroadcast();

        MyToken mytoken = new MyToken();
        mytoken.grantRole(mytoken.MINTER_ROLE(), msg.sender);
        mytoken.grantRole(mytoken.BURNER_ROLE(), msg.sender);

        vm.stopBroadcast();

        return mytoken;
    }
}
