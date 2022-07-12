// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.15;

import { Test } from "forge-std/Test.sol";

import { runAll } from "../src/CheckSameSign.sol";

contract CheckSameSignTest is Test {
    function testRunAll(int256 a, int256 b) external view {
        runAll(a, b);
    }
}
