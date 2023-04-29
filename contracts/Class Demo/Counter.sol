// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

contract Counter {
     uint public count;
     //external means this function is for other contracts to use
     function increment() external {
        count += 1;
    }
}
