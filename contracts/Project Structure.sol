// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract medical{

//--------------------------- settings---------------------------
    //Class: patient
    struct Patient{
        string name;
        uint hkid;
        uint timestamp; 
        bool eligible;
    }

    address public superVisor;
    address payable public patient_addr;

    //mapping (address => uint) public balances; //Keep check of user's balance
    mapping (address => Patient) public patient; 
    bool public eligibility; //default eligibility is false

    enum StageAcc {Init, Acc_Activated}
    enum Stage {Init,Requested,Pending,Confirmed}

    uint public startTime;
    StageAcc public stageAcc = StageAcc.Init; //0
    Stage public stage = Stage.Init; //0

    constructor(address payable _patient){
        patient_addr = _patient; //Record the patient's address
        superVisor = msg.sender;
        startTime = block.timestamp; //Start time of the whole process
    }

//---------------------------modifiers---------------------------
    modifier supervisorOnly(){
        require(msg.sender == superVisor,"Only supervisor can call this.");
        _;
    }

    modifier patientOnly(){
        require(msg.sender == patient_addr, "Only patient can set his/her info.");
        _;
    }

    modifier validStage(Stage reqStage){
        require(stage==reqStage);
        _;
    }

//---------------------------------------------------------------
    function timeNow() public view returns(uint){
        return block.timestamp;
    }

    function register(address _addressPatient) supervisorOnly public {
        require(msg.sender == superVisor, "Only accessible by supervisor!");
        patient[_addressPatient].eligible = true;
        if (block.timestamp > (startTime+ 1 minutes)) {
            stageAcc = StageAcc.Acc_Activated;
        }
    }

    function set_name(address _address,string memory _name) public {
        patient[_address].name = _name;
    }

    //requesting for services (e.g. AME/
    function request(uint) public{

    }

/*
    //Check the current (application) status for request services
    function check_status() public{

    }
*/

    //Ref: https://ethereum.stackexchange.com/questions/9858/solidity-is-there-a-way-to-get-the-timestamp-of-a-transaction-that-executed

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
