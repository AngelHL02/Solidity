// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*This smart contract is a simple blockchain implementation that creates a GoofyCoin cryptocurrency. 
It uses structs to represent blocks in the chain, and an array to store all the blocks. 
It also uses a mapping to store the balance of each address and an event to log when coins are sent. 
The constructor function creates the genesis block when the contract is deployed. 
The addBlock function allows users to add new blocks to the chain and update their balance. 
The send function allows users to send coins to other addresses. 
The queryBalance function allows users to check the balance of a specific address, 
and the isValid function allows users to check if the chain is valid by checking if the previous hash of each block matches the hash of the previous block.
This code is a work in progress and may contain bugs.
*/


// Defining the GoofyCoin contract
contract GoofyCoin {
    // Defining a struct to represent the block
    struct Block {
        // The index of the block in the chain
        uint index;
        // The timestamp of when the block was created
        uint timestamp;
        // The data stored in the block (in this case, just a string)
        string data;
        // The address of the previous block's hash
        address payable previousHash;
        // The address of the current block's hash
        address payable hash;
    }

    // An array to store all the blocks in the chain
    Block[] public blocks;

    // A mapping to store the balance of each address
    mapping(address => uint) public balances;

    // An event to log when coins are sent
    event LogCoinsSent(address payable sentTo, uint amount);

    // The constructor function that is called when the contract is deployed
    constructor() {
        // Creating the genesis block and adding it to the chain
        blocks.push(createGenesisBlock());
    }

    // A private function to create the genesis block
    function createGenesisBlock() private view returns (Block memory) {
        // Returning a new block with a fixed data and hash value
        return Block(0, block.timestamp, "Genesis Block", payable(address(0x0)), payable(address(bytes20(keccak256("Genesis Block")))));
    }

    // A function to add a new block to the chain
    function addBlock(string memory _data) public {
        // Creating a new block with the provided data
        Block memory newBlock = Block
    (
            blocks.length,  // The index of the new block is the length of the current chain
            block.timestamp, // The timestamp of when the block was created
            _data, // The data provided by the user
            payable(address(blocks[blocks.length - 1].hash)),  // The address of the previous block's hash
            payable(address(bytes20(keccak256(abi.encode(_data, blocks[blocks.length - 1].hash))))));  // The address of the current block's hash, generated using the previous hash and the current data
        // Adding the new block to the chain
        blocks.push(newBlock);
        // Storing the address of the new block's hash
        address payable newBlockHash = newBlock.hash;
        // Updating the balance of the user who created the block
        balances[msg.sender] = uint256(keccak256(abi.encodePacked(newBlockHash)));
    }

    // A function to send coins to another address
    function send(address payable receiver, uint amount) public {
        // Checking if the sender has enough balance to send the coins
        require(balances[msg.sender] >= amount);
        // Decreasing the sender's balance
        balances[msg.sender] -= amount;
        // Increasing the receiver's balance
        balances[receiver] += amount;
        // Logging the event
        emit LogCoinsSent(receiver, amount);
    }

    // A function to query the balance of a specific address
    function queryBalance(address payable addr) public view returns (uint balance) {
        // Returning the balance of the provided address
        return balances[addr];
    }

    // A function to check if the chain is valid
    // This function is a work in progress and may contain bugs
    function isValid() public view returns (bool) {
        // Looping through the blocks in the chain
        for (uint i = 1; i < blocks.length; i++) {
            // Checking if the previous hash of the current block matches the hash of the previous block
            if (bytes20(address(blocks[i].previousHash)) != bytes20(keccak256(abi.encode(blocks[i - 1])))) {
                // If the hashes do not match, return false
                               return false;
            }
        }
        // If the loop completes without returning false, return true
        return true;
    }
}


