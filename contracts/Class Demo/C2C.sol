//This smart contract demonstrates contract to contract calls (i.e. C2C calls)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//in parall

/*
The Callee and Caller contract are simply 2 contracts that interacts with 
each other by calling each other's function(s).

The Callee contract has 2 functions that can be called by the Caller contract,
and the caller contract has 3 functions that call functions in the Callee
contract.

In summary, while the Caller and Callee contracts are related and interact with
each other.

They are seperate contracts and do not have a parent-child relationship.

*/

contract Callee {
    uint public x;
    uint public value;

/*  function setX() and setXandSendEther() is to help you distinguish the
difference between the use of "payable"

"msg.value" contains the Ether value

*/

    //This function sets the value of x and returns it
    function setX(uint _x) public returns (uint) {
        x = _x;
        return x;
    }

/*  This function sets the value of x, stores the amount of ether sent with
the transaction in the value variable, and returns both x and value.
*/

    function setXandSendEther(uint _x) public payable returns (uint, uint) {
        x = _x;
        value = msg.value;
        return (x, value);
    }

/*
To check the total amount of Ether stored in the Callee contract
In Solidity, address(this) refers to the address of the current 
contract instance, and the balance property of an address represents
the current balance of that address in units of wei.

*/
    function getContractBalance() public view returns(uint256){
        return address(this).balance;
    }

}

/*
Another smart contract, needs to use the dropdown list to choose it
and then deploy it.

The Caller contract does not have any state variables,
because it does not need to store any data between function calls,
and instead simply passes parameters and receives returned values from
the Callee contract using local variables. 

*/

contract Caller {

/*  Notes:
    Method 1: to change the X value of Callee
    Without address as input parameter
    Callee is the name of the contract which it is calling
*/
    //This functions sets the value of x and returns it
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x);
    }

    //Method 2: to change the X value of Callee
    //With address as input parameter

    //Callee is the data type, callee is the name of variable
    function setXFromAddress(address _addr, uint _x) public {
        Callee callee = Callee(_addr);
        callee.setX(_x);
    }

    // ":" sets the value variable
    function setXandSendEther(Callee _callee, uint _x) public payable {
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}


