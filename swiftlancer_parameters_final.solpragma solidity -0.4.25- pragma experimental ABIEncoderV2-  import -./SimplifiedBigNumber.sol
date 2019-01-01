pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "./SimplifiedBigNumber.sol";

contract SwiftLancerParameters {
    
    BigNumber.instance public g;
    BigNumber.instance public h;
    BigNumber.instance public p;
    
    constructor () public{
        bytes memory g_val = hex"3d18c64b862beb04ecd05ba788a5aa57877bedaf24380d7d73335927c07461b7d435ed96b597f79b479b0014e8552da81b52f9dbb23b1599f84aa6cd49f6a93cae96708bde27a57f5193429711ac74f2befb85adae6b5365855ea417613813dccabbe535d04f043f3bb6a9b3b3574e58f82d30e9019ea6bc2e09f3d27123e51b90c13f55f51067563ba0589947e94893eab7676c70bfc6d587f0a20363bcb2e06b0b72faff29cc6ab0a52116017a8a29df7c82d77e8a21de50bdc706c9b6c9e1ad98aa40b1c0970d2278604f8d8fc67081d860a677ace7d8f2baa14d51887e2d5b85bdffc2e820c24a89674fa07bae629dae46810a477e3b1244cba88b59010d";
        bytes memory h_val = hex"68f99baf7006ba11870b10a34945bf3901886c1e5f94caf9097d1efb77ba64c40883ec380ac1167ab15a9acaf64d994d74c0a7a0066bd34717c6aa71eb1a515da37cc6ebaebf23811e8ad437927de44b7662946b9f112d19152de685341d20afdf89c37461e0ceeb81cdf493753c7d8ce0e3c327d48b2fddf3966ab414d57a33e4d6f9ac88ba574953bd85a21942da63274f92a78ca3e94165ac696b209be0e4fbe9918b7b568a4dce48b176e3faef3547f25c30188ca38f1ca332463f9a408606d05643383e9db516a3d5c50dab465a17d17120f2fa26b0460b42fe9288e6a8453ccc10eb5d7cc7fb00763533d502900df8ab7413e29139c85fefb1509cd9f9";
        bytes memory p_val = hex"d295fa41d34eeee303f972b94c20941295c6d5684c78f04304f50a146f2856b3042c56dce82d1c126e03b623b87aae58e073073bdc540f6668f584220bd6ed49ce0e9c3145e75fe6e677405b55ed52487337f35115912daa1d6806d0544df97ecea65e9a968897aca0a473c0abe1986326596bfe6fa1422ec445908821dca46e32aba8038a248b0d8bc3f4a40bc9cc80299c4ae258a4d785d3f20831435f446d49004425b787e1214c14769f60625053809602881a7eac6bcd064b662e1f9ed937164387a721ad382ea0abdb8d184953653e9fd1d5560e7f9e8cb4b7e05091767e76a4be0d9ae268334da70a1a2ec0d49c6cfe8257222554dffacf884d568063";
        uint g_bitlen = 2046;
        uint h_bitlen = 2047;
        uint p_bitlen = 2048;
        g = BigNumber.instance(g_val,g_bitlen);
        h = BigNumber.instance(h_val,h_bitlen);
        p = BigNumber.instance(p_val,p_bitlen);
    }
    
    function get_g () returns (BigNumber.instance memory) {
        return g;
    }
    
    function get_h () returns (BigNumber.instance memory) {
        return h;
    }
    
    function get_p () returns (BigNumber.instance memory) {
        return p;
    }
    
}
