 // SPDX-License-Identifier: UNLICENSED
 pragma solidity ^0.8.7;

 interface ChangeState {
     function setMessage(string memory newMessage) external;

     function getMessage() external view returns (string memory);
 }

 contract Interact {

     address contractAddress;

     function setAddress(address _Addr) public {
         contractAddress = _Addr;
     }

     function getMessage() public view returns (string memory) {
         return ChangeState(contractAddress).getMessage();
     }

     function changeMessage(string memory newMessage) public {
         ChangeState(contractAddress).setMessage(newMessage);
     }  
 }