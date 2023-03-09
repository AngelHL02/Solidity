// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract Simple {
    //returning 2 values (dervied variables)
    function arithmetic(uint a, uint b) //unit-->non-negative int
        public //set visibility
        pure //no state variable will be changed or read
        //doc: https://ethereum.stackexchange.com/questions/3285/how-to-get-return-values-when-a-non-view-function-is-called

        returns (uint sum, uint product)
    {
        return (a + b, a * b);
        //* Or, can present in the following form
        //sum = a + b;
        //product = a * b;
        //
    }
}

//code from doc:
//https://solidity-by-example.org/view-and-pure-functions/