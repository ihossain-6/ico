// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/IHToken.sol";

contract CounterScript is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new IHToken();
        vm.stopBroadcast();
    }
}
