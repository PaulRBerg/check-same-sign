// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.15;

import { console } from "forge-std/console.sol";

/// @dev https://twitter.com/PaulRBerg/status/1546240870025936904
function checkSameSign1(int256 a, int256 b) pure returns (bool result) {
    // sa = sgt(a, sub(0,1))
    // sb = sgt(b, sub(0,1))
    // result = sa ^ sb == 0
    assembly {
        let sa := sgt(a, sub(0, 1))
        let sb := sgt(b, sub(0, 1))
        result := iszero(xor(sa, sb))
    }
}

/// @dev https://twitter.com/fiveoutofnine/status/1546244399780298754
function checkSameSign2(int256 a, int256 b) pure returns (bool result) {
    // sha = a > 255
    // shb = a > 255
    // result = (sha ^ shb) == 0
    assembly {
        result := iszero(xor(shr(255, a), shr(255, b)))
    }
}

/// @dev https://twitter.com/boredGenius/status/1546247355015495686
function checkSameSign3(int256 a, int256 b) pure returns (bool result) {
    // result = (a ^ b) >> 255 == 0
    assembly {
        result := iszero(shr(255, xor(a, b)))
    }
}

/// @dev https://twitter.com/walden_yan/status/1546266161310040064
function checkSameSign4(int256 a, int256 b) pure returns (bool result) {
    // Solidity uses the 256-bit length numbers from 0x80...00 to 0xff...ff to represent
    // negative numbers (using two's complement). Thus we can consider the left-most bit
    // as a litmus test for whether a number is negative.
    //   - If the left-most bits are both 0 or both 1, a and b have the same sign.
    //   - If the left-most bits are not both 0 or both 1, a and b don't have the same sign.
    assembly {
        result := lt(xor(a, b), 0x8000000000000000000000000000000000000000000000000000000000000000)
    }
}

/// @dev https://twitter.com/recmo/status/1546265802705235968
function checkSameSign5(int256 a, int256 b) pure returns (bool result) {
    assembly {
        result := iszero(slt(xor(a, b), 0))
    }
}

/// @dev https://twitter.com/chfast/status/1546259447370203138
function checkSameSign6(int256 a, int256 b) pure returns (bool result) {
    result = (a ^ b) > -1;
}

/// @dev https://twitter.com/big_tech_sux/status/1546253104051474432
function checkSameSign7(int256 a, int256 b) pure returns (bool result) {
    result = a < 0 == b < 0;
}

/// @dev Run all functions and console log the gas costs for each function.
function runAll(int256 a, int256 b) view {
    uint256 gasLeft = gasleft();
    bool sameSign1 = checkSameSign1(a, b);
    uint256 gasCost = gasLeft - gasleft();
    console.log("iszero(xor(sa, sb)):                 ", gasCost, sameSign1);

    gasLeft = gasleft();
    bool sameSign2 = checkSameSign2(a, b);
    gasCost = gasLeft - gasleft();
    console.log("iszero(xor(shr(255, a), shr(255, b)))", gasCost, sameSign2);

    gasLeft = gasleft();
    bool sameSign3 = checkSameSign3(a, b);
    gasCost = gasLeft - gasleft();
    console.log("iszero(shr(255, xor(a, b)))          ", gasCost, sameSign3);

    gasLeft = gasleft();
    bool sameSign4 = checkSameSign4(a, b);
    gasCost = gasLeft - gasleft();
    console.log("lt(xor(a, b), 0x800...00             ", gasCost, sameSign4);

    gasLeft = gasleft();
    bool sameSign5 = checkSameSign5(a, b);
    gasCost = gasLeft - gasleft();
    console.log("iszero(slt(xor(a, b), 0))            ", gasCost, sameSign5);

    gasLeft = gasleft();
    bool sameSign6 = checkSameSign6(a, b);
    gasCost = gasLeft - gasleft();
    console.log("(a ^ b) > -1                         ", gasCost, sameSign6);

    gasLeft = gasleft();
    bool sameSign7 = checkSameSign7(a, b);
    gasCost = gasLeft - gasleft();
    console.log("a < 0 == b < 0                       ", gasCost, sameSign7);

    assert(sameSign1 == sameSign2);
    assert(sameSign2 == sameSign3);
    assert(sameSign3 == sameSign4);
    assert(sameSign4 == sameSign5);
    assert(sameSign5 == sameSign6);
    assert(sameSign6 == sameSign7);
}
