pragma solidity ^0.4.25;
//pragma experimental ABIEncoderV2;

import "./BN128.sol";


contract RegistrationAuthority {
    
    address public authority;
    mapping(address => bool) public users;
    
    constructor () public {    }
    //function add (address user) public  {}
    //function revoke (address user) public { }
    
}


contract SwiftLancer{
        
    using BN128 for *;

    event FillGold(string a);
    
    event debug (bool a);
    
    event OpenGold(string b);
    
    event PlainTextProof(string a);
    
    event Ciphertexts(
        uint c1_x,
        uint c1_y,
        uint c2_x,
        uint c2_y
    );
    
    address public requester;
    
    //SwiftLancerParameters parameters;
    RegistrationAuthority ra;
    
    // answers of workers
    struct answers {
        bytes32[106] ciphers;
        uint[3] err_indexes;
        uint err_counter;
    }
    
    struct GoldenStandard{
        bytes32[6] index_val;
        bytes32[6] sol_val;
        uint ctr;
    }
    
    GoldenStandard public gs;
    
 
    uint[6] public actual_gold_indices;
    uint[6] public actual_gold_solutions;
    

    bytes32 public task_swarm_addr = 0xb833be6d483c981488a6b0f32fd133f9f7b8810a9663becb38359c1731210529;
    //https://swarm-gateways.net/bzz:/b833be6d483c981488a6b0f32fd133f9f7b8810a9663becb38359c1731210529/
    mapping(address => answers) public answers_map;
    address[4] public workers = [0,0,0,0];
    uint public workers_counter = 0;
    
    constructor () public{
        //parameters = SwiftLancerParameters(0x7b3dc9590d8ecfd98adfb7490d6a51a93e91658d);
        ra = RegistrationAuthority(0x8884A1aca7D2F031d674994232c10Ba64fC33903);
        requester = msg.sender;
    }
    
    //filling the golden standard commitments with indices and their respective solutions
    function fill_golden(bytes32[6] i_val, bytes32[6] s_val){
        require(msg.sender == requester);
        gs.index_val = i_val;
        gs.sol_val = s_val;
        emit FillGold("Gold array filled!");
    }
    
    // opening the commitments and checking if it matches with the committed values
    function opening_phase(uint[] indices, uint[] sols, uint r_val) returns (bool){
        //require(msg.sender == requester);
        for (uint i=0;i<6;i++) {
            bytes32 lhs1 = sha3(sha3(indices[i]), sha3(r_val));
            bytes32 lhs2 = sha3(sha3(sols[i]), sha3(r_val));
            
            if((lhs1 == gs.index_val[i]) && (lhs2 == gs.sol_val[i])){
                actual_gold_indices[i] =  indices[i];
                actual_gold_solutions[i] = sols[i];
                emit OpenGold("Commitment to index and sol correct!");
                continue;
            }
            else{
                emit OpenGold("Commitment to index and sol false!");
                return false;
            }
        }
        return true;
    }
    
    
    // different plaintext proof for proving that worker did not provide correct solution of golden standard questions
    function different_plaintext_proof(uint c1_x, uint c1_y, uint c2_x, uint c2_y, uint q_index, address worker, uint a_x, uint a_y, uint z) returns (bool){
        for (uint i=0; i<6; i++) {
            if(q_index == actual_gold_indices[i]){
                if (answers_map[worker].err_indexes[0] == q_index) {
                    return false;
                }
                if (answers_map[worker].err_indexes[1] == q_index) {
                    return false;
                }
                if (answers_map[worker].err_indexes[2] == q_index) {
                    return false;
                }
                if(answers_map[worker].ciphers[q_index] == sha3(c1_x, c1_y, c2_x, c2_y)) {
                    if (check_proof(c1_x, c1_y, c2_x, c2_y, a_x, a_y, z, 1-actual_gold_solutions[i])) {
                        answers_map[worker].err_indexes[answers_map[worker].err_counter] = q_index;
                        answers_map[worker].err_counter += 1;
                        emit PlainTextProof("Different Plaintext Verified!");
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    return false;
                }
            }
        }
        return false;
    }
    
    
    //
    function check_proof(uint c1_x, uint c1_y, uint c2_x, uint c2_y, uint a_x, uint a_y, uint z, uint m) internal returns(bool) {
        uint c = prepare_nizk_challenge(a_x, a_y);
        BN128.G1Point memory rhs = different_plaintext_proof_rhs(c2_x, c2_y, a_x, a_y, c);
        BN128.G1Point memory lhs = different_plaintext_proof_lhs(c1_x, c1_y, z);
        if(m == 1) {
            BN128.G1Point memory M = BN128.mul(BN128.G1Point(1, 2), c);
            BN128.G1Point memory lhs1 = BN128.add(M, lhs);
            return (lhs1.X == rhs.X && lhs1.Y == rhs.Y);
        }
        return (lhs.X == rhs.X && lhs.Y == rhs.Y);
    }
    
    
    // 
    function prepare_nizk_challenge(uint a_x, uint a_y) internal pure returns (uint) {
        return (uint(keccak256(a_x, a_y)) >> 130);
    }
    
    
    // computing left hand side of the different plaintext proof
    function different_plaintext_proof_lhs(uint c1_x, uint c1_y, uint z) internal returns (BN128.G1Point memory) {
        BN128.G1Point memory c1 = BN128.G1Point(c1_x, c1_y);
        return BN128.mul(c1, z);
    }
    
    
    // computing right hand side of the different plaintext proof
    function different_plaintext_proof_rhs(uint c2_x, uint c2_y, uint a_x, uint a_y, uint c) internal returns (BN128.G1Point memory) {
        BN128.G1Point memory c2 = BN128.G1Point(c2_x, c2_y);
        BN128.G1Point memory a = BN128.G1Point(a_x, a_y);
        return BN128.add(a, BN128.mul(c2, c));
    }
    
    
    // workers submitting answers to the contract
    //function submit_answers(uint[106] memory i, uint[106] memory c1_x, uint[106] memory c1_y, uint[106] memory c2_x, uint[106] memory c2_y) {
    function submit_answers(uint[106] memory c1_x, uint[106] memory c1_y, uint[106] memory c2_x, uint[106] memory c2_y) public returns (bool) {
        address worker = msg.sender;
        require (ra.users(worker));
        bytes32 hash = keccak256(c1_x[j],c1_y[j],c2_x[j],c2_y[j]);
        emit Ciphertexts(c1_x[j],c1_y[j],c2_x[j],c2_y[j]);
        answers memory hisAnswers;
        hisAnswers.ciphers[0] = hash;
        answers_map[worker] = hisAnswers;
        for (uint j = 1; j < 106; j++) {
            hash = keccak256(c1_x[j],c1_y[j],c2_x[j],c2_y[j]);
            emit Ciphertexts(c1_x[j],c1_y[j],c2_x[j],c2_y[j]);
            answers_map[worker].ciphers[j] = hash;
        }
        for (uint i = 0; i < workers_counter; i ++) {
            if (workers[workers_counter] == worker) {
                return false;
            }
        }
        if (workers_counter < 4) {
            workers[workers_counter] = worker;
            workers_counter += 1;
            answers_map[worker].err_indexes = [106,106,106];
        }
        return true;
    }
    
    //function validate (address worker) constant returns (bool status) {
    //    return(ra.users(worker));
    //}


}
