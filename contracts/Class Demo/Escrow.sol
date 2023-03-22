//T9 -- 17 Mar Demo
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Escrow{

/*
State variables: Declare public variables for buyer, seller, arbitrator 裁決人,
price and an enum for the contract state.

Seller: This is an address payable type variable that holds the Ethereum
address of the seller.

Price: This is a uint type variable that represents the agreed-upon price
of the transaction in Ether.

*/

    address payable public buyer;
    address payable public seller;
    address public arbitrator;
    uint public price;

    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE,REFUNDED}
    State public currentState;

    //Modifiers: Define access control modifiers for buyers, sellers and
    // contract state
    modifier buyerOnly(){
        require(msg.sender == buyer,"Only buyer can call this.");
        _;
    }

    modifier sellerOnly(){
        require(msg.sender == seller,"Only buyer can call this.");
        _;
    }

    modifier inState(State expectedState){
        require(currentState == expectedState,"Invalid state.");
        _;
    }

/*  Constructor(): Initializes the contract with the buyer, seller, arbitrator,
    and price.

    You don't need to deposit Ether when calling the constructor.

    The constructor is called when the contract is deployed to the Ethereum
    network.

    The initializes the contract with the provided buyer, seller, arbitrator,
    and price parameters.

    The buyer will need to deposit Ether when calling the deposit() function,
    which is separate from the constructor.

*/

    constructor (address payable _buyer, address payable _seller, 
        address _arbitrator, uint _price){
            buyer = _buyer;
            seller = _seller;
            arbitrator = _arbitrator;
            price = _price*(1 ether);

/*
            arbitrator = msg.sender; 
            //the level of trust required among the participants. 
            //If the creator of the contract is a trusted entity. 
            buyer = payable(msg.sender);
            //this design choice ties the contract creator to the buyer role,
            //so it may not be suitable for all use cases. 
 */

        }

/*  deposit(): Allow the buyer to deposit the payment, only callable by the buyers
    and in the  AWAITING_PAYMENT state.

    During the deposit() function call, the buyer will send the required Ether (= price)
    along with the transaction,

    and the contract will update its state accordingly.

*/

    function deposit() external payable buyerOnly inState(State.AWAITING_PAYMENT){
            require(msg.value==price, "Incorrect amount.");
            currentState = State.AWAITING_DELIVERY;
    }

/*  confirmDelivery(): Allows the buyers to confirm delivery, transferring the payment
    to the seller.

    Callable only by the buyer and in the AWAITING_DELIVERY state.

*/

    function confirmDelivery() external payable buyerOnly inState(State.AWAITING_DELIVERY){
            currentState = State.COMPLETE;
/*  transfer(): This is a built-in Solidity function that allows transferring Ether from 
    an address payable type variable to another address.

    When this function is called on an address payable variable, it sends the specified 
    amount of Ether to that address.

    seller.transfer(price) is a statement that transfers the specified price in Ether
    from the contract's balance to the seller address.

*/
            seller.transfer(price);
    }

    //Allows the sellers to refund the buyer, only callable by the seller and in the
    //AWAITING_DELIVERY state
    function refundBuyer() external sellerOnly inState(State.AWAITING_DELIVERY){
            currentState = State.REFUNDED;
    //seller.transfer(price) is a statement that transfers the specified price in Ether
    //from the contract's balance to the buyer address.
            buyer.transfer(price);
    }

    function seller_bal() external 

}

/*
    This escrow smart contract enables a secure transactiom between a buyer and a seller
    with the assistance of an arbitrator.

    The buyer deposits a funds, and the seller can either confirm the delivery or refund
    the buyer
*/
