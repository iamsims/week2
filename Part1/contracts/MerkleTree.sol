//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
	//for a 8 blank leaves we need 2**4 - 1 nodes
	for (uint256 i = 0; i < 15; i++) {
            hashes.push(0);
        }
        // [assignment] initialize a Merkle tree of 8 with blank leaves
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
	hashes[index] = hashedLeaf;
	
	uint256 offset = 0; 
	for (uint256 i=8; i<15;  i++){
	     hashes[i] = PoseidonT3.poseidon([hashes[offset*2], hashes[offset*2+1]]);
	     offset++; 

	}

	root = hashes[14];
	index += 1;
 
        // [assignment] insert a hashed leaf into the Merkle tree

	}

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

	bool valid = verifyProof(a, b, c, input);

        return valid && input[0] == root;

        // [assignment] verify an inclusion proof and check that the proof root matches current root
    }
}
