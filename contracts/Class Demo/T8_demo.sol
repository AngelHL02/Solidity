// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.9;

contract test{

    struct Voter {
        uint weight; 
        bool voted; 
        uint8 vote; 
    }

    address public chairperson; 
    mapping(address => Voter) voters;

    //Example
    constructor() public {
    chairperson = msg.sender;}

    modifier onlyBy(address _account){ 
        require(chairperson == _account);
        _;
    }

    function register(address toVoter) public onlyBy(chairperson) {
        if (voters[toVoter].voted) revert(); 
        voters[toVoter].weight = 1; 
        voters[toVoter].voted = false;
        }

}