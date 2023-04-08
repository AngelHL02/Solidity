// SPDX-License-Identifier: MIT

//Demo 1 ---- Single contract
pragma solidity ^0.8.0;

   interface Calculator {
      function getResult() external view returns(uint);
   }

   contract Test is Calculator {

      function getResult() external pure returns(uint){
         uint a = 1; 
         uint b = 2;
         uint result = a + b;
      
      return result;
      }

}

//Demo 2 --- multiple contract (i.e. 2 seperate contract)
pragma solidity ^0.8.0;

   //this contract can interact with contract ChangeState_B
   contract ChangeState_A {
      string message;

      constructor() {
         message = "Hello World!";
      }

      function setMessage(string memory newMessage) public {
         message = newMessage;
      }

      function getMessage() public view returns (string memory) {
         return message;
      }
    
}
