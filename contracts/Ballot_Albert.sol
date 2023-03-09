//another fix of the out of gas:
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
    }
    
    struct Proposal {
        uint voteCount;
    }

    //Proposal[] public proposals;
    Proposal[] proposals;
    address public chairperson;
    mapping(address => Voter) public voters;
    address[] public registerList;

    constructor(uint8 _numProposals) {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        //proposals = Proposal[chairperson].voteCount = _numProposals;
        for (uint8 i = 0; i < _numProposals; i++) {
            proposals.push(Proposal(0));
        }
    }

    event Sent(string message);

    function register(address toVoter) public {
        require(msg.sender == chairperson, "Only chairperson can register user");
        require(!voters[toVoter].voted, "Voter voted already.");
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        registerList.push(toVoter);
    }

    function vote(uint8 toProposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Vote completed!");
        require(toProposal < proposals.length, "Proposal out of range.");
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 
    }

    function check_votes(uint8 index) public view returns (uint voteCount){
        require(index < proposals.length, "Proposal out of range.");
        voteCount = proposals[index].voteCount;
    }

    function winningProposal() public view returns (uint[] memory) {
        uint winningMaxVoteCount = 0;
        uint8 countNoOfWinners = 0;

        for (uint prop = 0; prop < proposals.length; prop++) {
            if (proposals[prop].voteCount > winningMaxVoteCount) {
                winningMaxVoteCount = proposals[prop].voteCount;
                countNoOfWinners = 1;
            } else if (proposals[prop].voteCount == winningMaxVoteCount) {
                countNoOfWinners++;
            }
        }

        uint[] memory resultListOfWinners = new uint[](countNoOfWinners);

        uint indexWinner = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if ((proposals[i].voteCount == winningMaxVoteCount) && (winningMaxVoteCount != 0)){
                resultListOfWinners[indexWinner] = i;
                indexWinner++;
            }
        }

        return resultListOfWinners;
    }
    
    function return_registeredList() public view returns (address[] memory) {
        // Create a dynamic array to store the registered voters
        address[] memory registeredVoters = new address[](registerList.length);

        // Iterate through the array of registered voters and add each one to the array
        for (uint i = 0; i < registerList.length; i++) {
            address voterAddress = registerList[i];
            if (voters[voterAddress].weight > 0) {
                registeredVoters[i] = voterAddress;
            }
        }
        return registeredVoters;
    }
}