pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;
    
    var leafSize = 2**n; 
    component poseidon[leafSize-1];
    var tree[2**(n+1)-1];

    for (var i = 0; i < leafSize; i++) {
        tree[i] = leaves[i];
    }  
  
    for(var i=0; i< leafSize - 1; i++){
	poseidon[i] = Poseidon(2);
	poseidon[i].inputs[0] <== tree[2*i];
	poseidon[i].inputs[1] <== tree[2*i+1];
	tree[leafSize + i ] = poseidon[i].out;
	}

    root <== poseidon[leafSize- 2].out;  
    
    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal
    
    
    component poseidon[n];
    
    var hashValues[n+1];
    hashValues[0] = leaf;
  

    for (var i = 0; i < n; i++){
	poseidon[i] = Poseidon(2);
	poseidon[i].inputs[1] <== (hashValues[i] - path_elements[i])*path_index[i]+ path_elements[i];//if path element in left, path_index 0 so, path element is first element
        poseidon[i].inputs[0] <== (path_elements[i] - hashValues[i])*path_index[i]+ hashValues[i];
//if path element in right, path index 1, so path element as second element
	hashValues[i+1] = poseidon[i].out;
}


         root <== poseidon[n-1].out;
    
    //[assignment] insert your code here to compute the root from a leaf and elements along the path
}
