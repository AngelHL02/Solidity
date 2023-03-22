//Week 5
pragma solidity ^0.5.9; 

contract Bidder {
    
    string public name = "Oliver";
    uint public bidAmount;
    bool public eligible;
    uint constant minBid = 1000;
     
    function setName(string memory nm) public {
        name = nm;
        //update the name of the Bidder
    }
    
    function setBidAmount(uint x) public {
        bidAmount  = x;
        //set a bidding amount
    }
  
    function determineEligibility() public {
        if (bidAmount >= minBid ) eligible = true;
        else eligible = false;
        //if the amount is > 1000 then update the eligibe to true otherwise set it to false
    }
}
