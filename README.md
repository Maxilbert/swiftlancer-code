# swiftlancer-code

One deployed instance at Ropsten network (over Zp*)
https://ropsten.etherscan.io/address/0x246c243ed4cbbf2d3f7e807b44ba5edda40382a7

Worker 0 (0xbeef1bed3677fe070591074de013cd371b121027): 7.52 M gas

Worker 1 (0xec1f5acd361e439ad1db6d1d7708341460b9439d): 7.49 M gas 

Worker 2 (0x516d5bb41339db0fc24c47dc5bcca8c38b21775d): 7.49 M gas 

Worker 3 (0xeb00e4c95368d1f7f440d304a0084de5904f17e1): 7.49 M gas 

Rquester (optimistic case): 3.58 M gas for the whole protocol

Rquester (worst case): average  3*(1.3+1.9)/2 M gas to reject per each submission



The other deploy instance at Ropsten network (over the G1 subgroup of alt_bn 128)
https://ropsten.etherscan.io/address/0xf4e7866074045fc20226f84cc13e32d15b124dc3

Worker 0 (0xbeef1bed3677fe070591074de013cd371b121027): 3.61 M gas

Worker 1 (0xec1f5acd361e439ad1db6d1d7708341460b9439d): 3.59 M gas 

Worker 2 (0x516d5bb41339db0fc24c47dc5bcca8c38b21775d): 3.59 M gas 

Worker 3 (0xeb00e4c95368d1f7f440d304a0084de5904f17e1): 3.59 M gas 

Rquester (optimistic case): 2.12 M gas for the whole protocol

Rquester (worst case): average  (0.141+0.184+0.199) = 0.524 M gas to reject per each submission
