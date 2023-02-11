// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/test/MockV3Aggregator.sol";

contract CounterScript is Script {

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new MockV3Aggregator(8, 2e11);
        vm.stopBroadcast();
    }
}
