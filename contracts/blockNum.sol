// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Example of using block.number
contract BlockNumberExample {
    uint256 public lastBlockNumber;
    
    function setLastBlockNumber() public {
        lastBlockNumber = block.number;
    }
    
    function canCall() public view returns(bool) {
        return block.number > lastBlockNumber + 10;
    }
}

/*
    In this example, the smart contract has a public variable lastBlockNumber 
    that is set to the current block number every time the setLastBlockNumber() function is called. 
    The canCall() function checks whether at least 10 blocks have passed since the last time 
    etLastBlockNumber() was called. If at least 10 blocks have passed, the function returns true, 
    otherwise it returns false.

    This smart contract could be used to restrict certain actions to a specific time period, 
    such as allowing users to call a function only once every 10 blocks. 
    By using block.number to keep track of the last block number at which the function was called, 
    the smart contract can enforce this restriction.

    Note that block.number should not be used as a reliable way to measure time, 
    as block times can vary and may not be consistent. For more precise time measurement, 
    it is recommended to use other mechanisms such as the block timestamp (block.timestamp) 
    or an external time oracle.

*/
