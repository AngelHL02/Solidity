// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.9;
//pragma solidity >=0.5.9 <0.7.0;

contract Coin {

    //the keyword "public" makes those variables readable from outside -- state var
    address public minter;
    //keep check of balances
    mapping (address => uint) public balances; 

    //broadcast to anyone who is interested 
    //events allows light clients to react on changes efficiently
    event Sent(address from, address to, uint amount);

    //For constructor whose code is run only when the contract is created
    constructor() public {
        //whoever uses the address to create the contract
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public{
        //set limitation: only the minter can mint coin
        if (msg.sender!= minter) return; //will not be executed
        balances[receiver] += amount;
    }

    function send (address receiver, uint amount) public {
        if (balances[msg.sender] < amount) return; //stop the process

        //if amount > balance ---> Process
        //update the balance of the sender
        balances[msg.sender] -= amount;

        //update the balance of the receiver 
        balances[receiver] += amount; 

        //Notify the receiver
        emit Sent(msg.sender, receiver, amount);
        
        //not a must that the receiver
        //only if the receiver "listen" to the event
    }

}

