pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./SimplifiedBigNumber.sol";


contract SwiftLancerParameters {
    
    function get_g () returns (BigNumber.instance memory) {}
    
    function get_h () returns (BigNumber.instance memory) {}
    
    function get_p () returns (BigNumber.instance memory) {}
    
}


contract SwiftLancer{
        
    using BigNumber for *;

    event debug(bytes32 a);
    
    event FillGold(string a);
    
    event OpenGold(string b);
    
    event PlainTextProof(string a);
    
    event Ciphertexts(
        bytes c1,
        bytes c2
    );
    
    event Answers_Test(string b);
    
    // answers of workers
    struct answers {
        bytes32[106] ciphers;
        uint counter;
        uint[3] err_indexes;
        uint err_counter;
    }
    
    address public requester;
    uint[6] public actual_gold_indices;
    uint[6] public actual_gold_solutions;
    
    SwiftLancerParameters parameters;
    

    bytes32 public task_swarm_addr = 0xb833be6d483c981488a6b0f32fd133f9f7b8810a9663becb38359c1731210529;
    //https://swarm-gateways.net/bzz:/b833be6d483c981488a6b0f32fd133f9f7b8810a9663becb38359c1731210529/
    
    
    struct GoldenStandard{
        bytes32[6] index_val;
        bytes32[6] sol_val;
        uint ctr;
    }
    
    GoldenStandard public gs;
    
    mapping(address => answers) public answers_map;
    address[4] public workers = [0,0,0,0];
    uint public workers_counter = 0;
    
    constructor () public{
        parameters = SwiftLancerParameters(0xe259adC77c6F214233Ab42e1c10f07ffd3314C64);
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
        for(uint i=0;i<6;i++){
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
    function different_plaintext_proof(bytes memory c1_val, uint c1_bitlen, bytes memory c2_val, uint c2_bitlen, uint q_index, address worker, bytes memory a_val, uint a_bitlen, bytes memory z_val, uint z_bitlen, uint hash_length) returns (bool){
        for(uint i=0; i<6; i++){
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
                if(answers_map[worker].ciphers[q_index] == sha3(c1_val, c2_val)){
                    //emit PlainTextProof("Hashes of Ciphertexts match");
                    if (check_proof(c1_val, c1_bitlen, c2_val, c2_bitlen, a_val, a_bitlen, z_val, z_bitlen, 1 - actual_gold_solutions[i], hash_length)) {
                        answers_map[worker].err_indexes[answers_map[worker].err_counter] = q_index;
                        answers_map[worker].err_counter += 1;
                        emit PlainTextProof("Different Plaintext Verified!");
                        return true;
                    }
                    else {
                        return false;
                    }
                }
                else{
                    //emit PlainTextProof("Hashes of Ciphertexts don't match");
                    return false;
                }
            }
        }
        return false;
    }
    
    
    //
    function check_proof(bytes memory c1_val, uint c1_bitlen, bytes memory c2_val, uint c2_bitlen, bytes memory a_val, uint a_bitlen, bytes memory z_val, uint z_bitlen, uint solexp, uint hash_length) internal returns(bool) {
        BigNumber.instance memory c = prepare_nizk_challenge(a_val, hash_length);
        BigNumber.instance memory p = parameters.get_p();
        BigNumber.instance memory rhs = different_plaintext_proof_rhs(c2_val, c2_bitlen, a_val, a_bitlen, c, p);
        BigNumber.instance memory lhs = different_plaintext_proof_lhs(c1_val, c1_bitlen, z_val, z_bitlen, p);
        if(solexp == 1) {
            lhs = lhs.modmul(parameters.get_g().prepare_modexp(c, p), p);
        }
        return (BigNumber.cmp(lhs, rhs, true) == 0);
    }
    
    
    // 
    function prepare_nizk_challenge(bytes a_val, uint hash_length) internal returns (BigNumber.instance memory) {
        BigNumber.instance memory c = BigNumber.instance(toBytes(sha3(a_val, parameters.get_g().val, parameters.get_h().val)), hash_length);
        return c;
    }
    
    
    // computing left hand side of the different plaintext proof
    function different_plaintext_proof_lhs(bytes c1_val, uint c1_bitlen, bytes z_val, uint z_bitlen, BigNumber.instance memory p) internal returns (BigNumber.instance memory) {
        BigNumber.instance memory z = BigNumber.instance(z_val, z_bitlen);
        BigNumber.instance memory c1 = BigNumber.instance(c1_val, c1_bitlen);
        BigNumber.instance memory lhs = c1.prepare_modexp(z, p);
        return lhs;
    }
    
    
    // computing right hand side of the different plaintext proof
    function different_plaintext_proof_rhs(bytes memory c2_val, uint c2_bitlen, bytes memory a_val, uint a_bitlen, BigNumber.instance memory c, BigNumber.instance memory p) internal returns (BigNumber.instance memory) {
        BigNumber.instance memory a = BigNumber.instance(a_val, a_bitlen);
        BigNumber.instance memory c2 = BigNumber.instance(c2_val, c2_bitlen);
        BigNumber.instance memory rhs = a.modmul( c2.prepare_modexp(c, p), p);
        return rhs;
    }
    
    
    // workers submitting answers to the contract
    function submit_answers(uint[40] memory i, bytes[40] memory c_1, bytes[40] memory c_2) {
        address worker = msg.sender;
        for (uint j = 0; j < 40; j++) {
            bytes32 hash = sha3(c_1[j],c_2[j]);
            emit Ciphertexts(c_1[j], c_2[j]);
            if (i[j] > 0) {
                answers_map[worker].ciphers[i[j]] = hash;
                answers_map[worker].counter += 1;
            } else {
                answers hisAnswers;
                hisAnswers.ciphers[0] = hash;
                answers_map[worker] = hisAnswers;
                answers_map[worker].counter = 1;
            }
            if (answers_map[worker].counter == 106 && workers_counter < 4) {
                workers[workers_counter] = worker;
                workers_counter += 1;
                answers_map[worker].err_indexes = [106,106,106];
            }
        }
    }
    
    
    // workers submitting answers to the contract
    function submit_answers(uint[33] memory i, bytes[33] memory c_1, bytes[33] memory c_2) {
        address worker = msg.sender;
        for (uint j = 0; j < 33; j++) {
            bytes32 hash = sha3(c_1[j],c_2[j]);
            emit Ciphertexts(c_1[j], c_2[j]);
            if (i[j] > 0) {
                answers_map[worker].ciphers[i[j]] = hash;
                answers_map[worker].counter += 1;
            } else {
                answers hisAnswers;
                hisAnswers.ciphers[0] = hash;
                answers_map[worker] = hisAnswers;
                answers_map[worker].counter = 1;
            }
            if (answers_map[worker].counter == 106 && workers_counter < 4) {
                workers[workers_counter] = worker;
                workers_counter += 1;
                answers_map[worker].err_indexes = [106,106,106];
            }
        }
    }

    
    function toBytes(uint256 x) returns (bytes memory b) {
        b = new bytes(32);
        assembly { mstore(add(b, 32), x) }
    }
    
    function toBytes(bytes32 _data) public pure returns (bytes memory) {
        return abi.encodePacked(_data);
    }
}
