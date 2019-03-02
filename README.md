# swiftlancer-code

## One deployed instance at Ropsten network (over the even subgroup of Zp*)
https://ropsten.etherscan.io/address/0xb33aabd8301244f68346f8845f05935e77cb9c2f

Worker 0 (0xbeef1bed3677fe070591074de013cd371b121027): 7.52 M gas

Worker 1 (0xec1f5acd361e439ad1db6d1d7708341460b9439d): 7.49 M gas 

Worker 2 (0x516d5bb41339db0fc24c47dc5bcca8c38b21775d): 7.49 M gas 

Worker 3 (0xeb00e4c95368d1f7f440d304a0084de5904f17e1): 7.49 M gas 

Rquester (optimistic case): 3.58 M gas for the whole protocol

Rquester (worst case): average  3*(1.3+1.9)/2 M gas to reject per each submission


## The other deploy instance at Ropsten network (over the G1 subgroup of alt_bn 128 ec)
https://ropsten.etherscan.io/address/0xb8eeb62d9d77a06aac25581bb78563cbc3916780

Worker 0 (0xbeef1bed3677fe070591074de013cd371b121027): 3.49 M gas

Worker 1 (0xec1f5acd361e439ad1db6d1d7708341460b9439d): 3.48 M gas 

Worker 2 (0x516d5bb41339db0fc24c47dc5bcca8c38b21775d): 3.48 M gas 

Worker 3 (0xeb00e4c95368d1f7f440d304a0084de5904f17e1): 3.48 M gas 

Rquester (optimistic case): 2.0 M gas for the whole protocol

Rquester (worst case): average  (0.141+0.184+0.199) = 0.524 M gas to reject per each submission


## An incorrect implementation also deployed at Ropsten network in the earlier
https://ropsten.etherscan.io/address/0xac570542f9837c3f413280cc75c2adae9ce09e2b

The errors of the earlier implementation include but not limit to:

1. The public key algorithms are implemented over the group of Zp*, where DDH assumption does not hold;

2. The answer of each worker is broken into 106 transactions;

3. There is no user authentication procedures to protect against Sybil attackers.

Here we highlight that this repository resovles all the above issues by doing significant efforts. Not only the security issues are fixed, but also the overall on-chain cost is reduced to only half of the earlier incorrect implementation.
