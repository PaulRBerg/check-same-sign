// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.15;

import { console } from "forge-std/console.sol";
import { Script } from "forge-std/Script.sol";

import { runAll } from "../src/CheckSameSign.sol";

contract CheckSameSignScript__DifferentSign1 is Script {
    function run() public view {
        int256 a = int256(type(int96).max);
        int256 b = int256(type(int96).min);
        runAll(a, b);
    }
}

contract CheckSameSignScript__DifferentSign2 is Script {
    function run() public view {
        int256 a = int256(type(int96).min);
        int256 b = int256(type(int96).max);
        runAll(a, b);
    }
}

contract CheckSameSignScript__SameSign1 is Script {
    function run() public view {
        int256 a = int256(type(int96).max);
        int256 b = int256(type(int96).max);
        runAll(a, b);
    }
}

contract CheckSameSignScript__SameSign2 is Script {
    function run() public view {
        int256 a = int256(type(int96).min);
        int256 b = int256(type(int96).min);
        runAll(a, b);
    }
}
