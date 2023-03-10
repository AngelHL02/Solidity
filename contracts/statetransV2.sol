// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.9;

contract StateTransV2 {

    enum Stage{Init,Reg,Vote,Done}
    Stage public stage;
    uint startTime;
    uint public timeNow;

    constructor() public {
        stage = Stage.Init;
        startTime = now;
    }

/*  Notes: Stage Change
    - Assuming the Stage change has to be enacted APPROX every 1 minute
    - timeNow variable is defined for understanding the process
    - you can simply use "now", which is a Solidity defined variable
    Of coz, time duration for the stages may depend on your application
*/

    function advanceState() public{
        timeNow = now;
        if (timeNow>(startTime+1 minutes)) {
            startTime = timeNow;
            if (stage==Stage.Init) {stage = Stage.Reg; return;}
            if (stage==Stage.Reg) {stage = Stage.Vote; return;}
            if (stage==Stage.Vote) {stage = Stage.Done; return;}
            return;

        }
    }

/*  Notes: Use of return statement in the above statement
    The use of "return" in the function advanceState() is to :
    - immediately exit the function
    - return control back to the calling function. 
    
    In this specific contract, the return statement is being used to 
    -> exit the function once a new stage has been set, 
    -> avoiding unnecessary checks and allowing for more efficient execution of the contract.
*/

}

