// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ICO.sol";
import "../src/IHToken.sol";
import "../src/test/MockV3Aggregator.sol";

contract CounterScript is Script {
    ICO public ico;
    IHToken public ihToken;
    MockV3Aggregator public mockV3Aggregator;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new ICO(ihToken, mockV3Aggregator);
        vm.stopBroadcast();
    }
}
