//-------------This code is modified based on Ballot_v1.sol-------------
//Voting system

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.9;

contract Ballot {
    struct Voter {
        uint weight; 
        bool voted; 
        uint8 vote; 
    }

    // Define the Proposal struct with voteCount property
    struct Proposal {
        // No. of votes that the proposal has received
        uint voteCount; 
        // Could add other data about proposal
    }

    // Declare the proposals array
    Proposal[] proposals; 

    enum Stage { Init, Reg, Vote, Done }

    // Declare the chairperson's address and the voters mapping
    address chairperson; 
    mapping(address => Voter) voters;

    uint startTime;
    Stage public stage;

    constructor(uint8 _numProposals) public {
        chairperson = msg.sender; 
        voters[chairperson].weight = 2; 
        proposals.length = _numProposals;
        startTime = now;
        stage = Stage.Init;
    }

    event Sent(string message);

    function register(address toVoter) public {
        if (stage != Stage.Reg) return;
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;    
        voters[toVoter].voted = false;

        // Move to voting stage after 10 seconds of registration
        if (now > (startTime + 10 seconds)) {
            stage = Stage.Vote;
            startTime = now;
        }
    }

    function vote(uint8 toProposal) public {
        if (stage != Stage.Vote) return;
        Voter storage sender = voters[msg.sender];

        if (sender.voted == true || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 

        // Move to done stage after 10 seconds of voting
        if (now > (startTime + 10 seconds)) {
            stage = Stage.Done;
            startTime = now;
        }
    }

    // Function to show voteCount for a specific proposal
    function check_votes(uint8 index) public view returns (uint voteCount) {
        if (index >= proposals.length) {
            // Handle the error by returning a default value or throwing an exception
            // In this case, we return 0 as the default value
            return 0;
        }
        voteCount = proposals[index].voteCount;
    }

    // Returning an array of tie winners
    function winningProposal() public view returns (uint[] memory _results) {
        uint winningMaxVoteCount = 0;
        uint8 countNoOfWinners = 0;

        // Determines the maximum vote count
        for (uint prop = 0; prop < proposals.length; prop++) {
            if (proposals[prop].voteCount > winningMaxVoteCount) {
                winningMaxVoteCount = proposals[prop].voteCount;
                countNoOfWinners = 1;
            } else if (proposals[prop].voteCount == winningMaxVoteCount) {
                countNoOfWinners++;
            }
        }

        // Create a new array to store the indexes of the maximum values
        // countNoOfWinners is the length of the newly created dynamic array
        uint[] memory resultListOfWinners = new uint[](countNoOfWinners);

        uint indexWinner = 0;

        // Loop through the array again to find the indexes of the maximum values
        for (uint i = 0; i < proposals.length; i++) {
            if ((proposals[i].voteCount == winningMaxVoteCount) && (winningMaxVoteCount != 0)){
                // Stores those indexes in the array: resultListOfWinners
                resultListOfWinners[indexWinner] = i;
                indexWinner++;
            }
        }
        return _results = resultListOfWinners;
    }
    

    function done() public {
        if (msg.sender != chairperson) return;
        stage = Stage.Done;
    }
}