//Voting system
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.9 <0.7.0;

contract Ballot{
    struct Voter{
        //weight of the voter, can be used to give certain votes more power
        uint weight; //uint256 if not specified
        //whether or not the voter has voted
        bool voted;
        //index of the proposal that the voter voted for; begins with 0
        uint8 vote;
        //address delegate;
    }

    //treat as a class
    //Define the Proposal struct with voteCount property
    struct Proposal{
        //no. of votes that the proposal has received
        uint voteCount; 
        //could add other data about proposal
    }

    //Declare the proposals array
    Proposal[] proposals;
    //keep check which proposal have been voted (count)

    //declare the chairperson's address and the voters mapping
    address chairperson;
    mapping(address => Voter) voters;

    //Create a new ball with $(_numProposals) different proposal
    //For constructor whose code is run only when the contract is created
    constructor(uint8 _numProposals) public {
        //record the wallet address of the deployer
        chairperson = msg.sender; 
        //chairperson have 2 votes
        voters[chairperson].weight = 2;
        proposals.length = _numProposals;
    }

    //Give $(toVoter) the right to vote on this ballot.
    //Only be called by $(chairperson)
    function register(address toVoter) public{
        //only chairperson can register voters
        if (msg.sender!= chairperson || voters[toVoter].voted) return; //do nothing
        voters[toVoter].weight = 1;     //voters only have 1 vote
        voters[toVoter].voted = false; //reset voted status to false
    }

/*  Initial Code for function vote()
    function vote(uint8 toProposal) public{
        Voter storage sender = voters[msg.sender];

        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 
    }

*/
    function vote(uint8 toProposal) public{
        //store it in "storage" for permanent record
        //the address who clicked this function
        Voter storage sender = voters[msg.sender];

        //check whether the voters have voted
        //	|| (Logical OR)
        //Stop the process if the sender has voted or proposalNum out of range
        if (sender.voted || toProposal >= proposals.length) return;
        toProposal --;
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 
    }

/*  //V1 - Initial Code for function winningProposal()
    //determine the winning proposal
    //view mode --> Read only
    function winningProposal() public view returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;

        //Iterate through all proposals to find the one with most votes
        //for loop
        //for prop=0 to proposals.lenth, prop ++ = prop +1 
        for (uint8 prop=0;prop<proposals.length;prop++)

            //if voteCount > 0, e.g. =1
            if (proposals[prop].voteCount > winningVoteCount){
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop+1;
            }
    }

*/ 

    //V2
    //determine the winning proposal
    //view mode --> Read only
    function winningProposal() public view returns 
            (uint8 _winningProposal, uint winningVoteCount) {
        //uint256 winningVoteCount = 0;

        //Iterate through all proposals to find the one with most votes
        //for loop
        //for prop=0 to proposals.lenth, prop ++ = prop +1 
        for (uint8 prop=0;prop<proposals.length;prop++)
            
            if (proposals[prop].voteCount > winningVoteCount){
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop+1;
            }
    }

}
