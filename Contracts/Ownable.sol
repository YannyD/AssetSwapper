pragma solidity >=0.6.0 <0.8.0;

contract Ownable{
    address public owner;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _; //Continue execution
    }

    constructor() public{
        owner = msg.sender;
    }
}