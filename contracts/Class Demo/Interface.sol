pragma solidity ^0.6.0;
// SPDX-License-Identifier: MIT

//function signature/title
//refer to the Counter.sol
interface ICounter { 
    function count() external view returns (uint);
    function increment() external;
}

contract Interaction {
    address counterAddr; //state var

    //connect to the counter
    function setCounterAddr(address _counter) public payable {
       counterAddr = _counter;
    }

    function getCount() external view returns (uint) {
        return ICounter(counterAddr).count();
    }
}
