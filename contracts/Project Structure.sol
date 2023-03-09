// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract verification{

    //variables to be defined
    address public manager;

    constructor() public {
        manager = msg.sender;
    }

    struct patient{
        string name;
        uint hkid;
        uint timestamp; 
    }




}
