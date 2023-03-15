//10 Mar Lesson Demo (T8)
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.9;

/* Explanation
    This contract demonstrates the use of an enum to keep track of stages of a process.
    This contract has 4 stages: Init, Reg, Vote,Done, and stage changes are enacted 
    approximately every 1 minute.
    The now Solidity defined variable is used to track time.
    The advanceState function is used to track time
    The advanceState function is used to change the stage when the required time has passed.
    The time duration for each stage can be adjusted based on the specific application required.
*/

contract StateTransV2_AL {

    //Enum to keep track of stages
    enum Stage{Init,Reg,Vote,Done}
    Stage public stage;

    //Varaiables to track time
    uint startTime;
    uint public timeAdv;

    constructor() public {
        stage = Stage.Init;
        startTime = now;
    }

/*  Notes: Stage Change
    - Assuming the Stage change has to be enacted APPROX every 1 minute
    - timeAdv variable is defined for understanding the process
    - you can simply use "now", which is a Solidity defined variable
    Of coz, time duration for the stages may depend on your application

    1 minute is set to illustrate the working
    Advance the stage approximatel every 1 minute
*/

    function CurrentTime() public view returns(uint){
        return now;
    }

    function advanceState() public{
        timeAdv = now;
        if (timeAdv>(startTime+10 seconds)) {
            startTime = timeAdv; //Update the starttime
            //Advance to the next stage
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

