// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol"; 

contract SignatureVerification { 

    using ECDSA for bytes32; 

    function verifySignature(bytes32 hash, bytes memory signature, address expectedSigner) public pure returns (bool) { 
        // Recover the signer's address from the hash and signature 

        address signer = hash.recover(signature); 
        // Compare the recovered address with the expected signer 

        return signer == expectedSigner; 

    } 

} 