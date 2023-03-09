// SPDX-License-Identifier: MIT
pragma solidity ^0.5.11;

contract Game {
    address payable owner;
    address payable playerA;
    address payable playerB;
    uint256 amount;
    bool gameWon;
    
    constructor() public {
        owner = msg.sender;
        amount = 1000 ether;
    }
    
    function setPlayerA(address payable _playerA) public {
        require(msg.sender == owner, "Only owner can set player A");
        playerA = _playerA;
    }
    
    function setPlayerB(address payable _playerB) public {
        require(msg.sender == owner, "Only owner can set player B");
        playerB = _playerB;
    }
    
    function announceWinner(bool _gameWon) public {
        require(msg.sender == owner, "Only owner can announce the winner");
        gameWon = _gameWon;
        if (gameWon) {
            playerB.transfer(amount);
        }
    }
}