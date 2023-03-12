//-------------This code is modified based on Ballot_v1.sol-------------
//Voting system

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.9;

contract Ballot{
    struct Voter{
        //weight of the voter, can be used to give certain votes more power
        uint weight; //uint256 if not specified
        bool voted; //whether or not the voter has voted
        uint8 vote; //index of the proposal that the voter voted for; begins with 0
        //address delegate;
    }

    //Define the Proposal struct with voteCount property
    struct Proposal{ //similar as python class
        //no. of votes that the proposal has received
        uint voteCount; 
        //could add other data about proposal
    }

    //Declare the proposals array
    Proposal[] proposals; //Proposal is a custom data type
    //keep check which proposal have been voted (count)

    //declare the chairperson's address and the voters mapping
    address chairperson; 
    mapping(address => Voter) voters;

    //For constructor whose code is run only when the contract is created
    constructor(uint8 _numProposals) public {
        //record the wallet address of the deployer
        chairperson = msg.sender; 
        //chairperson have 2 votes
        voters[chairperson].weight = 2; 
        proposals.length = _numProposals;
    }

    event Sent(string message);

/* //Original code for function register()
    function register(address toVoter) public{
        //only chairperson can register voters
        if (msg.sender!= chairperson || voters[toVoter].voted) return; //do nothing
        voters[toVoter].weight = 1;     //voters only have 1 vote
        voters[toVoter].voted = false; //reset voted status to false
*/

    //Give $(toVoter) the right to vote on this ballot.
    //Only be called by $(chairperson) 
    function register(address toVoter) public{

        require(msg.sender == chairperson, "Only chairperson can register user");
        require(!voters[toVoter].voted, "Voter voted already.");
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        //registerList.push(toVoter);

    }

/* //[BETA]: function register2() --> returns an array of registered users
    function register2(address toVoter) public returns(address[] memory registeredList){
        if (msg.sender!= chairperson) emit 
            Sent("Only chairperson can register user"); //do nothing
        else if (voters[toVoter].voted) emit
            Sent("Voter voted already.");
        else{

        voters[toVoter].weight = 1;     //voters only have 1 vote
        voters[toVoter].voted = false;
    
        registeredList.push(voters[toVoter]);
        } 
    }
*/

/* //Original code for function vote()
    function vote(uint8 toProposal) public{
        //store it in "storage" for permanent record
        //the address who clicked this function
        Voter storage sender = voters[msg.sender];

        //check whether the voters have votes
        //	|| (Logical OR)
        //If any of the two operands are non-zero, then the condition becomes true.

        //Stop the process if the sender has voted or proposalNum out of range
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 
    }
*/

/*  function return_registeredList() <--- gas leakage
    function return_registeredList() public view returns (address[] memory) {
    // Create a dynamic array to store the registered voters
    address[] memory registeredVoters = new address[](msg.sender.balance);

    uint count = 0;
    // Iterate through the mapping of voters and add each registered voter to the array
    for (uint i = 0; i < 10; i++) {
        address voterAddress = registeredVoters[i];
        if (voters[voterAddress].weight > 0) {
            registeredVoters[count] = voterAddress;
            count++;
        }
    }
    return registeredVoters;
    }
*/

    function vote(uint8 toProposal) public{
        //store it in "storage" for permanent record
        //the address who clicked this function
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Vote completed!");
        require(toProposal <= proposals.length, "Proposal out of range.");

        toProposal --; //toProposal=toProposal-1;
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 
    }

    //function to show voteCount for a specific proposal
    function check_votes(uint8 index) public view returns (uint voteCount){
        require(index <= proposals.length, "Proposal out of range.");
        index --; //index=index-1;
        voteCount = proposals[index].voteCount;
    }

/*  Alternative method(s) to show voteCount for a specific proposal
    //Alternative

    //#1
    function check_votes(uint8 index) public view returns (uint voteCount){
        voteCount = proposals[(index-1)].voteCount;
    }

    //#2
    function check_votes(uint8 index) public view returns (uint256) {
        return proposals[(index-1)].voteCount;
    }

    //#3
    function check_votes2(uint8 index) public view returns (uint voteCount){
        if (index >= proposals.length) {
            // Handle the error by returning a default value or throwing an exception
            // In this case, we return 0 as the default value
            return 0;
        }
        voteCount = proposals[(index-1)].voteCount;
    }

*/

    //V2: function winningProposal()
    //determine the winning proposal
    //LIMITATION: Cannot encounter case for same votes (i.e. >1 winners)
    //view mode --> Read only
    function winningProposal() public view returns 
            (uint8 _winningProposal, uint winningVoteCount) {
        //uint256 winningVoteCount = 0;

        //Iterate through all proposals to find the one with most votes (for loop)
        //for prop=0 to proposals.lenth, prop ++ == prop +1 
        for (uint8 prop=0;prop<proposals.length;prop++)

            if (proposals[prop].voteCount > winningVoteCount){
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }

    }

/*    //returning an array of tie winners
    function winningProposal() public view returns 
            (uint[] memory _results) {
            //, uint8 _winningProposal, uint _winVoteCount, uint8 _NoOfWinners) {
        uint winningMaxVoteCount = 0;
        uint8 countNoOfWinners = 0;

        //determines the maximum vote count
        for (uint prop=0;prop<proposals.length;prop++)
            if (proposals[prop].voteCount > winningMaxVoteCount){
                winningMaxVoteCount = proposals[prop].voteCount;
                //_winningProposal = prop;
                countNoOfWinners = 1;
            } 
            //determines the number of proposals with max vote count
            else if (proposals[prop].voteCount == winningMaxVoteCount) {
                countNoOfWinners++; //countNoOfWinners=countNoOfWinners+1
            }

        // Create a new array to store the indexes of the maximum values
        // countNoOfWinners is the length of the newly created dynamic array
        uint[] memory resultListOfWinners = new uint[](countNoOfWinners);

        uint indexWinner = 0;

        // Loop through the array again to find the indexes of the maximum values
        for (uint i = 0; i < proposals.length; i++) {
            if ((proposals[i].voteCount == winningMaxVoteCount) && (winningMaxVoteCount != 0)){
                //stores those indexes in the array: resultListOfWinners
                resultListOfWinners[indexWinner] = i;
                indexWinner++; //indexWinner=indexWinner+1
            }
        }
        return _results = resultListOfWinners;
        }

*/

}


