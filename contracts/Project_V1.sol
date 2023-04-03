// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract medical{

/*
    For testing:
    patient_addr: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    hospital: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

    Others: 
    0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB
    0xdD870fA1b7C4700F2BD7f44238821C26f7392148
*/

//--------------------------- settings---------------------------
    //Class: patient
    struct Patient{
        string name;
        uint8 hkid;
        //uint acc_activateTime; 
        bool eligible; //default is false
    }

    address[] registerList;

    address public admin;
    address payable public patient_addr;
    address payable public hospital;

    //mapping (address => uint) public balances; //Keep check of user's balance
    mapping (address => Patient) patient; 

    uint public startTime;
    
    enum StageAcc {Init, Acc_Activated}
    enum StageServiceRequest {Init,Requested,Pending,Confirmed,Reject}

    //initialize the initial status of stages
    StageAcc public stageAcc = StageAcc.Init; //0
    StageServiceRequest public stageService = StageServiceRequest.Init; //0

    constructor(address payable _patient, address payable _hospital){
        admin = msg.sender;
        patient_addr = _patient;
        hospital = _hospital; //Record the hospital's address

        startTime = block.timestamp; //Start time of the whole process
    }

//---------------------------modifiers---------------------------
    modifier adminOnly(){
        require(msg.sender == admin,"Only accessible by admin staff!");
        _;
    }

    //Might be deleted later
    modifier patientOnly(){
        require(msg.sender == patient_addr, "Only patient can set his/her info.");
        _;
    }

    modifier validStage(StageServiceRequest reqStage){
        require(stageService==reqStage,"Not in the specified stage.");
        _;
    }

    //Only accessible by admin and hospital
    modifier accessedOnly(){
        require(msg.sender == admin || msg.sender == hospital,"Access Denied");
        _;
    }

//---------------------------------------------------------------

    function timeNow() public view returns(uint){
        return block.timestamp;
    }

    uint clientNo = 1;

    function register(address _addressPatient) adminOnly public {

        patient[_addressPatient].eligible = true;
        //patient[_addressPatient].

        //Append each address in the dynamic array
        registerList.push(_addressPatient);

        if (block.timestamp > (startTime+ 90 seconds)) {
            stageAcc = StageAcc.Acc_Activated;
        }

    }

    function set_name(address _address,string memory _name) public {
        patient[_address].name = _name;
    }

    function set_id(address _address,uint8 _id) public {
        patient[_address].hkid = _id;
    }

    function return_registeredList() public view returns (address[] memory) {
        // Create a dynamic array to store the registered voters
        address[] memory registered_patient = new address[](registerList.length);

        // Iterate through the array of registered clients and add each one to the array
        for (uint i = 0; i < registerList.length; i++) {
            address patient_addr = registerList[i];
            //if (patient[patient_addr].name != " ") {
                registered_patient[i] = patient_addr;
            //}
        }
        return registered_patient;
    }

    //requesting for services (e.g. AME/
    function request(uint) public{

    }

    //Solidity: Is there a way to get the timestamp of a transaction that executed?
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
