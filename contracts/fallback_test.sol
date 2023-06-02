// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
/// @title A contract for demonstrate fallback function
/// @author Jitendra Kumar
/// @notice For now, this contract just show how to fallback function receive all the ether

//executed if none of the other functions match the function identifier or no data was provided with the function call

contract GeeksForGeeks
{
	string public calledFallbackFun;

	// This fallback function
	// will keep all the Ether
	fallback() external payable{
		calledFallbackFun="Fallback function is executed!";
	}

	function getBalance() public view returns (uint) {
		return address(this).balance;
	}
}

// Creating the sender contract
contract Sender
{
	function transferEther() public payable
	{
		//paste the deployed contract address of GeeksForGeeks smart contract here
		//(bool sent, ) = payable(0xD4Fc541236927E2EAf8F27606bD7309C1Fc2cbee).call{value: 2 ether}("Transaction Completed!");
        (bool sent, ) = payable(0xd9145CCE52D386f254917e481eB44e9943F39138).call{value: 2 ether}("Transaction Completed!");
		require(sent, "Transaction Failed!");
	}

	function getBalance() public view returns (uint) {
		return address(this).balance;
	}
}
