pragma solidity ^0.6.8;
// SPDX-License-Identifier: MIT

contract Counter {
     uint public count;
     //external means this function is for other contracts to use
     function increment() external {
        count += 1;
    }
}
