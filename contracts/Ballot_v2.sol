/* Edit History

bug remaining: [] returned by function winningProposal() is 0-based for the indexing

*/

//-------------This code is modified based on Ballot_v1_Albert.sol-------------
//With the use of Stages & Modifiers

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

    Proposal[] proposals;
    address public chairperson;
    mapping(address => Voter) voters;
    address[] registerList;


    //-------------------newly added parts-------------------
    event votingCompleted();

    enum Stage { Init, Reg, Vote, Done }

    uint startTime;
    Stage public stage = Stage.Init; //Keep track of stages

    modifier validStage(Stage reqStage){
        require(stage==reqStage);
        _;
    }
    //--------------------------------------------------------

    constructor(uint8 _numProposals) {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;
        //proposals.length = _numProposals;
        //proposals = Proposal[chairperson].voteCount = _numProposals;
        for (uint8 i = 0; i < _numProposals; i++) {
            proposals.push(Proposal(0));

    //-------------------newly added parts-------------------
        startTime = block.timestamp; 
        stage = Stage.Reg;
    //--------------------------------------------------------
        }

    }

/*   //initial code for function register()
    function register(address toVoter) public validStage(Stage.Reg){
        //if (stage != Stage.Reg) return;
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        if (block.timestamp > (startTime+ 30 seconds)) {
            stage = Stage.Vote;
        }

    }
*/

    function register(address toVoter) public validStage(Stage.Reg) {
        require(msg.sender == chairperson, "Only chairperson can register user");
        require(!voters[toVoter].voted, "Voter voted already.");

        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        registerList.push(toVoter);
        if (block.timestamp > (startTime+ 30 seconds)) {
            stage = Stage.Vote;
        }
    }

/*  function check_proposal_length() public view returns(uint){
        return proposals.length;
    }
*/


/*  //initial code for function vote()
    function vote(uint8 toProposal) public validStage(Stage.Vote){ 
        //if (stage != Stage.Vote) return;
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 

        if (block.timestamp> (startTime+ 30 seconds)) {
            stage = Stage.Done;
            emit votingCompleted();
        }

    }
*/

    function vote(uint8 toProposal) public validStage(Stage.Vote){ 
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Vote completed!");
        require(toProposal <= proposals.length, "Proposal out of range.");
        toProposal --; //toProposal=toProposal-1;
        sender.voted = true;
        sender.vote = toProposal; 
        proposals[toProposal].voteCount += sender.weight; 

        if (block.timestamp> (startTime+ 30 seconds)) {
            stage = Stage.Done;
            emit votingCompleted();
        }

    }


    function check_votes(uint8 index) public view returns (uint voteCount){
        require(index <= proposals.length, "Proposal out of range.");
        index --; //index=index-1;
        voteCount = proposals[index].voteCount;
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

/*  //V2: Also returning the vote count
    function winningProposal() public validStage(Stage.Done) view returns 
            (uint8 _winningProposal, uint winningVoteCount) {
        for (uint8 prop=0;prop<proposals.length;prop++)
            
            //if voteCount > 0, e.g. =1
            if (proposals[prop].voteCount > winningVoteCount){
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
        assert(winningVoteCount>0);
    }

*/

    //V3: Returning array[]
    function winningProposal() public validStage(Stage.Done) view returns (uint[] memory) {
        uint winningMaxVoteCount = 0;
        uint8 countNoOfWinners = 0;

        //iterates over all of the proposals
        //determines the max no. of votes of a proposal
        for (uint prop = 0; prop < proposals.length; prop++) {
            if (proposals[prop].voteCount > winningMaxVoteCount) {
                winningMaxVoteCount = proposals[prop].voteCount;
                countNoOfWinners = 1;
            } //Count the no. of proposal with that max no. of votes
            else if (proposals[prop].voteCount == winningMaxVoteCount) {
                countNoOfWinners++;
            }
        }

        uint[] memory resultListOfWinners = new uint[](countNoOfWinners);

        uint indexWinner = 0;

        //add the indexes of proposal(s) with the max vote count to []
        for (uint i = 0; i < proposals.length; i++) {
            if ((proposals[i].voteCount == winningMaxVoteCount) && (winningMaxVoteCount != 0)){
                resultListOfWinners[indexWinner] = i;
                indexWinner++;
            }
        }

        assert(resultListOfWinners.length>0);
        return resultListOfWinners;

    }


/*  //function winningProposal() suggested by ChatGPT 
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

    uint indexWinner = 1;

    for (uint i = 0; i < proposals.length; i++) {
        if ((proposals[i].voteCount == winningMaxVoteCount) && (winningMaxVoteCount != 0)){
            resultListOfWinners[indexWinner] = i + 1;
            indexWinner++;
        }
    }

    return resultListOfWinners;}

*/

}