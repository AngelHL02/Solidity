// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0<0.9.0;

contract medical{

    //variables to be defined in later stage
    address public manager;
    mapping (address => uint) public balances; //Keep check of user's balance
    mapping (address => Patient) public patient; 
    bool public eligibility; //default eligibility is false

    constructor(){
        manager = msg.sender;
    }
    
    //Class: patient
    struct Patient{
        string name;
        uint hkid;
        uint timestamp; 
    }

    //for queuing of services (e.g. for A&E services)
    function queue() public{

    }

    //verifies the signature
    function verify_signature(string memory _name) public returns (bool){

    }

    //allows light clients to react on changes efficiently
    event Sent(address from, address to, uint amount);

    function make_payment(address receiver, uint amount) public{

    }

/*  References code ---- register user
    //Give $(toVoter) the right to vote on this ballot.
    //Only be called by $(chairperson)
    function register(address toVoter) public{

        //only chairperson can register voters
        //if (msg.sender!= chairperson || voters[toVoter].voted) return; //do nothing

        if (msg.sender!= chairperson) emit 
            Sent("Only chairperson can register user"); //do nothing
        else if (voters[toVoter].voted) emit
            Sent("Voter voted already.");
        else{

        voters[toVoter].weight = 1;     //voters only have 1 vote
        voters[toVoter].voted = false;} //reset voted status to false
    }
*/

/* References code ---- sending $
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
*/

}
