// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
//pragma solidity >=0.5.9 <0.7.0;

contract Coin {

    //the keyword "public" makes those variables readable from outside -- state var
    address public minter;
    //keep check of balances
    mapping (address => uint) public balances; 

    //broadcast to anyone who is interested 
    //events allows light clients to react on changes efficiently
    event Sent(address from, address to, uint amount);

    //For constructor whose code is run only when the contract is created
    constructor(){
        //whoever uses the address to create the contract
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public{
        //set limitation: only the minter can mint coin
        if (msg.sender!= minter) return; //will not be executed
        balances[receiver] += amount;
    }

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

} 

//----------------------Debug required----------------------
contract time_convert{

    function timestampToDate(uint256 timestamp) public pure returns (string memory) {
        return timeConverter(timestamp, "%d-%m-%Y %H:%M:%S");
    }

    function timeConverter(uint256 _timestamp, string memory _format) internal pure returns (string memory) {
        bytes32 month;
        uint256 year;
        uint256 monthNumber;
        uint256 day;
        uint256 hour;
        uint256 minute;
        uint256 second;

        assembly {
            //year := (_timestamp / 31556926) + 1970;
            monthNumber := div(sub(_timestamp, add(mul(year, 31556926), 2678400)), 2678400);
            day := div(sub(_timestamp, add(add(mul(year, 31556926), mul(monthNumber, 2678400)), 86400)), 86400);
            hour := div(sub(_timestamp, add(add(add(mul(year, 31556926), mul(monthNumber, 2678400)), mul(day, 86400)), mul(hour, 3600))), 3600);
            minute := div(sub(_timestamp, add(add(add(add(mul(year, 31556926), mul(monthNumber, 2678400)), mul(day, 86400)), mul(hour, 3600)), mul(minute, 60))), 60);
            second := mod(sub(_timestamp, add(add(add(add(mul(year, 31556926), mul(monthNumber, 2678400)), mul(day, 86400)), mul(hour, 3600)), mul(minute, 60))), 60);
        }

        // Convert month number to name
        if (monthNumber == 1) {
            month = "Jan";
        } else if (monthNumber == 2) {
            month = "Feb";
        } else if (monthNumber == 3) {
            month = "Mar";
        } else if (monthNumber == 4) {
            month = "Apr";
        } else if (monthNumber == 5) {
            month = "May";
        } else if (monthNumber == 6) {
            month = "Jun";
        } else if (monthNumber == 7) {
            month = "Jul";
        } else if (monthNumber == 8) {
            month = "Aug";
        } else if (monthNumber == 9) {
            month = "Sep";
        } else if (monthNumber == 10) {
            month = "Oct";
        } else if (monthNumber == 11) {
            month = "Nov";
        } else if (monthNumber == 12) {
            month = "Dec";
        }

        // Format the date and time string
        return string(abi.encodePacked(
            formatInt(day, 2), "-", month, "-", formatInt(year, 4), " ", formatInt(hour, 2), ":", formatInt(minute, 2), ":", formatInt(second, 2)
        ));
    }

    function formatInt(uint256 _num, uint256 _length) internal pure returns (string memory) {
        bytes32 result;
        assembly {
            result := mload(0x40)
            mstore(result, _num)
            mstore(0x40, add(result, 32))
        }
        bytes memory numBytes = abi.encodePacked(result);
        string memory numString = string(numBytes);
        if (bytes(numString).length < _length) {
            numString = string(abi.encodePacked("0", numString));
        }
        return numString;
    }
}
