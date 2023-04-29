// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Bidder { //contract name
    //declare variables
    string public name; //state var

    uint public bidAmount = 20000; //state var 
    //as the exact size of uint not defined, by default use 256 bit (size) to store value

    bool public eligible; //state var
    //default: False

    //this variable cannot be changed during the running of program
    uint constant minBid = 1000; //unsigned integer (positive values only). 

    //End of declaring variables
    //-------------------------------------------------------

    //function to set (new) name
    function setName(string memory nm) public{ //nm = abv. of name
    //specify input_datatype/storage_location/name_var
    //set visibility as public to allow interacting with the web-free user interface
        name = nm; //change the name to the new name inputted (var_name = nm)
    }  

    //function to update the bidAmount (value)
    function setBidAmount(uint8 x) public { //x stands for input
    //x is not declared as memory in memory
    //By default, arguments are always in memory
        bidAmount = x;
    }

    //function to determine eligibility
    //determine if the bidder is eligible to bid or voted
    //no input required

/*
    //Approach 1 (Self)
    function determineEligibility() public returns (bool){
        if (bidAmount >= minBid) {
            eligible = true;
            return true;
        } else {
            eligible = false;
            return false;
        }

    }
*/

    //Approach 2 (Modified by Albert)
    event EligibilityStatus(bool status);

    function determineEligibility() public returns (bool){
    if (bidAmount >= minBid) {
        eligible = true;
        emit EligibilityStatus(true);
        return true;
    } else {
        eligible = false;
        emit EligibilityStatus(false);
        return false;
    }

}

}

