pragma solidity ^0.4.25;

contract RegistrationAuthority {
    
    address public authority;
    mapping(address => bool) public users;
    
    
    constructor () public {
        authority = msg.sender;
    }
    

    function add (address user) public  {
        require (msg.sender == authority);
        users[user] = true;
    }


    function revoke (address user) public {
        require (msg.sender == authority);
        users[user] = false;
    }
    
    
}
