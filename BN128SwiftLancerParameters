pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./BN128.sol";

contract SwiftLancerParameters {
    
    BN128.G1Point public g;
    BN128.G1Point public h;
    
    constructor () public{
        g = BN128.G1Point(1, 2);
        h = BN128.G1Point(3634438038334568835715189831068632811656243564959816416374518361231435341139,1034875716659447573486482265881998115422760625020974129703615029235296611037);
    }
    
    function get_g () view returns (BN128.G1Point memory) {
        return g;
    }
    
    function get_h () view returns (BN128.G1Point memory) {
        return h;
    }
    
}
